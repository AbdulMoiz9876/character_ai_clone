import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/character_controller.dart';
import '../../models/character_model.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ← This line was causing the crash if arguments were missing
    final Character? character = Get.arguments as Character?;
    
    if (character == null) {
      return const Scaffold(
        body: Center(child: Text('Error: No character selected')),
      );
    }

    final CharacterController ctrl = Get.find();
    final TextEditingController textCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${character.name}'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: ctrl.chatMessages.length,
                  itemBuilder: (context, i) {
                    final msg = ctrl.chatMessages[i];
                    final isUser = msg.containsKey('user');
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.deepPurple.shade400 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isUser ? msg['user']! : msg['ai']!,
                          style: TextStyle(color: isUser ? Colors.white : Colors.black87),
                        ),
                      ),
                    );
                  },
                )),
          ),
          Obx(() => ctrl.isTyping.value
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 12),
                    Text('Luna is typing...'),
                  ]),
                )
              : const SizedBox(height: 8)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textCtrl,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onSubmitted: (_) => _sendMessage(textCtrl, ctrl, character),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () => _sendMessage(textCtrl, ctrl, character),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(TextEditingController ctrl, CharacterController characterCtrl, Character character) async {
    if (ctrl.text.trim().isEmpty) return;
    final msg = ctrl.text.trim();
    characterCtrl.chatMessages.add({'user': msg});
    ctrl.clear();
    await characterCtrl.getAIResponse(msg, character);
  }
}