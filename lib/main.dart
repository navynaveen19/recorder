import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_4/second.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: settingsPage(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 232, 31, 162)),
        useMaterial3: true,
      ),
      home: const homepage(),
    );
  }
}

// ignore: camel_case_types
class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

// ignore: camel_case_types
class _homepageState extends State<homepage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final record = AudioRecorder();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 252, 252),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "images/avatar-1.png",
              fit: BoxFit.contain,
              height: 65,
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              "Hello",
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Welcome to GORECORD",
              style: GoogleFonts.inter(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset('images/home.gif'),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final bool status1 =
                      await FlutterOverlayWindow.isPermissionGranted();
                  print(status1);
                  if(!status1){
                    await FlutterOverlayWindow.requestPermission();
                  }
                  if (!await FlutterOverlayWindow.isActive()) {
                    // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    await FlutterOverlayWindow.showOverlay(
                        enableDrag: true, flag: OverlayFlag.focusPointer);
                  } else {
                    await FlutterOverlayWindow.closeOverlay();
                  }
                },
                child: const Text('Go'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
