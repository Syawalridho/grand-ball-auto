import 'package:flutter/material.dart';
import 'level_selection_page.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(129, 226, 243, 1), // Top color
                      Color.fromRGBO(40, 146, 165, 1), // Bottom color
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 130),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        label: 'PLAY',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LevelSelectionPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        label: 'SKIN',
                        onPressed: () {
                          print('Button SKIN pressed ...');
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        label: 'SETTINGS',
                        onPressed: () {
                          print('Button SETTINGS pressed ...');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const HeaderImage(),
              const FooterImage(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({required this.label, required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        textStyle: const TextStyle(
          fontSize: 43,
          fontWeight: FontWeight.w900,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class HeaderImage extends StatelessWidget {
  const HeaderImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 60, left: 60, right: 60), // Tambahkan padding 30px pada kiri dan kanan
        child: Image.asset(
          'lib/assets/images/GBA.png',
          width: MediaQuery.of(context).size.width - 200, // Kurangi 60px agar sesuai dengan padding kiri dan kanan
          fit: BoxFit.cover,
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
