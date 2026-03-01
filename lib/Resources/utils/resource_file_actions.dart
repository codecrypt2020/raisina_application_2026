import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final messenger = ScaffoldMessenger.maybeOf(context);
    final route = ModalRoute.of(context);
    final rawUrl = fileUrl.trim();
    final uri = Uri.tryParse(rawUrl);
    if (uri == null || fileUrl.trim().isEmpty) {
      _showMessage(messenger, route, 'Invalid file URL for $title');
      return;
    }

    final previewUri = _buildPreviewUri(rawUrl);
    final launched =
        await launchUrl(previewUri, mode: LaunchMode.externalApplication);
    if (!launched) {
      _showMessage(messenger, route, 'Could not open preview for $title');
    }
  }

  static Future<void> downloadFile(
    BuildContext context,
    String fileUrl,
    String title, {
    String? fileTypeHint,
    bool openAfterDownload = false,
  }) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final route = ModalRoute.of(context);
    final rawUrl = fileUrl.trim();
    final uri = Uri.tryParse(rawUrl);
    if (uri == null || rawUrl.isEmpty) {
      _showMessage(messenger, route, 'Invalid file URL for $title');
      return;
    }

    final saveDir = await _getDownloadDirectory();
    if (saveDir == null) {
      _showMessage(messenger, route, 'Could not access storage for download');
      return;
    }

    final fileName = _buildFileName(
      rawUrl,
      title,
      fileTypeHint: fileTypeHint,
    );
    final file = File('${saveDir.path}/$fileName');
    final tempFile = File('${file.path}.part');

    if (await file.exists()) {
      _showDownloadSuccess(
        messenger,
        route,
        file.path,
        onViewPressed: () => _openDownloadedFile(
          messenger,
          route,
          file.path,
          sourceUrl: rawUrl,
        ),
        alreadyExists: true,
      );
      if (openAfterDownload) {
        await _openDownloadedFile(
          messenger,
          route,
          file.path,
          sourceUrl: rawUrl,
        );
      }
      return;
    }

    _showMessage(messenger, route, 'Downloading $fileName...');
    final client = http.Client();

    try {
      final request = http.Request('GET', uri);
      final response = await client.send(request);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _showMessage(messenger, route, 'Download failed for $title');
        return;
      }

      final sink = tempFile.openWrite();
      await response.stream.pipe(sink);
      await sink.close();
      await tempFile.rename(file.path);

      _showDownloadSuccess(
        messenger,
        route,
        file.path,
        onViewPressed: () => _openDownloadedFile(
          messenger,
          route,
          file.path,
          sourceUrl: rawUrl,
        ),
      );
      if (openAfterDownload) {
        await _openDownloadedFile(
          messenger,
          route,
          file.path,
          sourceUrl: rawUrl,
        );
      }
    } catch (_) {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
      _showMessage(messenger, route, 'Download failed for $title');
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

  static bool _canShowFeedback(
    ScaffoldMessengerState? messenger,
    ModalRoute<dynamic>? route,
  ) {
    if (messenger == null) return false;
    if (route == null) return true;
    return route.isCurrent;
  }

  static void _showMessage(
    ScaffoldMessengerState? messenger,
    ModalRoute<dynamic>? route,
    String message,
  ) {
    if (!_canShowFeedback(messenger, route)) return;
    messenger!.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  static void _showDownloadSuccess(
    ScaffoldMessengerState? messenger,
    ModalRoute<dynamic>? route,
    String filePath, {
    required VoidCallback onViewPressed,
    bool alreadyExists = false,
  }) {
    if (!_canShowFeedback(messenger, route)) return;
    final text = alreadyExists
        ? 'Already downloaded: $filePath'
        : 'Downloaded to: $filePath';
    messenger!.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
          label: 'View',
          onPressed: onViewPressed,
        ),
      ),
    );
  }

  static Future<void> _openDownloadedFile(
    ScaffoldMessengerState? messenger,
    ModalRoute<dynamic>? route,
    String filePath, {
    String? sourceUrl,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      _showMessage(messenger, route, 'File not found');
      return;
    }

    bool noAppFound = false;
    try {
      final result = await OpenFilex.open(filePath);
      if (result.type == ResultType.done) {
        return;
      }

      if (result.type == ResultType.noAppToOpen) {
        noAppFound = true;
      }
    } on MissingPluginException {
      // Fallback when plugin isn't registered in the current runtime.
      final uri = Uri.file(filePath);
      var opened = await launchUrl(uri);
      if (!opened) {
        opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      if (opened) return;
    } catch (_) {}

    if (sourceUrl != null && sourceUrl.trim().isNotEmpty) {
      final trimmedSourceUrl = sourceUrl.trim();
      final previewUri = _buildPreviewUri(trimmedSourceUrl);
      final openedOnline = await launchUrl(
        previewUri,
        mode: LaunchMode.externalApplication,
      );
      if (openedOnline) {
        return;
      }

      // iOS fallback: open original URL directly (Safari/associated apps).
      final rawUri = Uri.tryParse(trimmedSourceUrl);
      if (rawUri != null) {
        final openedRaw = await launchUrl(
          rawUri,
          mode: LaunchMode.externalApplication,
        );
        if (openedRaw) {
          return;
        }
      }
    }

    if (noAppFound) {
      _showMessage(
        messenger,
        route,
        'No app found to open this file type on your device',
      );
    } else {
      _showMessage(messenger, route, 'Could not open downloaded file');
    }
  }

  static Future<Directory?> _getDownloadDirectory() async {
    Directory? baseDir;
    if (Platform.isAndroid) {
      // Prefer Downloads so users can find files easily in file managers.
      baseDir = await getDownloadsDirectory();
      baseDir ??= await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      // iOS app sandbox; visible via Files app only when file sharing is enabled.
      baseDir = await getApplicationDocumentsDirectory();
    } else {
      baseDir = await getDownloadsDirectory();
      baseDir ??= await getApplicationDocumentsDirectory();
    }

    if (baseDir == null) return null;
    final resourcesDir = Directory('${baseDir.path}/resources_downloads');
    if (!await resourcesDir.exists()) {
      await resourcesDir.create(recursive: true);
    }
    return resourcesDir;
  }

  static String _buildFileName(
    String fileUrl,
    String title, {
    String? fileTypeHint,
  }) {
    final parsed = Uri.tryParse(fileUrl);
    final urlFileName = parsed != null && parsed.pathSegments.isNotEmpty
        ? parsed.pathSegments.last
        : '';
    if (urlFileName.isNotEmpty) {
      final safeUrlName = _sanitizeFileName(urlFileName);
      if (safeUrlName.contains('.')) return safeUrlName;
    }

    final fallbackExt = _extensionFromFileTypeHint(fileTypeHint) ??
        _extensionForType(getFileTypeFromUrl(fileUrl));
    final safeTitle =
        _sanitizeFileName(title.trim().isEmpty ? 'resource' : title);
    return '$safeTitle$fallbackExt';
  }

  static String? _extensionFromFileTypeHint(String? fileTypeHint) {
    final hint = fileTypeHint?.toLowerCase().trim() ?? '';
    if (hint.isEmpty) return null;

    if (hint.contains('xlsx') || hint.contains('excel')) return '.xlsx';
    if (hint.contains('xls')) return '.xls';
    if (hint.contains('docx') || hint.contains('word')) return '.docx';
    if (hint.contains('doc')) return '.doc';
    if (hint.contains('pptx') || hint.contains('powerpoint')) return '.pptx';
    if (hint.contains('ppt')) return '.ppt';
    if (hint.contains('pdf')) return '.pdf';
    if (hint.contains('png')) return '.png';
    if (hint.contains('jpeg') || hint.contains('jpg')) return '.jpg';
    if (hint.contains('gif')) return '.gif';
    if (hint.contains('webp')) return '.webp';
    if (hint.contains('image')) return '.jpg';

    return null;
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
