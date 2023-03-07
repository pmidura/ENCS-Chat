import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String photoURL;

  const UserAvatar({super.key, required this.photoURL});

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 29,
    backgroundColor: Colors.transparent,
    backgroundImage: NetworkImage(photoURL),
  );
}