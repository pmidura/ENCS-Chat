import 'package:flutter/material.dart';

class HelpInputTaker extends StatefulWidget {
  final String subject;
  final String appBarTitle;

  const HelpInputTaker({
    super.key,
    required this.subject,
    required this.appBarTitle,
  });

  @override
  State<HelpInputTaker> createState() => _HelpInputTakerState();
}

class _HelpInputTakerState extends State<HelpInputTaker> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final TextEditingController problemTitleController = TextEditingController();
  final TextEditingController problemDescriptionController = TextEditingController();

  @override
  void initState() {
    problemTitleController.text = '';
    problemDescriptionController.text = '';
    super.initState();
  }

  @override
  void dispose() {
    problemTitleController.dispose();
    problemDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF171717),
    body: Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _globalKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            // Icon back
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 70),
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

            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width - 40,
              child: TextFormField(
                controller: problemTitleController,
                style: const TextStyle(color: Colors.white),
                validator: (inputVal) {
                  if (inputVal!.isEmpty) return 'Please provide a problem title';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: '${widget.subject} Title',
                  labelStyle: const TextStyle(
                    color: Colors.white70,
                    letterSpacing: 1.0,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width - 40,
              child: TextFormField(
                maxLines: null,
                controller: problemDescriptionController,
                style: const TextStyle(color: Colors.white),
                validator: (inputVal) {
                  if (inputVal!.isEmpty) return 'Please provide a problem description';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: '${widget.subject} Description',
                  labelStyle: const TextStyle(
                    color: Colors.white70,
                    letterSpacing: 1.0,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
              child: TextButton(
                onPressed: () async {
                  if (_globalKey.currentState!.validate()) await sendMail();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  side: const BorderSide(color: Colors.green),
                ),
                child: const Text(
                  'Send',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> sendMail() async {
    Navigator.pop(context);

    final Uri params = Uri(
      scheme: 'mailto',
      path: 'patrykmidura@gmail.com',
      query: 'subject=${widget.subject}: ${problemTitleController.text} &body=${problemDescriptionController.text}',
    );

    // final String url = params.toString();
    try {
      // await launch(url);
    }
    catch (ex) {
      debugPrint('Mail sending error: ${ex.toString()}');
    }
  }
}
