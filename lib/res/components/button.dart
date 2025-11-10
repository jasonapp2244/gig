import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gig/utils/responsive.dart';

class Button extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String title;
  final VoidCallback onTap;
  final bool isLoading;
  final IconData? icon;
  final double elevation;
  final double? width;
  final double? height;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final bool expandWidth;
  final MainAxisAlignment contentAlignment;

  const Button({
    super.key,
    required this.color,
    required this.title,
    required this.textColor,
    required this.onTap,
    this.isLoading = false,
    this.icon,
    this.elevation = 6.0,
    this.width,
    this.height,
    this.horizontalPadding = 5,
    this.verticalPadding = 1.2,
    this.borderRadius = 3,
    this.expandWidth = true,
    this.contentAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: height ?? Responsive.height(7, context),
        width: expandWidth ? (width ?? Responsive.width(90, context)) : null,
        constraints: expandWidth
            ? null
            : BoxConstraints(minWidth: Responsive.width(30, context)),
        padding: EdgeInsets.symmetric(
          vertical: Responsive.height(verticalPadding, context),
          horizontal: Responsive.width(horizontalPadding, context),
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            Responsive.width(borderRadius, context),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:  0.15),
              blurRadius: elevation,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: Responsive.width(5, context),
                  height: Responsive.width(5, context),
                  child: CircularProgressIndicator(
                    color: textColor,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: contentAlignment,
                  mainAxisSize: expandWidth
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: textColor,
                        size: Responsive.fontSize(16, context),
                      ),
                      SizedBox(width: Responsive.width(2, context)),
                    ],
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.fontSize(16, context),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
