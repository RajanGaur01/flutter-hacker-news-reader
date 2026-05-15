import 'package:flutter/material.dart';

import '../../domain/entities/hn_item.dart';
import '../../domain/usecases/get_comments.dart';
import '../../domain/usecases/get_item_detail.dart';
import '../../domain/usecases/get_top_stories.dart';

class HnProvider extends ChangeNotifier {
  final GetTopStories getTopStories;
  final GetItemDetail getItemDetail;
  final GetComments getComments;

  HnProvider({
    required this.getTopStories,
    required this.getItemDetail,
    required this.getComments,
  });

  List<HnItem> _stories = [];
  List<HnItem> _comments = [];

  bool _isLoadingStories = false;
  bool _isLoadingComments = false;

  String? _errorMessage;

  List<HnItem> get stories => _stories;
  List<HnItem> get comments => _comments;

  bool get isLoadingStories => _isLoadingStories;
  bool get isLoadingComments => _isLoadingComments;

  String? get errorMessage => _errorMessage;

  Future<void> loadTopStories({int limit = 20}) async {
    _isLoadingStories = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stories = await getTopStories(limit: limit);
    } catch (e) {
      _errorMessage = 'Failed to load top stories. Please try again.';
    } finally {
      _isLoadingStories = false;
      notifyListeners();
    }
  }

  Future<void> loadComments(List<int> commentIds, {int limit = 20}) async {
    _isLoadingComments = true;
    _errorMessage = null;
    _comments = [];
    notifyListeners();

    try {
      if (commentIds.isEmpty) {
        _comments = [];
      } else {
        _comments = await getComments(commentIds, limit: limit);
      }
    } catch (e) {
      _errorMessage = 'Failed to load comments. Please try again.';
    } finally {
      _isLoadingComments = false;
      notifyListeners();
    }
  }

  Future<HnItem?> loadItemDetail(int id) async {
    try {
      return await getItemDetail(id);
    } catch (e) {
      _errorMessage = 'Failed to load item detail. Please try again.';
      notifyListeners();
      return null;
    }
  }

  void clearComments() {
    _comments = [];
    notifyListeners();
  }
}