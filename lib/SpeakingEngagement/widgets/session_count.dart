import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class SpeakingSessionsBanner extends StatelessWidget {
  final int sessions;
  final int days;

  const SpeakingSessionsBanner({
    required this.sessions,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            AppColors.gold.withOpacity(0.15),
            AppColors.gold.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: AppColors.gold.withOpacity(0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.mic_none, color: AppColors.gold, size: 26),
          const SizedBox(width: 12),

          /// 👇 Flexible instead of Expanded (safer for wrapping)
          Flexible(
            child: Text(
              "You have $sessions speaking "
              "${sessions == 1 ? "session" : "sessions"} "
              "across ${(days != null || days == 0) ? "" : days} ${days == 1 ? "day" : "days"}.",
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              softWrap: true,
              maxLines: 4,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
