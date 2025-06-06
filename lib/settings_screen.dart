import 'package:flutter/material.dart';
import 'package:settings_app/preferences_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  String _language = 'es';
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool(PreferencesKey.darkMode) ?? false;
      _language = prefs.getString(PreferencesKey.language) ?? 'es';
      _fontSize = prefs.getDouble(PreferencesKey.fontSize) ?? 16.0;
    });
  }

  _saveSettings(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _darkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SwitchListTile(
                title: Text('Dark Mode'),
                value: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                    _saveSettings(PreferencesKey.darkMode, value);
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<String>(
                  value: _language,
                  items: [
                    DropdownMenuItem(value: 'es', child: Text('Spanish')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'fr', child: Text('French')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _language = value;
                        _saveSettings(PreferencesKey.language, value);
                      });
                    }
                  },
                  decoration: InputDecoration(labelText: 'Language'),
                ),
              ),
              Text("Font Size: ${_fontSize.toStringAsFixed(0)}"),
              Slider(
                value: _fontSize,
                min: 10.0,
                max: 30.0,
                divisions: 20,
                label: _fontSize.toStringAsFixed(0),
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                    _saveSettings(PreferencesKey.fontSize, value);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
