import 'package:encs_chat/firebase/cloud_store_data_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../global/enum_gen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> availableUsers = [];
  List<Map<String, dynamic>> sortedAvailableUsers = [];
  List<dynamic> myConnRequestCollection = [];

  bool _isLoading = false;

  final CloudStoreDataManagement _cloudStoreDataManagement = CloudStoreDataManagement();

  Future<void> initialDataFetchAndCheckUp() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    final List<Map<String, dynamic>> takeUsers = await _cloudStoreDataManagement.getAllUsersListExceptMyAccount(
      currentUserEmail: FirebaseAuth.instance.currentUser!.email.toString(),
    );
    final List<Map<String, dynamic>> takeUsersAfterSorted = [];

    if (mounted) {
      setState(() {
        for (var element in takeUsers) {
          if (mounted) {
            setState(() {
              takeUsersAfterSorted.add(element);
            });
          }
        }
      });
    }

    final List<dynamic> connRequestList = await _cloudStoreDataManagement.currentUserConnRequestList(
      email: FirebaseAuth.instance.currentUser!.email.toString(),
    );

    if (mounted) {
      setState(() {
        availableUsers = takeUsers;
        sortedAvailableUsers = takeUsersAfterSorted;
        myConnRequestCollection = connRequestList;
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    initialDataFetchAndCheckUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus?.unfocus(), // Dismiss the keyboard when touched outside
    child: SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false, // Avoid error => Bottom overflowed by x pixels when showing keyboard
        backgroundColor: const Color(0xFF171717),
        body: LoadingOverlay(
          isLoading: _isLoading,
          color: Colors.black54,
          child: Container(
            margin: const EdgeInsets.all(12.0),
            width: double.maxFinite,
            height: double.maxFinite,
            child: Column(
              children: [
                // Icon back
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
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

                // Search bar
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: TextField(
                    autofocus: false,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Wyszukaj użytkownika',
                      hintStyle: const TextStyle(
                        color: Colors.white70,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Colors.grey[400]!,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Colors.grey[800]!,
                        ),
                      ),
                    ),
                    onChanged: (writeText) {
                      if (mounted) {
                        setState(() {
                          _isLoading = true;
                        });
                      }

                      if (mounted) {
                        setState(() {
                          sortedAvailableUsers.clear();
                          for (var userNameMap in availableUsers) {
                            if (userNameMap.values.first.toString().toLowerCase().startsWith(writeText.toLowerCase())) {
                              sortedAvailableUsers.add(userNameMap);
                            }
                          }
                        });
                      }

                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                  ),
                ),

                // List of users
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: sortedAvailableUsers.length,
                    itemBuilder: (connContext, index) => connShowUp(index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget connShowUp(int index) => Padding(
    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              sortedAvailableUsers[index].values.first.toString(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
        TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(
                color: getRelevantButtonConfig(
                  connectionStateType: ConnectionStateType.buttonBorderColor,
                  index: index,
                ),
              ),
            ),
          ),
          child: getRelevantButtonConfig(
            connectionStateType: ConnectionStateType.buttonNameWidget,
            index: index,
          ),
          onPressed: () async {
            final String buttonName = getRelevantButtonConfig(
              connectionStateType: ConnectionStateType.buttonOnlyName,
              index: index,
            );

            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }

            if (buttonName == ConnectionStateName.connect.value) {
              if (mounted) {
                setState(() {
                  myConnRequestCollection.add({
                    sortedAvailableUsers[index].keys.first.toString() :
                    OtherConnectionStatus.requestPending.toString(),
                  });
                });
              }

              await _cloudStoreDataManagement.changeConnStatus(
                oppositeUserMail: sortedAvailableUsers[index].keys.first.toString(),
                currentUserMail: FirebaseAuth.instance.currentUser!.email.toString(),
                connUpdatedStatus: OtherConnectionStatus.invitationCame.toString(),
                currentUserUpdatedConnRequest: myConnRequestCollection,
              );
            }
            else if (buttonName == ConnectionStateName.accept.value) {
              if (mounted) {
                setState(() {
                  for (var element in myConnRequestCollection) {
                    if (element.keys.first.toString() == sortedAvailableUsers[index].keys.first.toString()) {
                      myConnRequestCollection[myConnRequestCollection.indexOf(element)] = {
                        sortedAvailableUsers[index].keys.first.toString() :
                        OtherConnectionStatus.invitationAccepted.toString(),
                      };
                    }
                  }
                });
              }

              await _cloudStoreDataManagement.changeConnStatus(
                storeDataAlsoInConnections: true,
                oppositeUserMail: sortedAvailableUsers[index].keys.first.toString(),
                currentUserMail: FirebaseAuth.instance.currentUser!.email.toString(),
                connUpdatedStatus: OtherConnectionStatus.requestAccepted.toString(),
                currentUserUpdatedConnRequest: myConnRequestCollection,
              );
            }

            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      ],
    ),
  );

  dynamic getRelevantButtonConfig({required ConnectionStateType connectionStateType, required int index}) {
    bool isUserPresent = false;
    String storeStatus = '';

    for (var element in myConnRequestCollection) {
      if (element.keys.first.toString() == sortedAvailableUsers[index].keys.first.toString()) {
        isUserPresent = true;
        storeStatus = element.values.first.toString();
      }
    }

    if (isUserPresent) {
      if (storeStatus == OtherConnectionStatus.requestPending.toString() ||
        storeStatus == OtherConnectionStatus.invitationCame.toString()) {
        if (connectionStateType == ConnectionStateType.buttonNameWidget) {
          return Text(
            storeStatus == OtherConnectionStatus.requestPending.toString() ?
            ConnectionStateName.pending.value :
            ConnectionStateName.accept.value,
            style: const TextStyle(
              color: Colors.yellow,
            ),
          );
        }
        else if (connectionStateType == ConnectionStateType.buttonOnlyName) {
          return storeStatus == OtherConnectionStatus.requestPending.toString() ?
          ConnectionStateName.pending.value :
          ConnectionStateName.accept.value;
        }
        return Colors.yellow;
      }
      else {
        if (connectionStateType == ConnectionStateType.buttonNameWidget) {
          return Text(
            ConnectionStateName.connected.value,
            style: const TextStyle(
              color: Colors.green,
            ),
          );
        }
        else if (connectionStateType == ConnectionStateType.buttonOnlyName) {
          return ConnectionStateName.connected.value;
        }
        return Colors.green;
      }
    }
    else {
      if (connectionStateType == ConnectionStateType.buttonNameWidget) {
        return Text(
          ConnectionStateName.connect.value,
          style: const TextStyle(
            color: Colors.lightBlue,
          ),
        );
      }
      else if (connectionStateType == ConnectionStateType.buttonOnlyName) {
        return ConnectionStateName.connect.value;
      }
      return Colors.lightBlue;
    }
  }
}
