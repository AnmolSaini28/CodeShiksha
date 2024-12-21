import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';
import 'dart:convert';


class POTDChallengeScreen extends StatefulWidget {
  @override
  _POTDChallengeScreenState createState() => _POTDChallengeScreenState();
}

class _POTDChallengeScreenState extends State<POTDChallengeScreen> {
  // GeeksForGeeks POTD data
  String gfgProblemName = '';
  String gfgDifficulty = '';
  String gfgAccuracy = '';
  String gfgProblemUrl = '';

  // LeetCode POTD data
  String leetcodeProblemName = '';
  String leetcodeDifficulty = '';
  String leetcodeProblemUrl = '';
  String leetcodeAcceptanceRate = '';

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAllProblems();
  }

  Future<void> _fetchAllProblems() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await Future.wait([
        _fetchGeeksForGeeksPOTD(),
        _fetchLeetCodePOTD(),
      ]);
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load one or more problems. Please try again later.';
      });
      print('Debug - Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchGeeksForGeeksPOTD() async {
    try {
      final response = await http.get(
        Uri.parse('https://practiceapi.geeksforgeeks.org/api/v1/problems-of-day/problem/today/'),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          gfgProblemName = jsonData['problem_name'] ?? 'No Title Available';
          gfgDifficulty = jsonData['difficulty'] ?? 'Unknown';
          gfgProblemUrl = jsonData['problem_url'] ?? '';
          gfgAccuracy = '${(jsonData['accuracy'] ?? 0).toStringAsFixed(2)}%';
        });
      } else {
        throw Exception('Failed to load GFG POTD (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Debug - GFG Error: $e');
      throw e;
    }
  }

  Future<void> _fetchLeetCodePOTD() async {
    try {
      const String query = '''
        query questionOfToday {
          activeDailyCodingChallengeQuestion {
            date
            userStatus
            link
            question {
              acRate
              difficulty
              freqBar
              frontendQuestionId: questionFrontendId
              title
              titleSlug
              stats
              status
              topicTags {
                name
                id
                slug
              }
            }
          }
        }
      ''';

      final response = await http.post(
        Uri.parse('https://leetcode.com/graphql'),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
        body: json.encode({
          'query': query,
          'variables': {},
        }),
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final questionData = jsonData['data']['activeDailyCodingChallengeQuestion'];
        final question = questionData['question'];

        setState(() {
          leetcodeProblemName = question['title'] ?? 'No Title Available';
          leetcodeDifficulty = question['difficulty'] ?? 'Unknown';
          leetcodeProblemUrl = 'https://leetcode.com${questionData['link']}';
          final acRate = double.tryParse(question['acRate'].toString()) ?? 0.0;
          leetcodeAcceptanceRate = '${acRate.toStringAsFixed(2)}%';
        });
      } else {
        throw Exception('Failed to load LeetCode POTD (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Debug - LeetCode Error: $e');
      throw e;
    }
  }
  Widget _buildProblemCard({
    required String title,
    required String problemName,
    required String difficulty,
    required String accuracy,
    required String url,
    required Color cardColor,
  }) {
    return Card(
      color: cardColor,
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              problemName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    difficulty,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 8),
                if (accuracy.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Accuracy: $accuracy',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
            if (url.isNotEmpty) ...[
              SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final Uri _url = Uri.parse(url);
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: Text(
                  "Question Redirection : Click Here",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF161c28),
      appBar: AppBar(
        backgroundColor: Color(0xFF161c28),
        title: Text('Problem of the Day',
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchAllProblems,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(
        color:Colors.white,
      ))
          : RefreshIndicator(
        onRefresh: _fetchAllProblems,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (errorMessage.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.only(bottom: 16.0),
                  color: Colors.red[100],
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red[900]),
                  ),
                ),
              _buildProblemCard(
                title: 'GeeksforGeeks POTD',
                problemName: gfgProblemName,
                difficulty: gfgDifficulty,
                accuracy: gfgAccuracy,
                url: gfgProblemUrl,
                cardColor: Colors.green[700]!,
              ),
              _buildProblemCard(
                title: 'LeetCode POTD',
                problemName: leetcodeProblemName,
                difficulty: leetcodeDifficulty,
                accuracy: leetcodeAcceptanceRate,
                url: leetcodeProblemUrl,
                cardColor: Colors.orange[800]!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}