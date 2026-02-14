import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/quote.dart';

class QuotesDatabase {
  QuotesDatabase._();

  static Isar? _isar;
  static bool _initialized = false;
  static final Random _random = Random.secure();

  static Isar get isar {
    if (!_initialized || _isar == null) {
      throw StateError('QuotesDatabase not initialized. Call init() first.');
    }
    return _isar!;
  }

  static Future<void> init() async {
    if (_initialized) return;

    try {
      final dir = await getApplicationSupportDirectory();

      _isar = await Isar.open(
        [QuoteSchema],
        directory: dir.path,
        inspector: kDebugMode,
        compactOnLaunch: const CompactCondition(
          minBytes: 100 * 1024,
          minRatio: 2.0,
        ),
      );

      _initialized = true;
      await _seedQuotesIfEmpty();

      debugPrint('✅ QuotesDatabase initialized');
    } catch (e, stack) {
      debugPrint('❌ QuotesDatabase init failed: $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  static Future<void> _seedQuotesIfEmpty() async {
    final count = await isar.quotes.count();
    if (count > 0) return;

    try {
      final jsonString = await rootBundle.loadString('assets/data/quotes.json');
      final List<dynamic> data = jsonDecode(jsonString);

      final quotes = <Quote>[];

      for (final q in data) {
        final text = (q['quote'] ?? '').toString().trim();
        if (text.isEmpty) continue;

        quotes.add(
          Quote()
            ..quote = text
            ..author = (q['author'] ?? 'Unknown').toString().trim()
            ..tags =
                (q['tags'] is List) ? List<String>.from(q['tags']) : <String>[]
            ..isFavorite = false,
        );
      }

      if (quotes.isNotEmpty) {
        await isar.writeTxn(() async {
          await isar.quotes.putAll(quotes);
        });
      }

      debugPrint('📦 Seeded ${quotes.length} quotes');
    } catch (e, stack) {
      debugPrint('❌ Quote seeding failed: $e');
      debugPrint('$stack');
    }
  }

  static Future<List<Quote>> getAllQuotes({int limit = 100, int offset = 0}) {
    return isar.quotes.where().offset(offset).limit(limit).findAll();
  }

  static Future<Quote?> getQuoteById(Id id) {
    return isar.quotes.get(id);
  }

  static Future<Quote?> getRandomQuote() async {
    final count = await isar.quotes.count();
    if (count == 0) return null;

    final index = _random.nextInt(count);
    return isar.quotes.where().offset(index).limit(1).findFirst();
  }

  static Future<List<Quote>> searchQuotesWithTags({
    required String query,
    required List<String> tags,
  }) async {
    final q = query.trim().toLowerCase();

    if (q.isEmpty && tags.isEmpty) {
      return getAllQuotes(limit: 200);
    }

    final allQuotes = await isar.quotes.where().findAll();

    return allQuotes.where((quote) {
      final matchesQuery = q.isEmpty ||
          quote.quote.toLowerCase().contains(q) ||
          quote.author.toLowerCase().contains(q);

      final matchesTags =
          tags.isEmpty || quote.tags.any((t) => tags.contains(t));

      return matchesQuery && matchesTags;
    }).toList();
  }

  static Future<List<Quote>> getAuthorQuotes(String authorName) {
    return isar.quotes.where().filter().authorEqualTo(authorName).findAll();
  }

  static Future<List<Quote>> getQuotesByTag(String tag) {
    return isar.quotes.where().filter().tagsElementEqualTo(tag).findAll();
  }

  static Future<List<String>> getAllTags() async {
    final tagsLists = await isar.quotes.where().tagsProperty().findAll();
    return tagsLists.expand((e) => e).toSet().toList()..sort();
  }

  static Future<Map<String, int>> getTagsWithCount() async {
    final tagsLists = await isar.quotes.where().tagsProperty().findAll();
    final Map<String, int> counts = {};

    for (final list in tagsLists) {
      for (final tag in list) {
        counts[tag] = (counts[tag] ?? 0) + 1;
      }
    }

    return counts;
  }

  static Future<int> getTagCount(String tagName) {
    return isar.quotes.where().filter().tagsElementEqualTo(tagName).count();
  }

  static Future<List<Quote>> getFavoriteQuotes() {
    return isar.quotes.where().filter().isFavoriteEqualTo(true).findAll();
  }

  static Future<void> toggleFavorite(Id quoteId) async {
    await isar.writeTxn(() async {
      final quote = await isar.quotes.get(quoteId);
      if (quote == null) return;

      quote.isFavorite = !quote.isFavorite;
      await isar.quotes.put(quote);
    });
  }

  static Future<void> setFavorite(Id quoteId, bool value) async {
    await isar.writeTxn(() async {
      final quote = await isar.quotes.get(quoteId);
      if (quote == null) return;

      quote.isFavorite = value;
      await isar.quotes.put(quote);
    });
  }

  static Future<void> clearFavorites() async {
    await isar.writeTxn(() async {
      final favorites = await getFavoriteQuotes();
      if (favorites.isEmpty) return;

      for (final q in favorites) {
        q.isFavorite = false;
      }
      await isar.quotes.putAll(favorites);
    });
  }

  static Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
      _initialized = false;
    }
  }
}
