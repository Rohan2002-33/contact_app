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
            children: [
              ListTile(
                leading: const Icon(Icons.color_lens_outlined),
                title: const Text('Theme'),
                subtitle: Text(mode == ThemeMode.dark ? 'Dark' : 'Light'),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.brightness_6),
                title: const Text('Change Theme'),
                subtitle: const Text('Light / Dark'),
                value: mode == ThemeMode.dark,
                onChanged: (val) {
                  themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About App'),
                onTap: () {},
                trailing: const Icon(Icons.chevron_right),
              ),
              const ListTile(
                leading: Icon(Icons.numbers),
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