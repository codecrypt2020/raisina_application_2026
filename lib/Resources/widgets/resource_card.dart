import 'package:attendee_app/Resources/utils/resource_file_actions.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class ResourceCard extends StatefulWidget {
  const ResourceCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.date,
    required this.size,
    required this.file_url,
    required this.showDownloadButton,
    this.badgeText,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String type;
  final String date;
  final String size;
  final String file_url;
  final bool showDownloadButton;
  final String? badgeText;

  @override
  State<ResourceCard> createState() => _ResourceCardState();
}

class _ResourceCardState extends State<ResourceCard> {
  bool _isDownloading = false;

  IconData getFileIcon(String fileUrl) {
    String extension = fileUrl.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;

      case 'xls':
      case 'xlsx':
        return Icons.table_chart;

      case 'ppt':
      case 'pptx':
        return Icons.slideshow;

      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;

      case 'doc':
      case 'docx':
        return Icons.description;

      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValidUrl = widget.file_url.trim().isNotEmpty;
    final Color cardColor = AppColors.elevatedOf(context);
    final Color borderColor = AppColors.borderOf(context);
    final Color titleColor = AppColors.textPrimaryOf(context);
    final Color secondaryColor = AppColors.textSecondaryOf(context);
    final Color mutedColor = AppColors.textMutedOf(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.iconColor.withOpacity(0.14),
            ),
            child: Icon(
              getFileIcon(widget.file_url),
              color: widget.iconColor,
            ),
            //Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 2),
                if (widget.subtitle != "") ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 15,
                    ),
                  ),
                ],
                // Text(
                //   subtitle,
                //   style: const TextStyle(
                //     color: AppColors.textSecondary,
                //     fontSize: 15,
                //   ),
                // ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.insert_drive_file_outlined,
                        size: 16, color: mutedColor),
                    const SizedBox(width: 4),
                    Text(
                      widget.type,
                      style: TextStyle(
                        color: mutedColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 16, color: mutedColor),
                    const SizedBox(width: 4),
                    Text(
                      widget.date,
                      style: TextStyle(
                        color: mutedColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.size,
                      style: TextStyle(
                        color: mutedColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (widget.badgeText != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.goldDim,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.badgeText!,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: hasValidUrl
                          ? () => ResourceFileActions.previewFile(
                              context, widget.file_url, widget.title)
                          : null,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: borderColor),
                        foregroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Preview',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (widget.showDownloadButton) ...[
                      ElevatedButton(
                        onPressed: hasValidUrl && !_isDownloading
                            ? () async {
                                setState(() => _isDownloading = true);
                                try {
                                  await ResourceFileActions.downloadFile(
                                    context,
                                    widget.file_url,
                                    widget.title,
                                    fileTypeHint: widget.type,
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() => _isDownloading = false);
                                  }
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.goldDim,
                          foregroundColor: AppColors.gold,
                          disabledBackgroundColor:
                              AppColors.surfaceSoftOf(context),
                          disabledForegroundColor: mutedColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isDownloading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(mutedColor),
                                ),
                              )
                            : const Text(
                                'Download',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
