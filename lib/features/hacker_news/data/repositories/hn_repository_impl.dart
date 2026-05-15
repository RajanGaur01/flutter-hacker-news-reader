import '../../domain/entities/hn_item.dart';
import '../../domain/repositories/hn_repository.dart';
import '../datasources/hn_remote_datasource.dart';

class HnRepositoryImpl implements HnRepository {
  final HnRemoteDataSource remoteDataSource;

  HnRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<HnItem>> getTopStories({int limit = 20}) async {
    final storyIds = await remoteDataSource.getTopStoryIds();

    final limitedStoryIds = storyIds.take(limit).toList();

    final stories = await Future.wait(
      limitedStoryIds.map((id) => remoteDataSource.getItemDetail(id)),
    );

    return stories.where((story) => story.type == 'story').toList();
  }

  @override
  Future<HnItem> getItemDetail(int id) async {
    return await remoteDataSource.getItemDetail(id);
  }

  @override
  Future<List<HnItem>> getComments(
      List<int> commentIds, {
        int limit = 20,
      }) async {
    final limitedCommentIds = commentIds.take(limit).toList();

    final comments = await Future.wait(
      limitedCommentIds.map((id) => remoteDataSource.getItemDetail(id)),
    );

    return comments.where((comment) => comment.type == 'comment').toList();
  }
}