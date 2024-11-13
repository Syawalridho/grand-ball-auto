import 'package:flutter/material.dart';
import '../assets/LevelButton.dart';
import 'level1.dart';

class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar to blend with gradient
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true, // Ensures gradient background is behind the AppBar
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(129, 226, 243, 1), // Top color
              Color.fromRGBO(40, 146, 165, 1), // Bottom color
            ],
          ),
        ),
        child: SafeArea(
          top: true,
          child: Stack(
            children: [
              // Footer image at the bottom
              const FooterImage(),
              // Centered content with level buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: LevelButton(
                        text: 'LEVEL 1',
                        color: Colors.white,
                        onPressed: () {
                          print('LEVEL 1 button pressed');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Level1Widget(), // Arahkan ke Level1Page
                            ),
                          );
                        },
                        width: screenWidth * 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: LevelButton(
                      text: '',
                      color: const Color(0xFF1F1F1F),
                      onPressed: () {
                        print('Locked level button pressed');
                      },
                      icon: Icons.lock,
                      width: screenWidth * 0.8,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: LevelButton(
                      text: '',
                      color: const Color(0xFF1F1F1F),
                      onPressed: () {
                        print('Locked level button pressed');
                      },
                      icon: Icons.lock,
                      width: screenWidth * 0.8,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: LevelButton(
                      text: '',
                      color: const Color(0xFF1F1F1F),
                      onPressed: () {
                        print('Locked level button pressed');
                      },
                      icon: Icons.lock,
                      width: screenWidth * 0.8,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: LevelButton(
                      text: '',
                      color: const Color(0xFF1F1F1F),
                      onPressed: () {
                        print('Locked level button pressed');
                      },
                      icon: Icons.lock,
                      width: screenWidth * 0.8,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: LevelButton(
                      text: '',
                      color: const Color(0xFF1F1F1F),
                      onPressed: () {
                        print('Locked level button pressed');
                      },
                      icon: Icons.lock,
                      width: screenWidth * 0.8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FooterImage extends StatelessWidget {
  const FooterImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        'lib/assets/images/Sand.png',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
