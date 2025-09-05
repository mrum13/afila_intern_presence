import 'package:afila_intern_presence/widgets/elevated_button_custom.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButtonCustom(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/');
                }, 
                text: "Logout"
              ),
              const SizedBox(height: 24,),
              ElevatedButtonCustom(
                onTap: () {
                  Navigator.pushNamed(context, '/create-user');
                }, 
                text: "Create User"),
            ],
          ),
        ),
      ),
    );
  }
}