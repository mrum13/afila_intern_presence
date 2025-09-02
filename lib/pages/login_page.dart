import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController passController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 36
                ),
              ),
              const SizedBox(height: 24,),
              TextFormField(
                style: TextStyle(fontSize: 12),
                controller: nameController,
                decoration: InputDecoration(
                    label: Text("Username"),
                    
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey))),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: passController,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey)),
                    label: Text("Password")),
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {}, 
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56)
                ),
                child: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}
