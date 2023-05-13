import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/models/message_model.dart';

import '../../constants/colors.dart';

class Chat_page extends StatefulWidget {
  const Chat_page({super.key});

  @override
  State<Chat_page> createState() => _Chat_pageState();
}

class _Chat_pageState extends State<Chat_page> {
  late FirebaseDatabase database;
  late DatabaseReference dbRef;
  ScrollController _messageScrollController =  ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    database = FirebaseDatabase.instance;
    dbRef = FirebaseDatabase.instance
        .ref("messages/fb8f1616-9d1f-4bd3-b0b7-8611d6a5545a/");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(pageName: "Messages", showDivider: true,),
      body: Column(
        children: [
          StreamBuilder(
              stream: dbRef.onValue,
              builder: (_, AsyncSnapshot<DatabaseEvent> event) {
                print(event.data?.snapshot);
                if(event.hasData && event.data != null){
                  return SizedBox(
                    height: 400,
                    child: ListView.builder(
                        controller: _messageScrollController,
                        itemCount: event.data?.snapshot.children.length,
                        itemBuilder: (_, idx) {
                          List<DataSnapshot> _currentMsg = event.data!.snapshot.children.toList();
                          Message _msg = Message.fromMap(_currentMsg[idx].value as Map<dynamic, dynamic>);

                          return Wrap(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      decoration: const BoxDecoration(
                                        color: MYcolors.greycolor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                      ),
                                      width: MediaQuery.of(context).size.width * 0.65,
                                      child: _msg.type == "image"? Image.network(_msg.message): Text("${_msg.message}")
                                  ),
                                ],
                              ),
                              Text("05:08 PM"),
                            ],
                          );
                        }),
                  );
                }
                return SizedBox();
              }),
          ElevatedButton(
              onPressed: () async {
                await dbRef.push().set({
                  "from": 1,
                  "type": "image",
                  "message":
                      "https://picsum.photos/200/300",
                });
                _messageScrollController.animateTo(_messageScrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.ease);
              },
              child: Text("Send Message"))
        ],
      ),
    ));
  }
}
