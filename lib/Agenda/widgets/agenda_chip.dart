import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class AgendaCard extends StatelessWidget {
  const AgendaCard({
    required this.time,
    required this.title,
    required this.location,
    required this.description,
    required this.starttime,
    required this.endtime,
    required this.speaker,
    this.highlight = false,
    this.tag,
    this.tagColor,
    this.isLive = false,
  });

  final String time;
  final String title;
  final String location;
  final String description;
  final String starttime;
  final String endtime;
  final String speaker;
  final bool highlight;
  final String? tag;
  final Color? tagColor;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? AppColors.navyElevated : AppColors.navyMid,
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
          Column(
            children: [
              Container(
                padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: highlight ? AppColors.navySurface : AppColors.navySurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  starttime,
                  style:  TextStyle(fontWeight: FontWeight.w700, color: AppColors.gold),
                ),
              ),
              
              SizedBox(height:20,),

              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              //   decoration: BoxDecoration(
              //     color: highlight ? AppColors.navySurface : AppColors.navySurface,
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Text(
              //      endtime,
              //     style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.gold),
              //   ),
              // ),

            ],
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
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                    ),
                    if (isLive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.red),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(location, style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(speaker, style: const TextStyle(color: AppColors.textMuted)),
                if (tag != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                //  SizedBox(height: 6),
                // Container(
                //     padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                //     decoration: BoxDecoration(
                //       color: (tagColor ?? AppColors.gold).withOpacity(0.2),
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: Text(
                //       description,
                //       style: TextStyle(
                //         fontSize: 11,
                //         fontWeight: FontWeight.w600,
                //         color: tagColor ?? AppColors.gold,
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
          const Icon(Icons.bookmark_border, color: AppColors.goldLight),
        ],
      ),
    );
  }
}