import 'dart:convert';
import 'package:codequest/CodingPlat/GeeksForGeeks/geeksforgeeks.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

Future<void>_handleRefresh() async{
  return await Future.delayed(Duration(seconds: 2));
}

class gfgnxt extends StatefulWidget {
  const gfgnxt({Key? key}) : super(key: key);

  @override
  State<gfgnxt> createState() => _gfgnxtState();
}

class _gfgnxtState extends State<gfgnxt> {
  Future<void> upCommingContest() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String url = 'https://clist.by/api/v4/contest/?limit=15&host=geeksforgeeks.org&start__gt=$formattedDate&order_by=start';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": "ApiKey Dakshesh_Gupta:36f42779bf83119f213ea813c6885d79254b5964"
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          upcomming = data['objects'];
        });
      } else {
        print('Failed to load contests');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  List<dynamic> upcomming = [];

  @override
  void initState() {
    super.initState();
    upCommingContest();
  }

  @override
  Widget build(BuildContext context) {
    return  LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: Color(0xff171d28),
      height: 800,
      animSpeedFactor: 10,
      showChildOpacityTransition: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff171d28),
          title: Row(
            children: [
              SizedBox(width: 25),
              Image.asset(
                'assets/CodingPlatformsIcons/img_6.png',
                height: 30,
                width: 30,
              ),
              SizedBox(width: 7),
              Text(
                'GeeksForGeeks',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                width: 22,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.alarm,
                  size: 26,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: upcomming.isEmpty
            ? Center(
          child: CircularProgressIndicator(color:Color(0xff171d28),),
        ):ListView.builder(
          itemCount: upcomming.length,
          itemBuilder: (context, index) {
            final contest = upcomming[index];
            DateTime utcDate = DateTime.parse(contest['start']);
            DateTime istDate = utcDate.add(Duration(hours: 5, minutes: 30));
            String formattedStartDate = DateFormat('dd-MM-yyyy – hh:mm a').format(istDate);
            return ListTile(
              leading : Image.asset('assets/CodingPlatformsIcons/img_6.png',height: 30,width: 30,),
              title: Text(contest['event']),
              subtitle: Text(formattedStartDate),
              trailing:SizedBox(
                height: 20,
                width: 20,
                child: Lottie.asset('assets/CodingPlatformsIcons/right.json'),
              ),
              onTap: () async{
                _launchContestUrl(contest['href']);
              },
            );
          },
        ),
        bottomNavigationBar: Container(
          color: Color(0xff171d28),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: GNav(
              backgroundColor: Color(0xff171d28),
              color: Colors.white,
              rippleColor: Color(0xff202e3f),
              hoverColor: Color(0xff202e3f),
              haptic:true,
              tabBorderRadius: 15,
              tabActiveBorder: Border.all(color: Color(0xff202e3f), width: 1),
              tabBorder: Border.all(color: Colors.grey, width: 1),
              tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)],
              curve: Curves.easeOutExpo,
              duration: Duration(milliseconds: 900),
              activeColor: Colors.white,
              tabBackgroundColor: Color(0xff202e3f),
              gap: 8,
              padding: EdgeInsets.all(5),
              tabs: [
                GButton(
                  icon: Icons.skip_previous_outlined,
                  iconSize: 30,
                  text: 'Past Contest',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>GeeksForGeeks()));
                  },
                ),
                GButton(
                  icon: Icons.next_week_outlined,
                  iconSize: 30,
                  text: 'Upcoming',
                  onPressed: () {
                    upCommingContest();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _launchContestUrl(String url) async {
    final Uri _url=Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
