import 'package:flutter/material.dart';
import 'package:my_app/core/utiles/shared_pref_helper.dart';
import 'package:my_app/core/utiles/shared_pref_key.dart';
import 'package:my_app/presentation/screens/login_screen/view/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const ProfileBody(),
    );
  }
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final email =
        SharedPreferenceHelper().readData(SharedPreferencesKeys.email);
    final dob = SharedPreferenceHelper().readData(SharedPreferencesKeys.dob);
    final name = SharedPreferenceHelper().readData(SharedPreferencesKeys.name);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/images/img_profile.png'),
          ),
          const SizedBox(height: 20),
          ProfileInfo(name: name, email: email, dob: dob),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await SharedPreferenceHelper().clearAll();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String name;
  final String email;
  final String dob;

  const ProfileInfo({
    super.key,
    required this.name,
    required this.email,
    required this.dob,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        TextField(
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: name),
        ),
        const SizedBox(height: 20),
        TextField(
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: email),
        ),
        const SizedBox(height: 20),
        TextField(
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Date of Birth',
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: dob),
        ),
      ],
    );
  }
}
