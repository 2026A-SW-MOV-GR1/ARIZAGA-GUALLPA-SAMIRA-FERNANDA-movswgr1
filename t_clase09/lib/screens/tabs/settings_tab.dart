import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsTab extends StatelessWidget {
  final String? profileImagePath;
  final Function(ImageSource) onPickImage;

  const SettingsTab({
    super.key,
    this.profileImagePath,
    required this.onPickImage,
  });

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Colors.blue),
                title: const Text('Tomar Foto Ahora (Cámara)'),
                onTap: () {
                  Navigator.of(context).pop();
                  onPickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Escoger de la Galería'),
                onTap: () {
                  Navigator.of(context).pop();
                  onPickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 20),
        Center(
          child: GestureDetector(
            onTap: () => _showPickerOptions(context),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueAccent,
                  backgroundImage: profileImagePath != null
                      ? FileImage(File(profileImagePath!))
                      : null,
                  child: profileImagePath == null
                      ? const Text(
                          'S',
                          style: TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Samira',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const Center(
          child: Text('+593 99 581 1795', style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(height: 25),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Set Profile Photo'),
                onTap: () => _showPickerOptions(context),
              ),
              const Divider(color: Colors.white10, height: 1),
              const ListTile(
                leading: Icon(Icons.alternate_email, color: Colors.blue),
                title: Text('Set Username'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Column(
            children: [
              ListTile(
                leading: Icon(Icons.bookmark, color: Colors.blue),
                title: Text('Saved Messages'),
                trailing: Icon(Icons.arrow_forward_ios, size: 13),
              ),
              Divider(color: Colors.white10, height: 1),
              ListTile(
                leading: Icon(Icons.laptop, color: Colors.orange),
                title: Text('Devices (2)'),
                trailing: Icon(Icons.arrow_forward_ios, size: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
