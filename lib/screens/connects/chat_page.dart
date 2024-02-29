import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/models/message_model.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../constants/colors.dart';
import '../../helper/CustomSpacer.dart';
import '../../helper/FirebaseFunctions.dart';
import '../../helper/Loaders.dart';
import '../../helper/Utils.dart';
import '../../models/user_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.previousMessage, required this.channelName});
  final String channelName;
  final List<ChatMessage> previousMessage;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _messageScrollController = ScrollController();
  List<ChatMessage> messages = [];
  int messageFrom = 1;
  String messageType = "image";
  TextEditingController messageController = TextEditingController();
  late Stream<DatabaseEvent> messageStream;
  late StreamSubscription<DatabaseEvent> streamSubscription;
  late String storageRef;
  final double toolbarHeight = CustomAppBar(pageName: '',).height;
  final double messageBarHeight = 76;
  bool messageLoaded = false;
  bool _keyboardOpen = false;
  @override
  void initState() {
    messages = widget.previousMessage;
    storageRef = "messages/${widget.channelName}";
    messageStream = FirebaseDatabase.instance
        .ref("messages/${widget.channelName}/")
        .onValue;
    startListening();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    stopListening();
    _messageScrollController.dispose();
    super.dispose();
  }

  void startListening() {
    streamSubscription = messageStream.listen((DatabaseEvent event) {
      List<ChatMessage> fromServer = [];
      for (var element in event.snapshot.children) {
        ChatMessage temp = ChatMessage.fromMap(
            element.value as Map<dynamic, dynamic>);
        fromServer.add(temp);
      }
      setState(() {
        messages = fromServer;
        messageLoaded = true;
      });
      // _messageScrollController = ScrollController(initialScrollOffset: _messageScrollController.position.maxScrollExtent);
    });
  }

  void stopListening() {
    streamSubscription.cancel();
  }

  void scrollToBottom(ScrollController controller) async{
    // if (_messageScrollController.hasClients) {
    //   Timer(const Duration(milliseconds: 500), () {
    //     _messageScrollController.jumpTo(_messageScrollController.position.maxScrollExtent);
    //   });
    //   setState(() {});
    // }
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      print(messages.length);
      Timer(const Duration(milliseconds: 0), () {
        _messageScrollController.jumpTo(_messageScrollController.position.maxScrollExtent);
      });
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
    pageName: "Messages".tr,
    showDivider: true,
          ),
          body: Padding(
    padding: MediaQuery.of(context).viewInsets,
    child: Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(CustomSpacer.S),
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: _messageScrollController,
                  itemCount: messages.length,
                  padding: EdgeInsets.zero,
                  // cacheExtent: _messageScrollController.position.maxScrollExtent,
                  // itemExtent: 0,
                  itemBuilder: (ctx, idx) {
                    ChatMessage msg = messages[idx];
                    if (msg.from == LocalUser.TYPE_PATIENT) {
                      return sentMessage(msg);
                    } else {
                      return receivedMessage(msg);
                    }
                  })),
        ),
        Container(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
          height: messageBarHeight,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, offset: Offset.fromDirection(-0.1, 10.0), blurRadius: 10.0)],
            color: Colors.white
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.black12, width: 1.5),
                      borderRadius: BorderRadius.circular(100)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: messageType != ChatMessage.TEXT,
                          controller: messageController,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            border: InputBorder.none,
                          ),
                          onTap: (){
                            scrollToBottom(_messageScrollController);
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            final String? filePath = await Utils.uploadFromLibrary("Upload documents".tr, allowedExtensions: [
                              'jpeg',
                              'jpg',
                              'png'
                            ], path: storageRef);
                            if(filePath != null && filePath.isNotEmpty){
                              await sendMessage(
                                from: LocalUser.TYPE_PATIENT,
                                type: messageType,
                                message: filePath,
                              );
                            }
                          },
                          icon: const Icon(Icons.image_outlined))
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String message = messageController.text.trim();
                  if( message == ""){
                    Loaders.errorDialog("Cannot send message with empty body".tr, title: "Message Error");
                    return;
                  }
                  messageController.text = "";
                  await sendMessage(from: LocalUser.TYPE_PATIENT, type: ChatMessage.TEXT, message:message);
                  messageController.text = "";
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(14),
                ),
                child: const Icon(Icons.send),
              ),
            ],
          ),
        )
      ],
    ),
          ),
        );
  }

  Future sendMessage({required int from, required String type, required String message}) async{
    try{
      await FirebaseDatabase.instance
          .ref("messages/${widget.channelName}/")
          .push()
          .set({
        "from": from,
        "type": type,
        "message": message,
      });
    }on FirebaseException catch (e) {
      Loaders.errorDialog("Could not connect to message server. Please try again".tr);
      Logger().e(e);
    } catch (e, stacktrace) {
      Loaders.errorDialog("Could not send message at this moment".tr);
      Logger().e(e.toString(),
          stackTrace: stacktrace);
    }
  }

  String getUserName(data){
    String user;
    switch(data.from){
      case 1:
        user="Patient";
        break;
      case 2:
        user="Admin";
        break;
      case 3:
        user="MMT HCF";
        break;
      case 4:
        user="Doctor";
        break;
      case 5:
        user="Translator";
        break;
      default:
        user="User";
    }
    return user;
  }

  Widget sentMessage(ChatMessage data) {
    Widget child;
    switch (data.type) {
      case ChatMessage.IMAGE:
        child = InkWell(
            onTap: () {
              String ext = data.message.split('.').last != ''
                  ? data.message.split('.').last
                  : 'jpg';
              Utils.saveFileToDevice(
                  "mmt_${DateTime.now().microsecond}.$ext", data.message);
            },
            child: Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.45,
                minHeight: MediaQuery.of(context).size.width * 0.45,
              ),
              child: Image.network(
                data.message,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ));
        break;
      case ChatMessage.FILE:
        child = InkWell(
            onTap: () {
              String ext = data.message.split('.').last;
              Utils.saveFileToDevice(
                  "mmt_${DateTime.now().microsecond}.$ext", data.message);
            },
            child: const Icon(
              Icons.file_copy_rounded,
              size: 32,
            ));
        break;
      default:
        child = Text(
          data.message,
          style: const TextStyle(
            fontSize: 15,
          ),
        );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: const BoxDecoration(
            color: MYcolors.greycolor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.65,
          ),
          child: child,
        ),
        SizedBox(
          child: Text(getUserName(data), style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400
          ),),
        ),
        CustomSpacer.s()
      ],
    );
  }

  Widget receivedMessage(ChatMessage data) {
    Widget child;
    String user;
    switch (data.type) {
      case ChatMessage.IMAGE:
        child = Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.45,
            minHeight: MediaQuery.of(context).size.width * 0.45,
          ),
          child: Image.network(
            data.message,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        );
        break;
      case ChatMessage.FILE:
        child = const Icon(
          Icons.file_copy_rounded,
          size: 32,
        );
        break;
      default:
        child = Text(
          data.message,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400
          ),
        );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: const BoxDecoration(
              color: MYcolors.greenlightcolor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            child: child),
        SizedBox(
          child: Text(getUserName(data), style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400
          ),),
        ),
        CustomSpacer.s()
      ],
    );
  }
}
