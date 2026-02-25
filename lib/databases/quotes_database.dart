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

  // ================= INIT =================

  static Future<void> init() async {
    if (_initialized) return;

    final dir = await getApplicationSupportDirectory();

    _isar = await Isar.open(
      [QuoteSchema],
      directory: dir.path,
      inspector: false,
      compactOnLaunch: const CompactCondition(
        minBytes: 100 * 1024,
        minRatio: 2.0,
      ),
    );

    _initialized = true;
    await _seedQuotesIfEmpty();
  }

  // ================= SEED =================

  static Future<void> _seedQuotesIfEmpty() async {
    if (await isar.quotes.count() > 0) return;

    try {
      final jsonString = await rootBundle.loadString('assets/data/quotes.json');
      final List data = jsonDecode(jsonString);

      final quotes = data
          .map((q) {
            final text = (q['quote'] ?? '').toString().trim();
            if (text.isEmpty) return null;

            return Quote()
              ..quote = text
              ..author = (q['author'] ?? 'Unknown').toString().trim()
              ..tags = (q['tags'] is List)
                  ? List<String>.from(q['tags'])
                  : <String>[]
              ..isFavorite = false;
          })
          .whereType<Quote>()
          .toList();

      if (quotes.isNotEmpty) {
        await isar.writeTxn(() => isar.quotes.putAll(quotes));
      }

      debugPrint('📦 Seeded ${quotes.length}');
    } catch (e) {
      debugPrint('❌ Seeding failed: $e');
    }
  }

  // ================= CRUD =================

  static Future<Id> addQuote(Quote quote) async {
    return isar.writeTxn(() => isar.quotes.put(quote));
  }

  static Future<void> deleteQuote(Id id) async {
    await isar.writeTxn(() => isar.quotes.delete(id));
  }

  static Future<void> updateQuote(Quote quote) async {
    await isar.writeTxn(() => isar.quotes.put(quote));
  }

  // ================= FETCH =================

  static Future<List<Quote>> getQuotesPage({
    int page = 0,
    int size = 20,
  }) {
    return isar.quotes.where().offset(page * size).limit(size).findAll();
  }

  static Future<Quote?> getQuoteById(Id id) {
    return isar.quotes.get(id);
  }

  static Future<Quote?> getRandomQuote() async {
    final count = await isar.quotes.count();
    if (count == 0) return null;

    final offset = _random.nextInt(count);
    return isar.quotes.where().offset(offset).limit(1).findFirst();
  }

  static Future<List<Quote>> getRandomBatch(int amount) async {
    final count = await isar.quotes.count();
    if (count == 0) return [];

    final offsets = <int>{};
    while (offsets.length < min(amount, count)) {
      offsets.add(_random.nextInt(count));
    }

    final results = <Quote>[];
    for (final o in offsets) {
      final q = await isar.quotes.where().offset(o).limit(1).findFirst();
      if (q != null) results.add(q);
    }
    return results;
  }

  // ================= SEARCH =================

  static Future<List<Quote>> searchQuotesWithTags({
    required String query,
    required List<String> tags,
  }) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty && tags.isEmpty) {
      return getQuotesPage(size: 200);
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

  static Future<List<Quote>> search(String text) {
    final q = text.trim();
    if (q.isEmpty) return getQuotesPage();

    return isar.quotes
        .filter()
        .group((g) => g
            .quoteContains(q, caseSensitive: false)
            .or()
            .authorContains(q, caseSensitive: false))
        .findAll();
  }

  static Future<List<Quote>> getQuotesByTag(String tag) {
    return isar.quotes.filter().tagsElementEqualTo(tag).findAll();
  }

  static Future<List<Quote>> getAuthorQuotes(String author) {
    return isar.quotes.filter().authorEqualTo(author).findAll();
  }

  // ================= FAVORITES =================

  static Future<List<Quote>> getFavoriteQuotes() {
    return isar.quotes.filter().isFavoriteEqualTo(true).findAll();
  }

  static Future<void> clearFavorites() async {
    await isar.writeTxn(() async {
      await isar.quotes.where().isFavoriteEqualTo(true).deleteAll();
    });
  }

  static Future<void> toggleFavorite(Id id) async {
    await isar.writeTxn(() async {
      final q = await isar.quotes.get(id);
      if (q == null) return;
      q.isFavorite = !q.isFavorite;
      await isar.quotes.put(q);
    });
  }

  // ================= TAG UTIL =================

  static Future<List<String>> getAllTags() async {
    final lists = await isar.quotes.where().tagsProperty().findAll();
    return lists.expand((e) => e).toSet().toList()..sort();
  }

  static Future<Map<String, int>> getTagStats() async {
    final lists = await isar.quotes.where().tagsProperty().findAll();
    final map = <String, int>{};

    for (final l in lists) {
      for (final t in l) {
        map[t] = (map[t] ?? 0) + 1;
      }
    }
    return map;
  }

  // ================= STATS =================

  static Future<Map<String, int>> databaseStats() async {
    final total = await isar.quotes.count();
    final fav = await isar.quotes.filter().isFavoriteEqualTo(true).count();
    final tags = (await getAllTags()).length;

    return {
      "total_quotes": total,
      "favorites": fav,
      "tags": tags,
    };
  }

  // ================= CLOSE =================

  static Future<void> close() async {
    if (_isar?.isOpen ?? false) {
      await _isar!.close();
      _isar = null;
      _initialized = false;
    }
  }
}
