import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  const ChatPage({super.key, required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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

            // child: ListView.builder(
            //   padding: EdgeInsets.all(20.0),
            //   itemCount: 20,
            //   itemBuilder: (BuildContext context, int index) {
            //     const String msg = 'Hey hey hey! What u doing bro? You want to meet me at midnight? :D';
            //     return chatBubble(msg, true);
            //   },
            // ),

            child: ListView(
              reverse: true,
              padding: const EdgeInsets.all(20.0),
              children: [
                chatBubble('Hey hey hey! What u doing bro? You want to meet me at midnight? :D', true, false),
                chatBubble('Hey hey hey! What u doing bro? You want to meet me at midnight? :D', true, true),
                chatBubble('Hey hey hey! What u doing bro? You want to meet me at midnight? :D', true, true),
                chatBubble('Hey hey hey! What u doing bro? You want to meet me at midnight? :D', false, false),
                chatBubble('Hey hey hey! What u doing bro? You want to meet me at midnight? :D', false, true),
                chatBubble('Hey hey hey! What u doing bro? You want to meet me at midnight? :D', true, false),
                chatBubble('Hey hey hey! What u doing bro? You want to meet me at midnight? :D', true, true),
                chatBubble('Hey hey hey! What u doing bro? You want to meet me at midnight? :D', false, false),
                chatBubble('Hey hey hey! What u doing bro? You want to meet me at midnight? :D', true, false),
                chatBubble('Hey hey hey! What u doing bro? You want to meet me at midnight? :D', false, false),
                chatBubble('Hey hey hey! What u doing bro? You want to meet me at midnight? :D', false, true),
                chatBubble('Hey hey hey! What u doing bro? You want to meet me at midnight? :D', false, true),
                chatBubble('Hey hey hey! What u doing bro? You want to meet me at midnight? :D', true, false),
                chatBubble('Hey hey hey! What u doing bro? You want to meet me at midnight? :D', true, true),
              ],
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
        IconButton(
          icon: const Icon(Icons.photo),
          iconSize: 24,
          color: Colors.indigo,
          onPressed: () {},
        ),
        const Expanded(
          child: TextField(
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            decoration: InputDecoration.collapsed(
              hintText: 'Send a message...',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
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
