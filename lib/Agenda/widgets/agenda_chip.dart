import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class AgendaCard extends StatefulWidget {
  const AgendaCard({
    super.key,
    required this.time,
    required this.title,
    required this.location,
    required this.description,
    required this.starttime,
    required this.endtime,
    required this.speaker,
    required this.Cat_tag,
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
  final List<String> Cat_tag;
  final String? tag;
  final Color? tagColor;
  final bool isLive;

  @override
  State<AgendaCard> createState() => _AgendaCardState();
}

class _AgendaCardState extends State<AgendaCard> {
  static const int _descriptionLimit = 50;
  bool _isDescriptionExpanded = false;

  Widget _buildDescription(BuildContext context) {
    final String description = widget.description.trim();
    if (description.isEmpty) return const SizedBox.shrink();

    final TextStyle style = TextStyle(
      color: AppColors.textSecondaryOf(context),
      fontSize: 12,
      height: 1.3,
    );

    if (_isDescriptionExpanded || description.length <= _descriptionLimit) {
      if (description.length <= _descriptionLimit) {
        return Text(description, style: style);
      }
      return GestureDetector(
        onTap: () {
          setState(() {
            _isDescriptionExpanded = false;
          });
        },
        child: Text(description, style: style),
      );
    }

    final String limitedText = description.substring(0, _descriptionLimit);
    final int lastSpace = limitedText.lastIndexOf(' ');
    final String shortText =
        (lastSpace > 0 ? limitedText.substring(0, lastSpace) : limitedText)
            .trimRight();

    return GestureDetector(
      onTap: () {
        setState(() {
          _isDescriptionExpanded = true;
        });
      },
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: shortText, style: style),
            TextSpan(
              text: "...",
              style: style.copyWith(
                color: AppColors.gold,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = widget.highlight
        ? AppColors.elevatedOf(context)
        : AppColors.surfaceOf(context);
    final Color slotColor = AppColors.surfaceSoftOf(context);
    final Color titleColor = AppColors.textPrimaryOf(context);
    final Color secondaryColor = AppColors.textSecondaryOf(context);
    final Color mutedColor = AppColors.textMutedOf(context);
    final String? categoryTag = widget.Cat_tag.isNotEmpty
        ? widget.Cat_tag.first.trim().isEmpty
            ? null
            : widget.Cat_tag.first.trim()
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: widget.highlight ? AppColors.gold : Colors.transparent,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: slotColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.starttime.split(' ')[0],
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                      ),
                    ),
                    Text(
                      widget.starttime.split(' ')[1],
                      style: TextStyle(fontSize: 12, color: mutedColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                    ),
                    if (widget.isLive)
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
                            color: AppColors.red,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(widget.location, style: TextStyle(color: secondaryColor)),
                const SizedBox(height: 4),
                Text(widget.speaker, style: TextStyle(color: mutedColor)),
                if (widget.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildDescription(context),
                ],
                if (widget.tag != null || categoryTag != null) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (categoryTag != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSoftOf(context),
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: AppColors.borderOf(context)),
                          ),
                          child: Text(
                            categoryTag,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondaryOf(context),
                            ),
                          ),
                        ),
                      if (widget.tag != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: (widget.tagColor ?? AppColors.gold)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.tag!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: widget.tagColor ?? AppColors.gold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
