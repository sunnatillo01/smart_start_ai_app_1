import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, String>> messages = []; // Chat tarixini saqlash
  bool isLoading = false;

  Future<void> findAnswer(String userQuestion) async {
    setState(() {
      isLoading = true;
      messages.add({'type': 'user', 'text': userQuestion});
    });

    final snapshot = await _firestore.collection('discusions').get();

    String answer = "Savolga mos javob topilmadi";

    if (snapshot.docs.isEmpty) {
      answer = "Ma'lumot topilmadi";
    } else {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['question']
            .toString()
            .toLowerCase()
            .contains(userQuestion.toLowerCase())) {
          answer = data['answer'];
          break;
        }
      }
    }

    await Future.delayed(const Duration(milliseconds: 500)); // Loading effekt

    setState(() {
      isLoading = false;
      messages.add({'type': 'bot', 'text': answer});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
  backgroundColor: Colors.indigo, // AppBar rangi
  centerTitle: true, // bu markazga joylashtiradi
  automaticallyImplyLeading: false, // bu icon’ni olib tashlaydi
  title: Column(
    children: const [
      Text(
        "SS Smart Start AI Maslahatchisi",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 2),
      Text(
        "Savolingizni yozing va javob oling!",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
        ),
      ),
    ],
  ),
),
      body: Column(
        children: [
          // CHAT AREA
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  bool isUser = msg['type'] == 'user';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        msg['text']!,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // LOADING INDICATOR
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),

          // INPUT AREA
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Savol yozing...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty && !isLoading) {
                        findAnswer(_controller.text.trim());
                        _controller.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
