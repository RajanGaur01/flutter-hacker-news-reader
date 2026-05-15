import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../models/hn_item_model.dart';

class HnRemoteDataSource {
  final http.Client client;

  HnRemoteDataSource({required this.client});

  Future<List<int>> getTopStoryIds() async {
    final response = await client.get(
      Uri.parse(ApiConstants.topStories),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((id) => id as int).toList();
    } else {
      throw Exception('Failed to load top story IDs');
    }
  }

  Future<HnItemModel> getItemDetail(int id) async {
    final response = await client.get(
      Uri.parse(ApiConstants.itemDetails(id)),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return HnItemModel.fromJson(data);
    } else {
      throw Exception('Failed to load item detail');
    }
  }
}