import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  LoadingWidget(this.title, this.subtitle);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white54,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.width * 0.15,
                width: MediaQuery.of(context).size.width * 0.15,
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  backgroundColor: Colors.white,
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Theme.of(context).errorColor),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
