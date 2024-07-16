import 'package:flutter/material.dart';
import 'package:sleer/screens/auth/profile/profile_page.dart';
import 'package:sleer/screens/home/news_feed_page.dart';

class PageViewScreen extends StatelessWidget {
  const PageViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: PageController(initialPage: 1),
        children: [
          const ProfilePage(),
          NewsFeedPage(),
          Container(
            color: Colors.blue,
            child: Center(
              child: Text(
                'Page 3',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
