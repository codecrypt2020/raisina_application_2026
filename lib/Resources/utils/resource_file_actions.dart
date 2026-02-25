import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_filex/open_filex.dart';

enum ResourceFileType { pdf, image, word, powerpoint, excel, other }

class ResourceFileActions {
  static ResourceFileType getFileTypeFromUrl(String fileUrl) {
    final path = Uri.tryParse(fileUrl)?.path.toLowerCase() ?? '';

    if (path.endsWith('.pdf')) return ResourceFileType.pdf;
    if (path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.gif') ||
        path.endsWith('.webp')) {
      return ResourceFileType.image;
    }
    if (path.endsWith('.doc') || path.endsWith('.docx')) {
      return ResourceFileType.word;
    }
    if (path.endsWith('.ppt') || path.endsWith('.pptx')) {
      return ResourceFileType.powerpoint;
    }
    if (path.endsWith('.xls') || path.endsWith('.xlsx')) {
      return ResourceFileType.excel;
    }

    return ResourceFileType.other;
  }

  static Future<void> previewFile(
      BuildContext context, String fileUrl, String title) async {
    final messenger = ScaffoldMessenger.of(context);
    final rawUrl = fileUrl.trim();
    final uri = Uri.tryParse(rawUrl);

    if (uri == null || rawUrl.isEmpty) {
      _showMessage(messenger, 'Invalid file URL for $title');
      return;
    }

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      _showMessage(messenger, 'Could not open $title — trying local open...');

      final fileName = _buildFileName(rawUrl, title);
      final file = await _downloadToFile(rawUrl, fileName);
      if (file == null) {
        _showMessage(messenger, 'Could not download $title to open');
        return;
      }

      await OpenFilex.open(file.path);
    }
  }

  static Future<File?> _downloadToFile(String rawUrl, String fileName) async {
    final uri = Uri.tryParse(rawUrl);
    if (uri == null) return null;

    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      final client = http.Client();
      final request = http.Request('GET', uri);
      final response = await client.send(request);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        client.close();
        return null;
      }

      final sink = file.openWrite();
      await response.stream.pipe(sink);
      await sink.close();
      client.close();
      return file;
    } catch (_) {
      return null;
    }
  }

  static Future<void> downloadFile(
      BuildContext context, String fileUrl, String title) async {
    final messenger = ScaffoldMessenger.of(context);
    final rawUrl = fileUrl.trim();
    final uri = Uri.tryParse(rawUrl);
    if (uri == null || rawUrl.isEmpty) {
      _showMessage(messenger, 'Invalid file URL for $title');
      return;
    }

    final saveDir = await _getDownloadDirectory();
    if (saveDir == null) {
      _showMessage(messenger, 'Could not access storage for download');
      return;
    }

    final fileName = _buildFileName(rawUrl, title);
    final file = File('${saveDir.path}/$fileName');

    _showMessage(messenger, 'Downloading $fileName...');
    final client = http.Client();

    try {
      final request = http.Request('GET', uri);
      final response = await client.send(request);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _showMessage(messenger, 'Download failed for $title');
        return;
      }

      final sink = file.openWrite();
      await response.stream.pipe(sink);
      await sink.close();

      _showMessage(messenger, 'Downloaded: ${file.path}');
    } catch (_) {
      _showMessage(messenger, 'Download failed for $title');
    } finally {
      client.close();
    }
  }

  static Uri _buildPreviewUri(String fileUrl) {
    final fileType = getFileTypeFromUrl(fileUrl);
    if (fileType == ResourceFileType.word ||
        fileType == ResourceFileType.powerpoint ||
        fileType == ResourceFileType.excel) {
      return Uri.parse(
        'https://view.officeapps.live.com/op/view.aspx?src=${Uri.encodeComponent(fileUrl)}',
      );
    }

    return Uri.parse(fileUrl);
  }

  static void _showMessage(ScaffoldMessengerState messenger, String message) {
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return getExternalStorageDirectory();
    }
    return getApplicationDocumentsDirectory();
  }

  static String _buildFileName(String fileUrl, String title) {
    final parsed = Uri.tryParse(fileUrl);
    final urlFileName = parsed != null && parsed.pathSegments.isNotEmpty
        ? parsed.pathSegments.last
        : '';
    if (urlFileName.isNotEmpty) return _sanitizeFileName(urlFileName);

    final type = getFileTypeFromUrl(fileUrl);
    final fallbackExt = _extensionForType(type);
    final safeTitle =
        _sanitizeFileName(title.trim().isEmpty ? 'resource' : title);
    return '$safeTitle$fallbackExt';
  }

  static String _sanitizeFileName(String value) {
    return value.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  }

  static String _extensionForType(ResourceFileType type) {
    switch (type) {
      case ResourceFileType.pdf:
        return '.pdf';
      case ResourceFileType.image:
        return '.jpg';
      case ResourceFileType.word:
        return '.docx';
      case ResourceFileType.powerpoint:
        return '.pptx';
      case ResourceFileType.excel:
        return '.xlsx';
      case ResourceFileType.other:
        return '';
    }
  }
}
