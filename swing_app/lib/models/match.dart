class Match {
  final String title;
  final String venue;
  final String team1;
  final String team1Score;
  final String team2;
  final String team2Score;
  final String result;

  Match({
    required this.title,
    required this.venue,
    required this.team1,
    required this.team1Score,
    required this.team2,
    required this.team2Score,
    required this.result,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      title: json['title'],
      venue: json['venue'],
      team1: json['team1'],
      team1Score: json['team1Score'],
      team2: json['team2'],
      team2Score: json['team2Score'],
      result: json['result'],
    );
  }
}
