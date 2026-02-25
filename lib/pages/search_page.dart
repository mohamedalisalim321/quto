import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/my_favorite_card.dart';
import '../components/tag_selector.dart';
import '../databases/quotes_database.dart';
import '../models/quote.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _debounceDuration = Duration(milliseconds: 300);

  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<List<Quote>> _results = ValueNotifier([]);
  final ValueNotifier<bool> _isSearching = ValueNotifier(false);

  Timer? _debounce;
  int _searchToken = 0;

  final List<String> _selectedTags = [];

  final List<String> _recentQueries = [];

  final List<String> _availableTags = const [
    'best',
    'life',
    'love',
    'mistakes',
    'truth',
    'worst',
    'honesty',
    'inspirational',
    'human-nature',
    'humor',
    'infinity',
    'philosophy',
    'science',
    'stupidity',
    'books',
    'soul',
    'be-yourself',
    'confidence',
    'individuality',
    'heaven',
    'hurt',
    'dreams',
    'reality'
  ];

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _results.dispose();
    _isSearching.dispose();
    super.dispose();
  }

  // ------------------------
  // SEARCH HANDLING
  // ------------------------

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, _search);
  }

  Future<void> _search() async {
    final query = _controller.text.trim();
    final token = ++_searchToken;

    if (query.isEmpty && _selectedTags.isEmpty) {
      _results.value = [];
      _isSearching.value = false;
      return;
    }

    _isSearching.value = true;

    final data = await QuotesDatabase.searchQuotesWithTags(
      query: query,
      tags: _selectedTags,
    );

    // Cancel outdated result (race condition fix)
    if (token != _searchToken) return;

    if (query.isNotEmpty && !_recentQueries.contains(query)) {
      _recentQueries.insert(0, query);
      if (_recentQueries.length > 5) {
        _recentQueries.removeLast();
      }
    }

    _results.value = data;
    _isSearching.value = false;
  }

  void _toggleTag(String tag) {
    HapticFeedback.selectionClick();

    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }

    setState(() {});
    _search();
  }

  Future<void> _toggleFavorite(Quote quote) async {
    HapticFeedback.lightImpact();

    quote.isFavorite = !quote.isFavorite;
    _results.notifyListeners();

    try {
      await QuotesDatabase.toggleFavorite(quote.id);
    } catch (_) {
      quote.isFavorite = !quote.isFavorite;
      _results.notifyListeners();
    }
  }

  // ------------------------
  // UI
  // ------------------------

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        _recentChips(),
        TagSelector(
          tags: _availableTags,
          selectedTags: _selectedTags,
          onTagTap: _toggleTag,
        ),
        Expanded(child: _resultsView()),
      ],
    );
  }

  Widget _buildSearchBar() {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(20.r),
        child: TextField(
          controller: _controller,
          onChanged: _onSearchChanged,
          onSubmitted: (_) => _search(),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search quotes or authors...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectedTags.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.filter_alt_off),
                    onPressed: () {
                      _selectedTags.clear();
                      setState(() {});
                      _search();
                    },
                  ),
                if (_controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      _controller.clear();
                      _search();
                    },
                  ),
              ],
            ),
            filled: true,
            fillColor: colors.surface,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                  color: colors.surfaceContainerHighest.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: colors.primary, width: 2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                  color: colors.surfaceContainerHighest.withOpacity(0.3)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _recentChips() {
    if (_recentQueries.isEmpty) return const SizedBox();

    return SizedBox(
      height: 40.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _recentQueries.map((q) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: ActionChip(
              label: Text(q),
              onPressed: () {
                _controller.text = q;
                _search();
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _resultsView() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSearching,
      builder: (_, searching, __) {
        if (searching) {
          return const Center(child: CircularProgressIndicator());
        }

        return ValueListenableBuilder<List<Quote>>(
          valueListenable: _results,
          builder: (_, data, __) {
            if (_controller.text.isEmpty && _selectedTags.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search_rounded,
                        size: 48, color: Colors.grey),
                    SizedBox(height: 12.h),
                    Text(
                      'Search quotes or explore by tags',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.grey, fontFamily: "Inter"),
                    ),
                  ],
                ),
              );
            }

            if (data.isEmpty) {
              return Center(
                child: Text(
                  'No matching quotes found.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey, fontFamily: "Inter"),
                ),
              );
            }

            return ListView.builder(
              itemCount: data.length,
              padding: EdgeInsets.all(16.w),
              itemBuilder: (_, i) {
                final quote = data[i];

                return AnimatedContainer(
                  duration: Duration(milliseconds: 200 + i * 30),
                  curve: Curves.easeOut,
                  child: MyFavoriteCard(
                    quote: quote,
                    onRemove: () => _toggleFavorite(quote),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
