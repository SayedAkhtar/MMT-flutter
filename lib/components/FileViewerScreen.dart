import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileViewerScreen extends StatefulWidget {
  const FileViewerScreen({super.key, required this.fileUrl});
  final String fileUrl; // Replace with your file URL

  @override
  _FileViewerScreenState createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  String? filePath;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // downloadFile(widget.fileUrl);
  }

  Future<void> downloadFile(String url) async {
    Dio dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String? ext = getFileExtension(url);
    String fileSavePath = '${appDocDir.path}/downloaded_file.$ext';

    try {
      await dio.download(url, fileSavePath);
      setState(() {
        filePath = fileSavePath;
      });
    } catch (error) {
      print('Error downloading file: $error');
    }
  }

  String? getFileExtension(String fileName) {
    try {
      return ".${fileName.split('.').last}";
    } catch (e) {
      return null;
    }
  }

  Future<Widget> buildFileViewer() async {
    try {
      if (widget.fileUrl.endsWith('.pdf')) {
        return SfPdfViewer.network(
          widget.fileUrl,
          key: _pdfViewerKey,
        );
      } else if (widget.fileUrl.endsWith('.jpg') || widget.fileUrl.endsWith('.png')) {
        return Image.network(
          widget.fileUrl,
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
        );
      } else {
        return Text('File type not supported'.tr);
      }
    } catch (e) {
      print(e);
      return const Center(
        child: Text("Cannot process Preview"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Viewer'.tr),
      ),
      body: FutureBuilder<Widget>(
        future: buildFileViewer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return snapshot.data!;
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
