import 'dart:io';

import 'package:animations/animations.dart';
import 'package:encs_chat/pages/image_preview/image_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import '../../global/enum_gen.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  const ChatPage({super.key, required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, String>> allMessages = [
    {'Siemanko co tam?': '20:43'},
    {'A wszystko w porządku a u Ciebie jak tam?': '20:44'},
    {'Dobrze jest, znalazłem ostatnio super ofertę!': '20:45'},
    {'Co Ty gadasz, opowiesz mi coś więcej o tym?': '20:46'},
    {'Jasne! Poszukiwali Junior Flutter Deva do teamu, zgłosiłem się i mamy to, mały sukces!': '20:47'},
    {'No nie gadaj mi nawet, gratulacje serdeczne mordeczko!': '20:48'},
    {'Dzięki wielkie, sam się nie spodziewałem że aż tak zajebiście to pójdzie! :D': '20:49'},
  ];

  List<bool> messageIsFromMe = [true, false, true, false, true, false, true];
  List<bool> messageFromSameUser = [false, false, false, false, false, false, false];

  List<ChatMessageTypes> messageCategory = [
    ChatMessageTypes.text,
    ChatMessageTypes.text,
    ChatMessageTypes.text,
    ChatMessageTypes.text,
    ChatMessageTypes.text,
    ChatMessageTypes.text,
    ChatMessageTypes.text,
  ];

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus?.unfocus(), // Dismiss the keyboard when touched outside
    child: Scaffold(
      // resizeToAvoidBottomInset: false, // Avoid error => Bottom overflowed by x pixels when showing keyboard
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        // backgroundColor: const Color(0xFF171717),
        backgroundColor: Colors.transparent,
        elevation: 20.0,
        toolbarHeight: 50,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.userName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const TextSpan(
                text: '\n',
              ),
              const TextSpan(
                text: 'Online',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.videocam_rounded,
              size: 20,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.call,
              size: 20,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: false,
              padding: const EdgeInsets.all(20.0),
              itemCount: allMessages.length,
              itemBuilder: (BuildContext context, int index) {
                if (messageCategory[index] == ChatMessageTypes.text) {
                  return chatBubble(allMessages[index].keys.first, messageIsFromMe[index], messageFromSameUser[index]);
                }
                else if (messageCategory[index] == ChatMessageTypes.image) {
                  return chatImage(context, index);
                }

                return const Center();
              },
            ),
          ),
          sendMessageArea(),
        ],
      ),
    ),
  );

  chatBubble(String message, bool isMe, bool isSameUser) => isMe ?
  Column(
    children: <Widget>[
      Container(
        alignment: Alignment.topRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.80,
          ),
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ),
      !isSameUser ?
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Text(
            '12:30 PM',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage('lib/images/google.png'),
            ),
          ),
        ],
      ) :
      Container(
        child: null,
      ),
    ],
  ) :
  Column(
    children: <Widget>[
      Container(
        alignment: Alignment.topLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.80,
          ),
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.grey[850]!),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ),
      !isSameUser ?
      Row(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage('lib/images/google.png'),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            '12:30 PM',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ) :
      Container(
        child: null,
      ),
    ],
  );

  Widget chatImage(BuildContext item, int index) => Column(
    children: <Widget>[
      Container(
        alignment: Alignment.topRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: OpenContainer(
            openColor: const Color(0xFF171717),
            middleColor: const Color(0xFF171717),
            closedColor: const Color(0xFF171717),
            transitionDuration: const Duration(milliseconds: 500),
            transitionType: ContainerTransitionType.fadeThrough,
            openBuilder: (context, openWidget) => ImagePreviewPage(
              imagePath: messageCategory[index] == ChatMessageTypes.image ?
              allMessages[index].keys.first :
              allMessages[index].keys.first.split('+')[0],
              imageProviderCategory: ImageProviderCategory.fileImage,
            ),
            closedBuilder: (context, closedWidget) => PhotoView(
              imageProvider: FileImage(
                File(messageCategory[index] == ChatMessageTypes.image ?
                allMessages[index].keys.first :
                allMessages[index].keys.first.split('+')[0],
                ),
              ),
              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorBuilder: (context, obj, stackTrace) => const Center(
                child: Text(
                  'Image not found!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              minScale: PhotoViewComputedScale.covered,
            ),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Text(
            '12:30 PM',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage('lib/images/google.png'),
            ),
          ),
        ],
      ),
    ],
  );

  sendMessageArea() => Container(
    decoration: const BoxDecoration(
      color: Colors.black45,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(10.0),
        topLeft: Radius.circular(10.0),
      ),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    height: 70,
    child: Row(
      children: <Widget>[
        // Send image from camera
        IconButton(
          icon: const Icon(Icons.photo_camera),
          iconSize: 24,
          color: Colors.indigo,
          onPressed: () async {
            final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
            if (pickedImage != null) {
              final String messageTime = '${DateTime.now().hour}:${DateTime.now().minute}';
              if (mounted) {
                setState(() {
                  allMessages.add({
                    File(pickedImage.path).path : messageTime,
                  });
                  messageCategory.add(ChatMessageTypes.image);
                });
              }
            }
          },
        ),

        // Send image from gallery
        IconButton(
          icon: const Icon(Icons.photo),
          iconSize: 24,
          color: Colors.indigo,
          onPressed: () async {
            final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
            if (pickedImage != null) {
              final String messageTime = '${DateTime.now().hour}:${DateTime.now().minute}';
              if (mounted) {
                setState(() {
                  allMessages.add({
                    File(pickedImage.path).path : messageTime,
                  });
                  messageCategory.add(ChatMessageTypes.image);
                });
              }
            }
          },
        ),

        // Write message textfield
        const Expanded(
          child: TextField(
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            decoration: InputDecoration.collapsed(
              hintText: 'Napisz wiadomość...',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
        ),

        // Send message button
        IconButton(
          icon: const Icon(Icons.send_rounded),
          iconSize: 24,
          color: Colors.indigo,
          onPressed: () {},
        ),
      ],
    ),
  );
}
