import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ListContainer extends StatelessWidget {
  const ListContainer({required this.imagepath,required this.text,super.key, required TextStyle textStyle});
  final String text;
  final String imagepath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
           // border: Border.all(color: Colors.black),
            color: Color(0xff202e3f),
        ),
        height: 80,
        width: double.maxFinite,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset(imagepath,scale: 2,),
            ),
            Text(text,style:GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 24)),)
          ],
        ),
      ),
    );
  }
}

