import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

const Icon kPlayClockButton = Icon(Icons.play_arrow_sharp);
const Icon kPauseClockButton = Icon(Icons.pause_sharp);

class MeditationScreen extends StatefulWidget {
  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final CountDownController _clockController = CountDownController();

  Icon _clockButton = kPlayClockButton; // Initial value
  bool _isClockStarted = false; // Conditional flag
  bool _isClockRunning = false; // Flag to track clock running state

  int selectedTime = 5; // Default time in minutes

  final List<int> meditationTimes = [5, 10, 15, 20, 25, 30];
  final List<String> meditationQuotes = [
    "Be present in the moment.",
    "Breathe deeply and let go of tension.",
    "Find peace within yourself.",
    "Focus on the present and let go of the past.",
    "Embrace silence and stillness.",
    "Cultivate gratitude for the present moment.",
    "Let your thoughts come and go like passing clouds.",
    "Connect with your inner wisdom.",
    "Release judgment and embrace acceptance.",
    "Allow yourself to simply be.",
    // Add more quotes as desired
  ];

  // Change Clock button icon and controller
  void switchClockActionButton() async {
    if (_clockButton == kPlayClockButton) {
      _clockButton = kPauseClockButton;

      final player = AudioPlayer();
      // await player.setFilePath("t.mp3");
      // player.play();
      if (!_isClockStarted) {
        // Processed on init
        _isClockStarted = true;
        _clockController.start();
        setState(() {
          _isClockRunning =
              true; // Update the flag to indicate clock is running
        });
      } else {
        // Processed on play
        _clockController.resume();
      }
    } else {
      // Processed on pause
      _clockButton = kPlayClockButton;
      _clockController.pause();
    }

    setState(() {
      // Update the UI with the new icon
      _clockButton = _clockButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height / 2;
    final double width = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'Meditate',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
                child: AnimatedTextKit(
                  animatedTexts: meditationQuotes.map((quote) {
                    return RotateAnimatedText(
                      quote,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      duration: const Duration(seconds: 2),
                      rotateOut: true,
                      alignment: Alignment.center,
                    );
                  }).toList(),
                  repeatForever: true,
                  pause: const Duration(seconds: 1),
                ),
              ),
              const SizedBox(height: 20.0),
              CircularCountDownTimer(
                key: Key(
                    selectedTime.toString()), // Add a key to the timer widget
                controller: _clockController,
                isReverseAnimation: true,
                ringColor: const Color(0xFF0B0C19),
                height: height,
                width: width,
                autoStart: false,
                duration: selectedTime * 60,
                isReverse: true,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                fillColor: Colors.pink,
                backgroundColor: Colors.purple.shade900,
                strokeCap: StrokeCap.round,
                onComplete: () {
                  setState(() {
                    _clockController.restart(); // Restart the timer
                  });
                },
              ),
              const SizedBox(height: 10.0),
              DropdownButton<int>(
                value: selectedTime,
                items: meditationTimes.map((time) {
                  return DropdownMenuItem<int>(
                    value: time,
                    child: Text(
                      '$time min',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white, // Update the color to white
                      ),
                    ),
                  );
                }).toList(),
                onChanged: _isClockRunning
                    ? null
                    : (value) {
                        setState(() {
                          selectedTime = value!;
                        });
                      },
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // Update the color to white
                ),
                elevation: 3,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white, // Update the icon color to white
                ),
                iconSize: 24,
                underline: Container(
                  height: 1,
                  color: Colors.white, // Update the underline color to white
                ),
                isExpanded: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      switchClockActionButton();
                    });
                  },
                  child: Container(
                    width: width / 2.5,
                    height: height / 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: _clockButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
