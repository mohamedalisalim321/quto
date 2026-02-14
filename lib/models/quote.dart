import 'package:isar/isar.dart';

part 'quote.g.dart';

@collection
class Quote {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value, caseSensitive: false)
  late String quote;

  @Index(type: IndexType.value, caseSensitive: false)
  late String author;

  @Index()
  late List<String> tags;

  @Index()
  bool isFavorite = false;
}
