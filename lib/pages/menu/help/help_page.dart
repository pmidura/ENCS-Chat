import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'help_input_taker.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF171717),
    body: ListView(
      children: [
        // Icon back
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        getListOption(
          icon: const Icon(
            Icons.report_gmailerrorred_outlined,
            size: 20.0,
            color: Colors.red,
          ),
          title: 'Report a problem',
          extraText: 'About app crashing, bugs report',
        ),

        getListOption(
          icon: const Icon(
            Icons.request_page_outlined,
            size: 20.0,
            color: Colors.green,
          ),
          title: 'Request a feature',
          extraText: 'Any new feature in your mind',
        ),

        getListOption(
          icon: const Icon(
            Icons.featured_play_list_outlined,
            size: 20.0,
            color: Colors.amber,
          ),
          title: 'Send feedback',
          extraText: 'Your experience of that app',
        ),
      ],
    ),
  );

  Widget getListOption({
    required Icon icon,
    required String title,
    required String extraText,
  }) => OpenContainer(
    closedColor: const Color(0xFF171717),
    middleColor: const Color(0xFF171717),
    openColor: const Color(0xFF171717),
    closedElevation: 0.0,
    transitionType: ContainerTransitionType.fadeThrough,
    transitionDuration: const Duration(milliseconds: 500),
    openBuilder: (_, __) {
      if (title == 'Report a problem') {
        return const HelpInputTaker(
          subject: 'Problem',
          appBarTitle: 'Describe your problem',
        );
      }
      else if (title == 'Request a feature') {
        return const HelpInputTaker(
          subject: 'Feature',
          appBarTitle: 'Describe the feature',
        );
      }
      else if (title == 'Send feedback') {
        return const HelpInputTaker(
          subject: 'Feedback',
          appBarTitle: 'Write your feedback',
        );
      }
      return const Center();
    },
    closedBuilder: (_, __) => Container(
      height: 80,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: icon,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    extraText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
