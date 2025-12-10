import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../controllers/character_controller.dart';
import '../../models/character_model.dart';

class CreateCharacterDialog extends StatelessWidget {
  const CreateCharacterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final personalityCtrl = TextEditingController();
    final toneCtrl = TextEditingController();
    final genderCtrl = TextEditingController();
    final relationCtrl = TextEditingController();
    final habitsCtrl = TextEditingController();

    return AlertDialog(
      title: const Text('Create New Character'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name *'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: personalityCtrl,
                decoration: const InputDecoration(labelText: 'Personality'),
              ),
              TextFormField(
                controller: toneCtrl,
                decoration: const InputDecoration(labelText: 'Tone'),
              ),
              TextFormField(
                controller: genderCtrl,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              TextFormField(
                controller: relationCtrl,
                decoration: const InputDecoration(labelText: 'Relation to you'),
              ),
              TextFormField(
                controller: habitsCtrl,
                decoration: const InputDecoration(labelText: 'Habits / Speech style'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final char = Character(
                id: const Uuid().v4(),
                name: nameCtrl.text.trim(),
                personality: personalityCtrl.text.trim(),
                tone: toneCtrl.text.trim(),
                gender: genderCtrl.text.trim(),
                relation: relationCtrl.text.trim(),
                habits: habitsCtrl.text.trim(),
                isLocal: true,
              );
              Get.find<CharacterController>().addLocalCharacter(char);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}