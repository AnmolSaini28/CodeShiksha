import 'dart:convert';
import 'package:codequest/CodingPlat/LeetCode/leetcode.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

// Notification Service
class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _launchContestUrl(response.payload!);
        }
      },
    );

    tz.initializeTimeZones();
  }

  Future<void> scheduleNotification(String title, String description, DateTime scheduledDate, int contestId, String url) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        contestId,
        'LeetCode Contest Reminder',
        '$title starts in 30 minutes!',
        tz.TZDateTime.from(scheduledDate.subtract(Duration(minutes: 30)), tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'leetcode_contests',
            'LeetCode Contests',
            channelDescription: 'Notifications for upcoming LeetCode contests',
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
    await flutterLocalNotificationsPlugin.cancel(contestId);
  }
}

// Alarm Preferences Storage
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

// Main Contest Widget
class LeetCodeContests extends StatefulWidget {
  const LeetCodeContests({Key? key}) : super(key: key);

  @override
  State<LeetCodeContests> createState() => _LeetCodeContestsState();
}

class _LeetCodeContestsState extends State<LeetCodeContests> {
  final NotificationService _notificationService = NotificationService();
  List<dynamic> upcomingContests = [];
  Map<int, bool> _alarmStates = {};
  bool isLoading = true;

  Future<void> _handleRefresh() async {
    await fetchUpcomingContests();
    return await Future.delayed(Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    _notificationService.init();
    fetchUpcomingContests();
  }

  Future<void> fetchUpcomingContests() async {
    setState(() {
      isLoading = true;
    });

    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String url = 'https://clist.by/api/v4/contest/?limit=5&host=leetcode.com&start__gt=$formattedDate&order_by=start';

    try {
      final response = await http.get(
          Uri.parse(url),
          headers: {
            "Authorization": "ApiKey Dakshesh_Gupta:36f42779bf83119f213ea813c6885d79254b5964"
          }
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          upcomingContests = data['objects'];
          isLoading = false;
        });
        _loadAlarmStates();
      } else {
        throw Exception('Failed to load contests');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching contests: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load contests. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadAlarmStates() async {
    for (var contest in upcomingContests) {
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
      // Calculate alarm time (30 minutes before contest)
      DateTime alarmTime = contestDate.subtract(Duration(minutes: 30));

      // Convert to IST for display
      DateTime istContestTime = contestDate.add(Duration(hours: 5, minutes: 30));
      DateTime istAlarmTime = alarmTime.add(Duration(hours: 5, minutes: 30));

      // Print detailed information
      // print('Setting alarm for contest: ${contest['event']}');
      // print('Contest start time (IST): ${DateFormat('dd-MM-yyyy – hh:mm a').format(istContestTime)}');
      // print('Alarm will trigger at (IST): ${DateFormat('dd-MM-yyyy – hh:mm a').format(istAlarmTime)}');

      await _notificationService.scheduleNotification(
        contest['event'],
        contest['href'],
        contestDate,
        contestId,
        contest['href'],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reminder set for ${contest['event']}\nAlarm time: ${DateFormat('dd-MM-yyyy – hh:mm a').format(istAlarmTime)}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff171d28),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      print('Cancelling alarm for contest: ${contest['event']}');
      await _notificationService.cancelNotification(contestId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reminder cancelled for ${contest['event']}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff171d28),
          duration: Duration(seconds: 2),
        ),
      );
    }

    await AlarmPreferences.setAlarm(contestId, newState);
    setState(() {
      _alarmStates[contestId] = newState;
    });
  }

  Widget _buildContestTile(dynamic contest) {
    DateTime istDate = DateTime.parse(contest['start'])
        .add(Duration(hours: 5, minutes: 30));
    String formattedStartDate = DateFormat('dd-MM-yyyy – hh:mm a').format(istDate);
    int contestId = contest['id'];
    bool isAlarmSet = _alarmStates[contestId] ?? false;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Image.asset(
          'assets/CodingPlatformsIcons/img.png',
          height: 30,
          width: 30,
        ),
        title: Text(
          contest['event'],
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              formattedStartDate,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isAlarmSet ?  Icons.notifications_active : Icons.notifications_none,
                color: isAlarmSet ? Color(0xff171d28) : Colors.grey,
                size: 28,
              ),
              onPressed: () => _toggleAlarm(contest),
            ),
            SizedBox(
              height: 40,
              width: 40,
              child: Lottie.asset('assets/CodingPlatformsIcons/right.json'),
            ),
          ],
        ),
        onTap: () => _launchContestUrl(contest['href']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xff171d28),
        elevation: 0,
        title: Row(
          children: [
            SizedBox(width: 40),
            Image.asset(
              'assets/CodingPlatformsIcons/img.png',
              height: 30,
              width: 30,
            ),
            SizedBox(width: 10),
            Text(
              'LeetCode ',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: Color(0xff171d28),
        height: 300,
        animSpeedFactor: 2,
        showChildOpacityTransition: true,
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: Color(0xff171d28),
          ),
        )
            : upcomingContests.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_busy,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No upcoming contests',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: upcomingContests.length,
          padding: EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) => _buildContestTile(upcomingContests[index]),
        ),
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
                text: 'Past Contests',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Leetcode()));
                },
              ),
              GButton(
                icon: Icons.upcoming,
                text: 'Upcomming',
                onPressed: () => fetchUpcomingContests(),
              ),
            ],
            selectedIndex: 1,
            onTabChange: (index) {
              // Handle tab changes
            },
          ),
        ),
      ),
    );
  }
}
Future<void> _launchContestUrl(String urlString) async {
  try {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $urlString');
    }
  } catch (e) {
    // Show error message to user
    print('Error launching URL: $e');
  }
}

