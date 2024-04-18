import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ProfileBody(),
    );
  }
}

class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          const ProfileInfo(
              name: 'John Doe',
              email: 'john.doe@example.com',
              dob: 'January 1, 1990'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add signout functionality here
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
    Key? key,
    required this.name,
    required this.email,
    required this.dob,
  }) : super(key: key);

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
