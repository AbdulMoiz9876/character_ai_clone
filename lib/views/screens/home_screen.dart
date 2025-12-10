import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/character_controller.dart';
import '../../models/character_model.dart';
import '../components/create_character_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CharacterController ctrl = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Character'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Obx(() {
        // Loading state
        if (ctrl.isLoadingCharacters.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Empty state
        if (ctrl.allCharacters.isEmpty) {
          return const Center(
            child: Text(
              'No characters yet.\nCreate one or add in Firebase!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        // List of characters
        return RefreshIndicator(
          onRefresh: ctrl.loadCharactersFromFirebase,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: ctrl.allCharacters.length,
            itemBuilder: (context, index) {
              final char = ctrl.allCharacters[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.deepPurple.shade100,
                    child: Text(
                      char.name.isNotEmpty ? char.name[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(char.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${char.relation.isEmpty ? 'Friend' : char.relation} • ${char.personality}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: char.isLocal
                      ? const Icon(Icons.person, color: Colors.green)
                      : const Icon(Icons.cloud_done, color: Colors.blue),
                  onTap: () {
                    ctrl.startNewChat();
                    Get.toNamed('/chat', arguments: char)!;
                  },
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const CreateCharacterDialog(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Character'),
      ),
    );
  }
}