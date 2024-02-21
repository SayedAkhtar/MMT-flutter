import 'package:flutter/cupertino.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class AgoraVideoChatScreen extends StatefulWidget {
  final String appId;
  final String channelName;

  const AgoraVideoChatScreen({super.key, required this.channelName, required this.appId});


  @override
  State<AgoraVideoChatScreen> createState() => _AgoraVideoChatScreenState();
}

class _AgoraVideoChatScreenState extends State<AgoraVideoChatScreen> {
  late AgoraClient client;

  @override
  void initState() {
    initAgora();
    super.initState();
  }

  @override
  void dispose() {
    disposeAgora();
    super.dispose();
  }

  void initAgora() async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: widget.appId,
        channelName: widget.channelName,
        username: "Patient",
      ),
    );
    await client.initialize();
  }

  void disposeAgora() async{
    if(client.isInitialized){
      await client.release();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Consultation'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
              enableHostControls: true, // Add this to enable host controls
            ),
            AgoraVideoButtons(
              client: client,
              addScreenSharing: false, // Add this to enable screen sharing
              // enabledButtons: [],
            ),
          ],
        ),
      ),
    );
  }
}
