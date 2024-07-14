import 'dart:convert';
import 'package:http/http.dart' as http;

const String url = 'https://leetcode.com/graphql';
const String query = '''
  query recentAcSubmissions(\$username: String!, \$limit: Int!) {
    recentAcSubmissionList(username: \$username, limit: \$limit) {
      id
      title
      titleSlug
      timestamp
    }
  }
''';

Future<List<Map<String, String>>?> fetchUserData(
    String username, int limit) async {
  final Map<String, dynamic> variables = {
    'username': username,
    'limit': limit,
  };

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'query': query,
      'variables': variables,
    }),
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    if (data.containsKey('data') &&
        data['data'].containsKey('recentAcSubmissionList')) {
      final List<dynamic> submissions = data['data']['recentAcSubmissionList'];
      return submissions.map((dynamic submission) {
        final String timestampValue = submission['timestamp'];
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            int.parse(timestampValue) * 1000,
            isUtc: false);
        final String formattedDateTime = dateTime.toString();
        final String title = submission['title'];
        final String titleSlug = submission['titleSlug'];
        return {
          'dateTime': formattedDateTime,
          'title': title,
          'titleSlug': titleSlug,
        };
      }).toList();
    } else {
      print('Error: Data format is incorrect.');
      return null;
    }
  } else {
    print('Error: ${response.statusCode}');
    print('Body: ${response.body}');
    return null;
  }
}

// Made just for testing
void main() async {
  const String username = "sauravkumar";
  const int limit = 15;

  final response = await fetchRecentAcSubmissions(username, limit);

  if (response != null) {
    print('Data fetched successfully.');
    const String timestamp = 'timestamp';
    final List<dynamic> submissions = response['recentAcSubmissionList'];
    for (dynamic submission in submissions) {
      final String timestampValue = submission[timestamp];
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(timestampValue) * 1000,
          isUtc: true);
      final String formattedDateTime = dateTime.toString();
      final String title = submission['title'];
      final String titleSlug = submission['titleSlug'];
      print('$formattedDateTime: $title ($titleSlug)');
    }
  } else {
    print('Failed to fetch data.');
  }
}

Future<Map<String, dynamic>?> fetchRecentAcSubmissions(
    String username, int limit) async {
  const String url = 'https://leetcode.com/graphql';
  const String query = '''
  query recentAcSubmissions(\$username: String!, \$limit: Int!) {
    recentAcSubmissionList(username: \$username, limit: \$limit) {
      id
      title
      titleSlug
      timestamp
    }
  }
  ''';

  final Map<String, dynamic> variables = {
    'username': username,
    'limit': limit,
  };

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'query': query,
      'variables': variables,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return data['data'];
  } else {
    print('Error: ${response.statusCode}');
    print('Body: ${response.body}');
    return null;
  }
}
