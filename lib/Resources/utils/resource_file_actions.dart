import 'package:flutter/material.dart';
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
    final messenger = ScaffoldMessenger.of(context);
    final rawUrl = fileUrl.trim();
    final uri = Uri.tryParse(rawUrl);
    if (uri == null || fileUrl.trim().isEmpty) {
      _showMessage(messenger, 'Invalid file URL for $title');
      return;
    }

    final previewUri = _buildPreviewUri(rawUrl);
    final launched = await launchUrl(previewUri, mode: LaunchMode.inAppWebView);
    if (!launched) {
      _showMessage(messenger, 'Could not open preview for $title');
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
}
