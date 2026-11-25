import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../settings/settings_model.dart';

// Level 5: a photo, and every answer the OS can give.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _picker = ImagePicker();

  void _say(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // Gallery: no runtime permission needed (Android photo picker).
  Future<void> _choosePhoto() => _pick(ImageSource.gallery);

  // Camera: ask AT THE TAP (never in initState), then handle every status.
  Future<void> _takePhoto() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    switch (status) {
      case PermissionStatus.granted || PermissionStatus.limited:
        await _pick(ImageSource.camera);
      case PermissionStatus.denied:
        _say(
          'Without the camera you can still choose a photo from the gallery.',
        );
      case PermissionStatus.permanentlyDenied:
        await _askToOpenSettings(); // the OS will never ask again
      case PermissionStatus.restricted || PermissionStatus.provisional:
        _say('The camera is not available on this device.');
    }
  }

  Future<void> _askToOpenSettings() async {
    final open = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera is off'),
        content: const Text(
          'You turned the camera off for this app. To take a photo, '
          'allow the camera in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Open settings'),
          ),
        ],
      ),
    );
    if (open ?? false) await openAppSettings();
  }

  Future<void> _pick(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );
    // The three lines from week 6: null check, mounted, then the change.
    if (picked == null) return; // the user pressed Cancel
    if (!mounted) return;
    // Copy into Documents so the photo survives a restart.
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}${Platform.pathSeparator}avatar.jpg';
    await File(picked.path).copy(path);
    await FileImage(File(path)).evict(); // same name -> drop the old image
    if (!mounted) return;
    await context.read<SettingsModel>().setAvatarPath(path);
  }

  @override
  Widget build(BuildContext context) {
    final path = context.watch<SettingsModel>().avatarPath;
    final hasPhoto = path != null && File(path).existsSync();
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 64,
              backgroundImage: hasPhoto ? FileImage(File(path)) : null,
              child: hasPhoto ? null : const Text('S'), // the initial
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _choosePhoto,
              icon: const Icon(Icons.photo_library),
              label: const Text('Choose photo'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.photo_camera),
              label: const Text('Take photo'),
            ),
          ],
        ),
      ),
    );
  }
}
