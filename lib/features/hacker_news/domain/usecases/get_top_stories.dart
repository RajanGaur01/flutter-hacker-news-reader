import '../entities/hn_item.dart';
import '../repositories/hn_repository.dart';

class GetTopStories {
  final HnRepository repository;

  GetTopStories(this.repository);

  Future<List<HnItem>> call({int limit = 20}) {
    return repository.getTopStories(limit: limit);
  }
}