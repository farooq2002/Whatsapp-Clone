import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatasppflutterapp/Features/Chat/Controllers/chat_controller.dart';
import 'package:whatasppflutterapp/colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String reciverUserId;
  const BottomChatField({
    super.key,
    required this.reciverUserId,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowButton = false;
  final TextEditingController _messageController = TextEditingController();

  void sendTextMsg() async {
    if (isShowButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.reciverUserId,
          );

      setState(() {
        _messageController.text = "";
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  isShowButton = true;
                });
              } else {
                setState(() {
                  isShowButton = false;
                });
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 60,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.gif,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        GestureDetector(
          onTap: sendTextMsg,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 2, right: 2),
            child: CircleAvatar(
              backgroundColor: const Color(0xff128C7E),
              radius: 25,
              child:
                  isShowButton ? const Icon(Icons.send) : const Icon(Icons.mic),
            ),
          ),
        )
      ],
    );
  }
}
