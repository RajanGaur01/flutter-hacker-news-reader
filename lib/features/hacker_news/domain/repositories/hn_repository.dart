import '../entities/hn_item.dart';

abstract class HnRepository {
  Future<List<HnItem>> getTopStories({int limit = 20});

  Future<HnItem> getItemDetail(int id);

  Future<List<HnItem>> getComments(List<int> commentIds, {int limit = 20});
}