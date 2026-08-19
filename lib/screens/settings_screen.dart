import 'package:flutter/material.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (context, mode, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              ListTile(
                leading: const Icon(Icons.color_lens_outlined,
                    color: kPrimaryColor),
                title: const Text('Theme'),
                subtitle: Text(mode == ThemeMode.dark ? 'Dark' : 'Light'),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.brightness_6, color: kPrimaryColor),
                title: const Text('Change Theme'),
                subtitle: const Text('Light / Dark'),
                value: mode == ThemeMode.dark,
                activeColor: kPrimaryColor,
                onChanged: (val) {
                  themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline, color: kPrimaryColor),
                title: const Text('About App'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const ListTile(
                leading: Icon(Icons.numbers, color: kPrimaryColor),
                title: Text('Version'),
                trailing: Text('1.0.0'),
              ),
            ],
          );
        },
      ),
    );
  }
}