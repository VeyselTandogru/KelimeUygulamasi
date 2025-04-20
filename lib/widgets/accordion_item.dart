import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

class AccordionItem extends StatefulWidget {
  final String title;
  final IconData iconData;
  final Widget expandedContent;
  final Color iconColor;

  const AccordionItem({
    super.key,
    required this.title,
    required this.iconData,
    required this.expandedContent,
    this.iconColor = AppConstants.primaryColor,
  });

  @override
  State<AccordionItem> createState() => _AccordionItemState();
}

class _AccordionItemState extends State<AccordionItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: ListTile(
            leading: Icon(
              widget.iconData,
              color: widget.iconColor,
              size: AppConstants.iconSize,
            ),
            title: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              size: AppConstants.iconSize,
            ),
          ),
        ),
        AnimatedContainer(
          duration: AppConstants.animationDurationMedium,
          height: _isExpanded ? null : 0,
          child: AnimatedOpacity(
            opacity: _isExpanded ? 1.0 : 0.0,
            duration: AppConstants.animationDurationMedium,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              child: widget.expandedContent,
            ),
          ),
        ),
      ],
    );
  }
}
