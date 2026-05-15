class HnItem {
  final int id;
  final String? title;
  final String? text;
  final String? by;
  final int? score;
  final int? time;
  final String? type;
  final String? url;
  final List<int> kids;




  HnItem({
    required this.id,
    this.title,
    this.text,
    this.by,
    this.score,
    this.time,
    this.type,
    this.url,
    this.kids = const [],
  });
}