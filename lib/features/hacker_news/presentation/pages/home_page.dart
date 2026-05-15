import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/hn_provider.dart';
import '../widgets/story_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<HnProvider>().loadTopStories(limit: 30);
    });
  }

  Future<void> _refreshStories() async {
    await context.read<HnProvider>().loadTopStories(limit: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6EF),
      appBar: AppBar(
        title: const Text(
          'Hacker News',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFF6600),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Consumer<HnProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingStories) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }

          if (provider.stories.isEmpty) {
            return const Center(
              child: Text('No stories found.'),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshStories,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.stories.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Color(0xFFE0E0D0),
              ),
              itemBuilder: (context, index) {
                final story = provider.stories[index];

                return StoryTile(
                  index: index + 1,
                  story: story,
                );
              },
            ),
          );
        },
      ),
    );
  }
}