import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/widgets/theme_notifier.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void pickColor(Color currentColor, ValueChanged<Color> onColorSelected) {
    // Print statement to debug if the method is called
    print("pickColor called with color: $currentColor");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (Color color) {
                // Print statement to debug the color change
                print("Color changed to: $color");
                onColorSelected(color);
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it'),
              onPressed: () {
                print("Color picker closed with color: $currentColor");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: themeNotifier.getTheme().brightness == Brightness.dark,
            onChanged: (bool value) {
              themeNotifier.setTheme(
                value ? ThemeData.dark() : ThemeData.light(),
              );
            },
          ),
          ListTile(
            title: const Text('Primary Color'),
            trailing: GestureDetector(
              onTap: () {
                pickColor(themeNotifier.getTheme().primaryColor, (newColor) {
                  themeNotifier.setTheme(
                    ThemeData(
                      primaryColor: newColor,
                      brightness: themeNotifier.getTheme().brightness,
                    ),
                  );
                });
              },
              child: CircleAvatar(
                backgroundColor: themeNotifier.getTheme().primaryColor,
              ),
            ),
          ),
          ListTile(
            title: const Text('Accent Color'),
            trailing: GestureDetector(
              onTap: () {
                pickColor(themeNotifier.getTheme().colorScheme.secondary,
                    (newColor) {
                  themeNotifier.setTheme(
                    ThemeData(
                      primaryColor: themeNotifier.getTheme().primaryColor,
                      colorScheme: ColorScheme.fromSwatch().copyWith(
                        secondary: newColor,
                        brightness: themeNotifier.getTheme().brightness,
                      ),
                    ),
                  );
                });
              },
              child: CircleAvatar(
                backgroundColor: themeNotifier.getTheme().colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
