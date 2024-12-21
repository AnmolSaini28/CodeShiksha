// import 'package:codequest/CodingPlat/CodeForces/codeforces.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:lottie/lottie.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:intl/intl.dart';
// import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
//
// Future<void> _handleRefresh() async {
//   return await Future.delayed(Duration(seconds: 2));
// }
//
// class cfnxt extends StatefulWidget {
//   const cfnxt({Key? key}) : super(key: key);
//
//   @override
//   State<cfnxt> createState() => _cfnxtState();
// }
//
// class _cfnxtState extends State<cfnxt> {
//   Future<void> upCommingContest() async {
//     String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     String url =
//         'https://clist.by/api/v4/contest/?limit=5&host=codeforces.com&start__gt=$formattedDate&order_by=start';
//     try {
//       final response = await http.get(Uri.parse(url), headers: {
//         "Authorization":
//             "ApiKey Dakshesh_Gupta:36f42779bf83119f213ea813c6885d79254b5964"
//       });
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           upcomming = data['objects'];
//         });
//       } else {
//         print('Failed to load contests');
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   List<dynamic> upcomming = [];
//
//   @override
//   void initState() {
//     super.initState();
//     upCommingContest();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LiquidPullToRefresh(
//       onRefresh: _handleRefresh,
//       color: Color(0xff171d28),
//       height: 100,
//       animSpeedFactor: 10,
//       showChildOpacityTransition: false,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Color(0xff171d28),
//           title: Row(
//             children: [
//               SizedBox(width: 40),
//               Image.asset(
//                 'assets/CodingPlatformsIcons/img_5.png',
//                 height: 30,
//                 width: 30,
//               ),
//               SizedBox(width: 10),
//               Text(
//                 'Codeforces',
//                 style: TextStyle(fontSize: 20, color: Colors.white),
//               ),
//               SizedBox(
//                 width: 41,
//               ),
//             ],
//           ),
//           iconTheme: IconThemeData(color: Colors.white),
//         ),
//         body: upcomming.isEmpty
//             ? Center(
//                 child: CircularProgressIndicator(
//                   color: Color(0xff171d28),
//                 ),
//               )
//             : ListView.builder(
//                 itemCount: upcomming.length,
//                 itemBuilder: (context, index) {
//                   final contest = upcomming[index];
//                   DateTime utcDate = DateTime.parse(contest['start']);
//                   DateTime istDate =
//                       utcDate.add(Duration(hours: 5, minutes: 30));
//                   String formattedStartDate =
//                       DateFormat('dd-MM-yyyy – hh:mm a').format(istDate);
//                   return Container(
//                       margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.2),
//                             spreadRadius: 1,
//                             blurRadius: 4,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: ListTile(
//                         leading: Image.asset(
//                           'assets/CodingPlatformsIcons/img_5.png',
//                           height: 30,
//                           width: 30,
//                         ),
//                         title: Text(
//                           contest['event'],
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                           ),
//                         ),
//                         subtitle: Text(formattedStartDate),
//                         trailing: SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: Lottie.asset(
//                               'assets/CodingPlatformsIcons/right.json'),
//                         ),
//                         onTap: () async {
//                           _launchContestUrl(contest['href']);
//                         },
//                       ));
//                 },
//               ),
//         bottomNavigationBar: Container(
//           color: Color(0xff171d28),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
//             child: GNav(
//               backgroundColor: Color(0xff171d28),
//               color: Colors.white,
//               rippleColor: Color(0xff202e3f),
//               hoverColor: Color(0xff202e3f),
//               haptic: true,
//               tabBorderRadius: 15,
//               tabActiveBorder: Border.all(color: Color(0xff202e3f), width: 1),
//               tabBorder: Border.all(color: Colors.grey, width: 1),
//               tabShadow: [
//                 BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)
//               ],
//               curve: Curves.easeOutExpo,
//               duration: Duration(milliseconds: 900),
//               activeColor: Colors.white,
//               tabBackgroundColor: Color(0xff202e3f),
//               gap: 8,
//               padding: EdgeInsets.all(5),
//               tabs: [
//                 GButton(
//                   icon: Icons.history,
//                   iconSize: 30,
//                   text: 'Past Contest',
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => Codeforces()));
//                   },
//                 ),
//                 GButton(
//                   icon: Icons.upcoming,
//                   iconSize: 30,
//                   text: 'Upcommimg ',
//                   onPressed: () {
//                     upCommingContest();
//                   },
//                 ),
//               ],
//               selectedIndex: 1,
//               onTabChange: (index) {
//                 // Handle tab changes
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _launchContestUrl(String url) async {
//     final Uri _url = Uri.parse(url);
//     if (!await launchUrl(_url)) {
//       throw Exception('Could not launch $_url');
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

import 'codeforces.dart';

// Notification Service for handling alarms
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  Future<void> scheduleNotification(String title, DateTime scheduledDate, int contestId, String url) async {
    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        contestId,
        'Contest Reminder',
        '$title starts in 30 minutes!',
        tz.TZDateTime.from(scheduledDate.subtract(Duration(minutes: 30)), tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'contests',
            'Contests',
            channelDescription: 'Notifications for upcoming contests',
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('notification_sound'),
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: url,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  Future<void> cancelNotification(int contestId) async {
    await _flutterLocalNotificationsPlugin.cancel(contestId);
  }
}

// Alarm Preferences for persistent storage
class AlarmPreferences {
  static const String _keyPrefix = 'contest_alarm_';

  static Future<void> setAlarm(int contestId, bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${_keyPrefix}$contestId', isEnabled);
  }

  static Future<bool> isAlarmSet(int contestId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('${_keyPrefix}$contestId') ?? false;
  }
}

class cfnxt extends StatefulWidget {
  const cfnxt({Key? key}) : super(key: key);

  @override
  State<cfnxt> createState() => _cfnxtState();
}

class _cfnxtState extends State<cfnxt> {
  final NotificationService _notificationService = NotificationService();
  List<dynamic> upcomming = [];
  Map<int, bool> _alarmStates = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _notificationService.init();
    upCommingContest();
  }

  Future<void> _handleRefresh() async {
    await upCommingContest();
    return await Future.delayed(Duration(seconds: 1));
  }

  Future<void> upCommingContest() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String url =
        'https://clist.by/api/v4/contest/?limit=5&host=codeforces.com&start__gt=$formattedDate&order_by=start';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": "ApiKey Dakshesh_Gupta:36f42779bf83119f213ea813c6885d79254b5964"
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          upcomming = data['objects'];
        });
        _loadAlarmStates();
      } else {
        print('Failed to load contests');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _loadAlarmStates() async {
    for (var contest in upcomming) {
      int contestId = contest['id'];
      bool isSet = await AlarmPreferences.isAlarmSet(contestId);
      setState(() {
        _alarmStates[contestId] = isSet;
      });
    }
  }

  Future<void> _toggleAlarm(dynamic contest) async {
    int contestId = contest['id'];
    bool currentState = _alarmStates[contestId] ?? false;
    bool newState = !currentState;

    if (newState) {
      DateTime contestDate = DateTime.parse(contest['start']);
      await _notificationService.scheduleNotification(
        contest['event'],
        contestDate,
        contestId,
        contest['href'],
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reminder set for ${contest['event']}'),
        backgroundColor: Color(0xff171d28),
        duration: Duration(seconds: 3),
      ));
    } else {
      await _notificationService.cancelNotification(contestId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reminder cancelled for ${contest['event']}'),
        backgroundColor: Color(0xff171d28),
        duration: Duration(seconds: 3),
      ));
    }

    await AlarmPreferences.setAlarm(contestId, newState);
    setState(() {
      _alarmStates[contestId] = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: Color(0xff171d28),
      height: 100,
      animSpeedFactor: 10,
      showChildOpacityTransition: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xff171d28),
          title: Row(
            children: [
              SizedBox(width: 40),
              Image.asset('assets/CodingPlatformsIcons/img_5.png', height: 30, width: 30),
              SizedBox(width: 10),
              Text('Codeforces', style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(width: 41),
            ],
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: upcomming.isEmpty
            ? Center(child: CircularProgressIndicator(color: Color(0xff171d28)))
            : ListView.builder(
          itemCount: upcomming.length,
          itemBuilder: (context, index) {
            final contest = upcomming[index];
            DateTime utcDate = DateTime.parse(contest['start']);
            DateTime istDate = utcDate.add(Duration(hours: 5, minutes: 30));
            String formattedStartDate = DateFormat('dd-MM-yyyy – hh:mm a').format(istDate);

            return Container(
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: ListTile(
                leading: Image.asset('assets/CodingPlatformsIcons/img_5.png', height: 30, width: 30),
                title: Text(contest['event'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                subtitle: Text(formattedStartDate),
                trailing: IconButton(
                  icon: Icon(
                    _alarmStates[contest['id']] == true ? Icons.notifications_active : Icons.notifications_none,
                    color: Color(0xff171d28),
                  ),
                  onPressed: () => _toggleAlarm(contest),
                ),
                onTap: () async {
                  _launchContestUrl(contest['href']);
                },
              ),
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
              haptic: true,
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
                  icon: Icons.history,
                  iconSize: 30,
                  text: 'Past Contest',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Codeforces()));
                  },
                ),
                GButton(
                  icon: Icons.upcoming,
                  iconSize: 30,
                  text: 'Upcoming',
                  onPressed: () {
                    upCommingContest();
                  },
                ),
              ],
              selectedIndex: 1,
              onTabChange: (index) {},
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchContestUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
