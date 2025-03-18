import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg1.png', // Ensure this path is correct
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // "Welcome to Stress Meter" text with violet color and white border effect
                      Text(
                        'Stress Meter',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50, // Increased font size
                          fontWeight: FontWeight.bold, // Bolder font
                          color: const Color.fromARGB(255, 254, 254, 255),
                          shadows: [
                            Shadow(
                              offset: Offset(
                                1.0,
                                1.0,
                              ), // Horizontal and Vertical offset
                              blurRadius: 2.0, // Blur effect for the border
                              color: const Color.fromARGB(
                                255,
                                210,
                                199,
                                199,
                              ), // White border color
                            ),
                            Shadow(
                              offset: Offset(
                                -1.0,
                                -1.0,
                              ), // Opposite shadow to create complete outline
                              blurRadius: 2.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Track your stress levels & find balance!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        '“Your mental health is important as your physical health.”',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ), // Adjusted padding for buttons
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center buttons
                  children: [
                    // Sign In Button
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white, // White border for visibility
                            width: 1, // Increased border width
                          ),
                          borderRadius: BorderRadius.circular(
                            7,
                          ), // Square shape with rounded corners
                        ),
                        child: MaterialButton(
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              ),
                          color: Colors.transparent,
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold, // Bold text
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Space between buttons
                    // Sign Up Button
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white, // White border for visibility
                            width: 1, // Increased border width
                          ),
                          borderRadius: BorderRadius.circular(
                            7,
                          ), // Square shape with rounded corners
                        ),
                        child: MaterialButton(
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              ),
                          color: Colors.transparent,
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold, // Bold text
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
