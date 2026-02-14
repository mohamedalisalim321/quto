import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/tag_selector.dart';
import '../databases/quotes_database.dart';
import '../models/quote.dart';
import 'author_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _debounceDuration = Duration(milliseconds: 300);

  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  List<Quote> _results = [];
  List<String> _selectedTags = [];

  bool _isSearching = false;

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
    'reality',
  ];

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, _search);
  }

  void _toggleTag(String tag) {
    HapticFeedback.selectionClick();

    setState(() {
      _selectedTags.contains(tag)
          ? _selectedTags.remove(tag)
          : _selectedTags.add(tag);
    });

    _search();
  }

  Future<void> _search() async {
    final query = _controller.text.trim();

    if (query.isEmpty && _selectedTags.isEmpty) {
      setState(() {
        _results.clear();
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    final results = await QuotesDatabase.searchQuotesWithTags(
      query: query,
      tags: _selectedTags,
    );

    if (!mounted) return;

    setState(() {
      _results = results;
      _isSearching = false;
    });
  }

  Future<void> _toggleFavorite(Quote quote) async {
    await QuotesDatabase.toggleFavorite(quote.id);

    if (!mounted) return;

    HapticFeedback.lightImpact();
    setState(() => quote.isFavorite = !quote.isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        TagSelector(
          tags: _availableTags,
          selectedTags: _selectedTags,
          onTagTap: _toggleTag,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _search,
            child: _buildResults(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(20.r),
        child: TextField(
          controller: _controller,
          onChanged: _onSearchChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search quotes or authors...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      _controller.clear();
                      _search();
                      FocusScope.of(context).unfocus();
                    },
                  )
                : null,
            filled: true,
            fillColor: colors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.text.isEmpty && _selectedTags.isEmpty) {
      return _buildIdleState();
    }

    if (_results.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      itemCount: _results.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (_, index) {
        final quote = _results[index];
        return SearchResultCard(
          quote: quote,
          onFavoriteToggle: () => _toggleFavorite(quote),
        );
      },
    );
  }

  Widget _buildIdleState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_rounded, size: 48, color: Colors.grey),
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

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No matching quotes found 😕',
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: Colors.grey, fontFamily: "Inter"),
      ),
    );
  }
}

class SearchResultCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onFavoriteToggle;

  const SearchResultCard({
    super.key,
    required this.quote,
    required this.onFavoriteToggle,
  });

  String get _cleanQuote => quote.quote.replaceAll('â€™', '\'');

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onLongPress: onFavoriteToggle,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '“$_cleanQuote”',
                style: TextStyle(
                  fontFamily: "Play",
                  fontSize: 15.sp,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AuthorPage(authorName: quote.author),
                          ),
                        );
                      },
                      child: Text(
                        quote.author,
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: IconButton(
                      key: ValueKey(quote.isFavorite),
                      onPressed: onFavoriteToggle,
                      icon: Icon(
                        quote.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: quote.isFavorite
                            ? Colors.redAccent
                            : colors.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
