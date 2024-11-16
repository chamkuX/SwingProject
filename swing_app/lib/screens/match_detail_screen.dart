import 'package:flutter/material.dart';
import 'swing_chain_screen.dart';

class MatchDetailScreen extends StatelessWidget {
  final String matchTitle;

  const MatchDetailScreen({Key? key, required this.matchTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(matchTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              matchTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Match details and statistics go here...",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SwingOptionPage(),
                  ),
                );
              },
              child: Text("View Swing Chain"),
            ),
          ],
        ),
      ),
    );
  }
}
