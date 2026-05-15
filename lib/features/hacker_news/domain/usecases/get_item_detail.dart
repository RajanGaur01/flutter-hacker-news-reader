import '../entities/hn_item.dart';
import '../repositories/hn_repository.dart';

class GetItemDetail {
  final HnRepository repository;

  GetItemDetail(this.repository);

  Future<HnItem> call(int id) {
    return repository.getItemDetail(id);
  }
}