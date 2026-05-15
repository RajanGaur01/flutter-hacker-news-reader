import '../entities/hn_item.dart';
import '../repositories/hn_repository.dart';

class GetComments {
  final HnRepository repository;

  GetComments(this.repository);

  Future<List<HnItem>> call(
      List<int> commentIds, {
        int limit = 20,
      }) {
    return repository.getComments(commentIds, limit: limit);
  }
}