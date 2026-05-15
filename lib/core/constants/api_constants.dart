class ApiConstants {
  static const String baseUrl = 'https://hacker-news.firebaseio.com/v0';

  static const String topStories = '$baseUrl/topstories.json';

  static String itemDetails(int id) {
    return '$baseUrl/item/$id.json';
  }
}