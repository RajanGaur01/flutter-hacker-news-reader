import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'features/hacker_news/data/datasources/hn_remote_datasource.dart';
import 'features/hacker_news/data/repositories/hn_repository_impl.dart';
import 'features/hacker_news/domain/usecases/get_comments.dart';
import 'features/hacker_news/domain/usecases/get_item_detail.dart';
import 'features/hacker_news/domain/usecases/get_top_stories.dart';
import 'features/hacker_news/presentation/pages/home_page.dart';
import 'features/hacker_news/presentation/providers/hn_provider.dart';

void main() {
  final httpClient = http.Client();

  final remoteDataSource = HnRemoteDataSource(client: httpClient);

  final repository = HnRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );

  final getTopStories = GetTopStories(repository);
  final getItemDetail = GetItemDetail(repository);
  final getComments = GetComments(repository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => HnProvider(
        getTopStories: getTopStories,
        getItemDetail: getItemDetail,
        getComments: getComments,
      ),
      child: const HackerNewsApp(),
    ),
  );
}

class HackerNewsApp extends StatelessWidget {
  const HackerNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}