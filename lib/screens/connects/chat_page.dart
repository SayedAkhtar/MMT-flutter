import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/models/message_model.dart';
import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
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
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_messageScrollController.hasClients) {
          _messageScrollController.animateTo(
            _messageScrollController.position.maxScrollExtent + 200,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
          setState(() {});
        }
      });
    });
  }

  void stopListening() {
    streamSubscription.cancel();
  }

  void scrollToBottom(ScrollController controller){
    Future.delayed(const Duration(milliseconds: 100), (){
      controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
      _keyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        pageName: "Messages".tr,
        showDivider: true,
      ),
      body: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - ((messageBarHeight)+ toolbarHeight),
              child: Padding(
                  padding: const EdgeInsets.all(CustomSpacer.S),
                  child: ListView.builder(
                      shrinkWrap: true,
                      controller: _messageScrollController,
                      itemCount: messages.length,
                      padding: _keyboardOpen ? EdgeInsets.only(bottom: messageBarHeight) :EdgeInsets.zero,
                      itemBuilder: (ctx, idx) {
                        ChatMessage msg = messages[idx];
                        if (msg.from == LocalUser.TYPE_PATIENT) {
                          return sentMessage(msg);
                        } else {
                          return receivedMessage(msg);
                        }
                      })),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Container(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
                // margin: const EdgeInsets.only(bottom: 16.0),
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
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    dialogTitle: "Upload documents".tr,
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      'jpeg',
                                      'jpg',
                                      'heic',
                                      'png'
                                    ],
                                  );

                                  if (result != null) {
                                    File file = File(result.files.single.path!);
                                    String ext = result.files.single.path!
                                        .split('.')
                                        .last;
                                    try {
                                      String fileName = DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString();
                                      final String? filePath =
                                          await FirebaseFunctions.uploadImage(
                                              file,
                                              ref: storageRef,
                                              title:
                                                  "Uploading Image Please Wait.".tr);
                                      if (filePath != null) {
                                        await FirebaseDatabase.instance
                                            .ref(
                                                "messages/${widget.channelName}/")
                                            .push()
                                            .set({
                                          "from": LocalUser.TYPE_PATIENT,
                                          "type": messageType,
                                          "message": filePath,
                                        });
                                        _messageScrollController.animateTo(
                                            _messageScrollController
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.ease);
                                      } else {
                                        throw Exception(
                                            "File not uploaded. Please try again".tr);
                                      }
                                    } on FirebaseException catch (e) {
                                      Loaders.errorDialog(e.toString());
                                    } catch (e, stacktrace) {
                                      Loaders.errorDialog(e.toString(),
                                          stackTrace: stacktrace);
                                    }
                                  }
                                },
                                icon: const Icon(Icons.image_outlined))
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // var t = await dbRef.get();
                        if(messageController.text.trim() == ""){
                          Loaders.errorDialog("Cannot send message with empty body".tr, title: "Message Error");
                          return;
                        }
                        await FirebaseDatabase.instance
                            .ref("messages/${widget.channelName}/")
                            .push()
                            .set({
                          "from": LocalUser.TYPE_PATIENT,
                          "type": ChatMessage.TEXT,
                          "message": messageController.text.trim(),
                        });
                        messageController.text = "";
                        scrollToBottom(_messageScrollController);

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
              ),
            )
          ],
        ),
      ),
    ));
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
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(bottom: 16.0),
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
      ],
    );
  }

  Widget receivedMessage(ChatMessage data) {
    Widget child;
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
            fontSize: 15,
          ),
        );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(bottom: 16.0),
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
          width: MediaQuery.of(context).size.width * 0.04,
        ),
      ],
    );
  }
}
