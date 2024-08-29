// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';

import 'widgets/login/signin.dart';
// import 'widgets/login/signin_control.dart';  //Test

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Exo2',
      ),
      home: const Signin(),
    ),
  );
}

class Signin extends StatelessWidget {
  const Signin({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    double height = MediaQuery.of(context).size.height;

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await FlutterDownloader.initialize(debug: true);
    // });
    //final DatabaseHelper dbHelper = DatabaseHelper();

    return Scaffold(
      body: Container(
        // width: double.infinity,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/images/android-drawer-bg.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        color: Color.fromARGB(255, 3, 89, 100),

        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     colors: [
        //       // Color.fromARGB(255, 154, 215, 223),
        //       // Color.fromARGB(255, 98, 193, 206),
        //       // Color.fromARGB(255, 1, 96, 109),
        //       Color.fromARGB(255, 180, 230, 236),
        //       Color.fromARGB(255, 52, 108, 116),
        //       Color.fromARGB(255, 3, 62, 70),
        //     ],
        //   ),
        //   // borderRadius: BorderRadius.only(
        //   //   //topLeft: Radius.circular(60),
        //   //   bottomRight: Radius.circular(60),
        //   // ),
        // ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: height * 0.05,
                ),
                const Header(),
                Flexible(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    // child: const SigninControl(),
                    child: const SigninControler(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/icons/appicon.png',
              height: height * 0.20,
              width: width * 0.30,
            ),
          ),
          SizedBox(height: height * 0.02),
          Center(
            child: Text(
              "BPDB GIS APP",
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
        ],
      ),
    );
  }
}

