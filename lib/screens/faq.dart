import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'What is Dupeboard?',
      'answer':
          'Dupeboard is a simple app for tracking GTA car selling which is very useful for players who sell glitch cars regularly.',
    },
    {
      'question': 'How to use Dupeboard?',
      'answer':
          'When ever you sell any car on GTA Online just add that sale inside the App using "Add Dupe" button from Main Screen. The app will take care of the rest.',
    },
    {
      'question': 'Is internet connection mandatory to use Dupeboard?',
      'answer':
          'This app is fully functional in Offline mode. Your data is stored in your device. However, this app will collect usage information and crash report via Firebase whenever it gets internet connection.',
    },
    {
      'question': 'What to do before updating Dupeboard?',
      'answer':
          'Please create a backup of your database before installing any update. In case anything goes wrong, you can restore the database easily.',
    },
    {
      'question': 'How can I update Dupeboard?',
      'answer':
          'You can check for update by clicking "Check for Update" from settings page. If there is an update available you will get a prompt to download the update.',
    },
    {
      'question': 'Is "License Plate" mandatory to Add Dupe?',
      'answer':
          'If you don\'t need any "License Plate" to associate with your Dupe then just select the "Blank Option" from License Plate Dropdown Menu.',
    },
    {
      'question': 'How can I add my own license plates to Dropdown?',
      'answer':
          'Head over to Settings > Custom License Plate. Then add as many License Plates you want.',
    },
    {
      'question': 'Is Dupeboard free to use?',
      'answer':
          'Yes, This app is completely free to use. If you want then you can send me donation using Donate Button on Settings Page.',
    },
    {
      'question': 'Does Dupeboard show Advertisement?',
      'answer':
          'No, this app doesn\'t show any advertisement. Although you can support developer by sending donation.',
    },
    {
      'question': 'How can I contribuite to Dupeboard?',
      'answer':
          'I have made this app Open Source. If you want to contribute to the development of this app please head over to the github repository of this app.',
    },
    {
      'question': 'Does Dupeboard collect any data from my device?',
      'answer':
          'Yes, Dupeboard collects your usage information via Google Firebase to improve the app.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          'FAQ',
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        brightness: Theme.of(context).appBarTheme.brightness,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.color,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: ListView.builder(
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                return CustomExpansionTile(
                    faqs[index]['question'], faqs[index]['answer']);
              }),
        ),
      ),
    );
  }
}

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final String details;
  CustomExpansionTile(this.title, this.details);
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).appBarTheme.brightness == Brightness.dark
          ? ThemeData.dark()
              .copyWith(unselectedWidgetColor: Theme.of(context).accentColor)
          : ThemeData.light(),
      child: ExpansionTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline4,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
            child: Text(details),
          )
        ],
      ),
    );
  }
}
