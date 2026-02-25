import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class SpeakingEngagementCard extends StatelessWidget {
  const SpeakingEngagementCard({
    required this.date,
    required this.title,
    required this.location,
    required this.speaker,
    required this.time,
    this.highlight = false,
    this.tag,
    this.tagColor,
    this.isLive = false,
  });

  final String date;
  final String title;
  final String location;
  final String speaker;
  final String time;
  final bool highlight;
  final String? tag;
  final Color? tagColor;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final Color cardColor = highlight
        ? AppColors.elevatedOf(context)
        : AppColors.surfaceOf(context);
    final Color slotColor = AppColors.surfaceSoftOf(context);
    final Color titleColor = AppColors.textPrimaryOf(context);
    final Color secondaryColor = AppColors.textSecondaryOf(context);
    final Color mutedColor = AppColors.textMutedOf(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: highlight ? AppColors.gold : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: slotColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  date.split(' ')[0],
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.gold),
                ),
                Text(
                  date.split(' ')[1],
                  style: TextStyle(fontSize: 12, color: mutedColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: titleColor),
                      ),
                    ),
                    if (isLive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.red),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(time, style: TextStyle(color: secondaryColor)),
                const SizedBox(height: 6),
                Text(location, style: TextStyle(color: secondaryColor)),
                const SizedBox(height: 4),
                Text(speaker, style: TextStyle(color: mutedColor)),
                if (tag != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (tagColor ?? AppColors.gold).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: tagColor ?? AppColors.gold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          //the bookmark icon at the end
          // const Icon(Icons.bookmark_border, color: AppColors.goldLight),
        ],
      ),
    );
  }
}
