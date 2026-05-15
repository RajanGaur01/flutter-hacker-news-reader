import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/hn_item.dart';
import '../providers/hn_provider.dart';
import '../widgets/comment_tile.dart';

class DetailPage extends StatefulWidget {
  final HnItem story;

  const DetailPage({
    super.key,
    required this.story,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final provider = context.read<HnProvider>();
      provider.clearComments();
      provider.loadComments(widget.story.kids, limit: 20);
    });
  }

  Future<void> _openArticle() async {
    final url = widget.story.url;

    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No article link available.'),
        ),
      );
      return;
    }

    final uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open article.'),
        ),
      );
    }
  }

  String _formatTime(int? unixTime) {
    if (unixTime == null) return 'unknown time';

    final dateTime = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  String _getDomain(String? url) {
    if (url == null || url.isEmpty) return '';

    try {
      final uri = Uri.parse(url);
      return uri.host.replaceFirst('www.', '');
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    final domain = _getDomain(story.url);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6EF),
      appBar: AppBar(
        title: const Text(
          'Story Details',
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
          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadComments(story.kids, limit: 20);
            },
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                Text(
                  story.title ?? 'No title',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                if (domain.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    domain,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                Text(
                  '${story.score ?? 0} points by ${story.by ?? 'unknown'} • '
                      '${_formatTime(story.time)} • ${story.kids.length} comments',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 14),

                if (story.url != null && story.url!.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _openArticle,
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open Article'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6600),
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                if (provider.isLoadingComments)
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (provider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Center(
                      child: Text(
                        provider.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                else if (provider.comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(
                        child: Text(
                          'No comments found.',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  else
                    ...provider.comments.map(
                          (comment) => CommentTile(comment: comment),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}