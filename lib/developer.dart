import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          'Developer',
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        brightness: Theme.of(context).appBarTheme.brightness,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.color,
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
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Electrical and Electronic Engineer',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
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
                    color:
                        Theme.of(context).appBarTheme.textTheme.headline6.color,
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
                    color:
                        Theme.of(context).appBarTheme.textTheme.headline6.color,
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
