import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          'Developer',
          style: TextStyle(color: Colors.black),
        ),
        brightness: Brightness.light,
        centerTitle: true,
        backgroundColor: Color(0xF4FFFFFF),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 110, left: 30, right: 30, bottom: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: Image.network(
                'https://avatars3.githubusercontent.com/u/22376955',
                height: MediaQuery.of(context).size.width * 0.25,
                width: MediaQuery.of(context).size.width * 0.25,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Arnob Karmokar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Electrical and Electronic Engineer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Image.asset(
                    'assets/images/github.png',
                    height: 28,
                    width: 28,
                  ),
                  onPressed: () => _launchURL('https://github.com/arnobk'),
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/images/facebook.png',
                    height: 28,
                    width: 28,
                  ),
                  onPressed: () =>
                      _launchURL('https://facebook.com/arnobology'),
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/images/twitter.png',
                    height: 28,
                    width: 28,
                  ),
                  onPressed: () =>
                      _launchURL('https://twitter.com/igeniusarnob'),
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/images/search.png',
                    height: 28,
                    width: 28,
                  ),
                  onPressed: () => _launchURL('https://arnob.me'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
