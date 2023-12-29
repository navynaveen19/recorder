import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

// ignore: camel_case_types

class settingsPage extends StatefulWidget {
  settingsPage({super.key});

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  final _key = GlobalKey<ExpandableFabState>();
  final record = AudioRecorder();

  @override
  void initState() {
    start();
    super.initState();
  }

  Future<void> start() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    if (await record.hasPermission()) {
      // Start recording to file
      await record.start(const RecordConfig(), path: '$path/myFile.m4a');
      print(path);
    }
  }

  // @override
  @override
  Widget build(BuildContext context) {
    final record = AudioRecorder();

    return Material(
        elevation: 0.0,
        color: Color.fromARGB(0, 0, 0, 0),
        child: Container(
          child: Scaffold(
            backgroundColor: Color.fromARGB(0, 0, 0, 0),
            floatingActionButtonLocation: ExpandableFab.location,
            floatingActionButton: ExpandableFab(
              distance: 70,
              fanAngle: 100,
              key: _key,
              children: [
                FloatingActionButton.small(
                  child: const Icon(Icons.play_arrow),
                  onPressed: () async {
                    final directory = await getApplicationDocumentsDirectory();
                    const path = '/storage/emulated/0/Download';
                    print(path);
                    await record.start(const RecordConfig(),
                        path: '$path/myFile.m4a');

                    final state = _key.currentState;
                    if (state != null) {
                      debugPrint('isOpen:${state.isOpen}');
                      state.toggle();
                    }
                  },
                ),
                FloatingActionButton.small(
                  child: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    await FlutterOverlayWindow.closeOverlay();
                    final state = _key.currentState;
                    if (state != null) {
                      debugPrint('isOpen:${state.isOpen}');
                      state.toggle();
                    }
                  },
                ),
                FloatingActionButton.small(
                  child: const Icon(Icons.stop_circle),
                  onPressed: () async {
                    final path = await record.stop();
                    final state = _key.currentState;
                    if (state != null) {
                      debugPrint('isOpen:${state.isOpen}');
                      state.toggle();
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
