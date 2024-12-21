import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BeginnerProblem extends StatefulWidget {
  const BeginnerProblem({Key? key});

  @override
  State<BeginnerProblem> createState() => _BeginnerProblemState();
}

class _BeginnerProblemState extends State<BeginnerProblem> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xff171d28),
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text("Fundamental Topics"),
        ),
        body: TapList(),
      ),
    );
  }
}

class TapList extends StatefulWidget {
  const TapList({Key? key});

  @override
  State<TapList> createState() => _TapListState();
}

class _TapListState extends State<TapList> {
  List<String> topics = ["Array", "String", "Sorting", "Searching", "Linked List", "Two Pointer", "Stack"];
  List<String> webSites = [
    'https://leetcode.com/tag/array/',
    'https://leetcode.com/tag/string/',
    'https://leetcode.com/tag/sorting/',
    'https://leetcode.com/tag/searching/',
    'https://leetcode.com/tag/linked-list/',
    'https://leetcode.com/tag/two-pointer/',
    'https://leetcode.com/tag/stack/'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _launchWebsite(_generateWebsiteUrl(index));
          },
          child: Container(
            height: 80,
            width: 150,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xff3B4A5D),
            ),
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                topics[index],
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        );
      },
    );
  }

  void _launchWebsite(String url) async {
    Uri uri=Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _generateWebsiteUrl(int index) {
    if (index >= 0 && index < webSites.length) {
      return webSites[index];
    } else {
      throw 'Invalid index: $index';
    }
  }
}
