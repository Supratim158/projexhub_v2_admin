import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),

      body: ListView(
        children: const [

          ListTile(
            leading: Icon(Icons.admin_panel_settings),
            title: Text("Admin Profile"),
          ),

          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Change Password"),
          ),

          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
          ),

          ListTile(
            leading: Icon(Icons.info),
            title: Text("About ProjexHub"),
          ),

        ],
      ),
    );
  }
}