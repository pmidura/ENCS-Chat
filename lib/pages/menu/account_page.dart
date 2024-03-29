import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String userCreationDate = '', userCreationTime = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF171717),
    body: Column(
      children: [
        Expanded(
          child: ListView(
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

              // Join date
              userInfo('Data dołączenia', '03-03-2023'),

              // Join time
              userInfo('Godzina dołączenia', '12:35 AM'),
            ],
          ),
        ),

        // Delete account btn
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: deleteButton(context),
        ),
      ],
    ),
  );

  Widget userInfo(String leftText, String rightText) => Container(
    height: 35,
    margin: const EdgeInsets.only(bottom: 30.0),
    child: Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              leftText,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: Text(
              rightText,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget deleteButton(BuildContext context) => Center(
    child: TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
          side: const BorderSide(color: Colors.red),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        alignment: Alignment.center,
        child: Row(
          children: const [
            Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
            Expanded(
              child: Text(
                'Usuń konto',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
      onPressed: () async => await confirmDelete(),
    ),
  );

  Future<void> confirmDelete() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        title: const Center(
          child: Text(
            'Czy na pewno chcesz usunąć swoje konto?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
          ),
        ),
        content: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Center(
                child: Text(
                  'Jeśli usuniesz konto, wszystkie dane zostaną utracone na zawsze...\n\nCzy chcesz kontynuować?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side: const BorderSide(color: Colors.green),
                      ),
                    ),
                    child: const Text(
                      'Zakończ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      debugPrint('Delete Event!');
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                    child: const Text(
                      'Potwierdź',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
