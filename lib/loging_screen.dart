
import 'package:attendee_app/main.dart';
import 'package:attendee_app/network_request.dart';
import 'package:flutter/material.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LogingscreenState();
}

class _LogingscreenState extends State<Loginscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

         
              Container(
                height: 90,
                width: 140,
                alignment: Alignment.center,
                child: const Text(
                  "LOGO",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Please enter your credentials here",
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 30),

              /// EMAIL FIELD
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email ID",
                  filled: true,
                  fillColor: AppColors.navyMid,
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: AppColors.goldLight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ///  PASSWORD FIELD
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  fillColor: AppColors.navyMid,
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppColors.goldLight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot Password ?",
                    style: TextStyle(color: AppColors.goldLight),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ///  SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldLight,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      print("user email id check: ${emailController.text}");
                      print("user password check: ${passwordController.text}");
                      //call the api for fetching the login details
                      Network_request.login_api(
                          emailController.text, passwordController.text);
                      Navigator.pushReplacement(
                        //open new screen and remove login screen from stack
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AttendeeHomePage(), //navigate to home page on submit (replace login screen
                        ),
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      'Please fill the credentials',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    )));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Submit",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                    ],
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