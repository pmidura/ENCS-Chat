import 'package:animations/animations.dart';
import 'package:encs_chat/pages/chatting/chat_page.dart';
import 'package:encs_chat/pages/menu/account_page.dart';
import 'package:encs_chat/pages/menu/help/help_page.dart';
import 'package:encs_chat/pages/search_page.dart';
import 'package:encs_chat/provider/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/home_page/drawer_item.dart';
import '../components/home_page/user_avatar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  final user = FirebaseAuth.instance.currentUser!;

  // Sign out method when user is logged in with e-mail address and password
  void signOutUserWithEmailAndPassword() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _globalKey,
    backgroundColor: const Color(0xFF171717),
    body: Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70.0, left: 5.0, right: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => _globalKey.currentState!.openDrawer(),
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 140,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0),
            height: 220,
            decoration: const BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Favourite contacts',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildContactAvatar('Maciek', 'google.png'),
                      buildContactAvatar('Piotrek', 'google.png'),
                      buildContactAvatar('Janek', 'google.png'),
                      buildContactAvatar('Michał', 'google.png'),
                      buildContactAvatar('Aleksandra', 'google.png'),
                      buildContactAvatar('Natalia', 'google.png'),
                      buildContactAvatar('Andżelika', 'google.png'),
                      buildContactAvatar('Wiesiek', 'google.png'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 315,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            decoration: const BoxDecoration(
              color: Color(0xF71F1E1E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              children: [
                buildConversationRow('Maciek', 'Witam Pana serdecznie', 'google.png'),
                buildConversationRow('Piotrek', 'Co tam ciekawego?', 'google.png'),
                buildConversationRow('Janek', 'Odwiedzisz mnie?', 'google.png'),
                buildConversationRow('Michał', 'Ale upał dzisiaj', 'google.png'),
                buildConversationRow('Aleksandra', 'Bagno miał kude', 'google.png'),
                buildConversationRow('Natalia', 'Whata kurwa siet', 'google.png'),
                buildConversationRow('Andżelika', 'Fast project management', 'google.png'),
                buildConversationRow('Wiesiek', 'Where are you?', 'google.png'),
              ],
            ),
          ),
        ),
      ],
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    floatingActionButton: externalConnManagement(),
    drawer: Drawer(
      width: 275,
      backgroundColor: Colors.black38,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(40.0),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xF71F1E1E),
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(40.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x3D000000),
              spreadRadius: 30,
              blurRadius: 20,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      // Icon back
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 56),

                      // Settings text
                      const Text(
                        'Ustawienia',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // User photo and name
                  Row(
                    children: [
                      UserAvatar(photoURL: user.photoURL ?? 'https://freesvg.org/img/abstract-user-flat-3.png'),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          user.displayName ?? user.email!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // Account
                  DrawerItem(
                    title: 'Konto',
                    icon: Icons.key,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AccountPage(),
                      ),
                    ),
                  ),

                  // Chat history
                  DrawerItem(
                    title: 'Historia czatów',
                    icon: Icons.chat_bubble,
                    onTap: () {},
                  ),

                  // Notifications
                  DrawerItem(
                    title: 'Powiadomienia',
                    icon: Icons.notifications,
                    onTap: () {},
                  ),

                  // Data and storage
                  DrawerItem(
                    title: 'Dane i przechowywanie',
                    icon: Icons.storage,
                    onTap: () {},
                  ),

                  // Help
                  DrawerItem(
                    title: 'Pomoc',
                    icon: Icons.help,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HelpPage(),
                      ),
                    ),
                  ),

                  const Divider(
                    height: 35,
                    color: Colors.green,
                  ),

                  // Invite a friend
                  DrawerItem(
                    title: 'Zaproś znajomego',
                    icon: Icons.people_outline,
                    onTap: () {},
                  ),
                ],
              ),

              // Logout button
              DrawerItem(
                title: 'Wyloguj się',
                icon: Icons.logout,
                onTap: () {
                  for (final providerProfile in user.providerData) {
                    final provider = providerProfile.providerId;

                    if (provider == 'google.com') {
                      final googleProvider = Provider.of<GoogleSignInProvider>(context, listen: false);
                      googleProvider.googleLogout();
                    }
                    else if (provider == 'password') {
                      signOutUserWithEmailAndPassword();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget externalConnManagement() => OpenContainer(
    closedColor: const Color(0xFF171717),
    middleColor: const Color(0xFF171717),
    openColor: const Color(0xFF171717),
    transitionDuration: const Duration(milliseconds: 500),
    transitionType: ContainerTransitionType.fadeThrough,
    openBuilder: (_, __) => const SearchPage(),
    closedBuilder: (_, __) => const Padding(
      padding: EdgeInsets.only(top: 32.0),
      child: Icon(
        Icons.search,
        color: Colors.white,
      ),
    ),
  );

  Padding buildContactAvatar(String name, String filename) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Column(
      children: [
        CircleAvatar(
          radius: 29,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('lib/images/$filename'),
        ),
        const SizedBox(height: 5),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );

  Widget buildConversationRow(String name, String message, String filename) => OpenContainer(
    closedColor: const Color(0xF71F1E1E),
    middleColor: const Color(0xF71F1E1E),
    openColor: const Color(0xF71F1E1E),
    transitionDuration: const Duration(milliseconds: 500),
    transitionType: ContainerTransitionType.fadeThrough,
    openBuilder: (_, __) => ChatPage(userName: name),
    closedBuilder: (_, __) => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 29,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('lib/images/$filename'),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 5.0),
              child: Column(
                children: const [
                  Text(
                    '13:21',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
        const Divider(
          indent: 70,
          height: 20,
        ),
      ],
    ),
  );
}
