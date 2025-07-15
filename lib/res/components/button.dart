


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
        width: expandWidth
            ? (width ?? Responsive.width(90, context))
            : null,
        constraints: expandWidth
            ? null
            : BoxConstraints(
                minWidth: Responsive.width(30, context),
              ),
        padding: EdgeInsets.symmetric(
          vertical: Responsive.height(verticalPadding, context),
          horizontal: Responsive.width(horizontalPadding, context),
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
              Responsive.width(borderRadius, context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: elevation,
              offset: const Offset(0, 4),
            )
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
              : IntrinsicWidth(
                  child: Row(
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
                        SizedBox(
                            width: Responsive.width(2, context)),
                      ],
                      Flexible(
                        child: Text(
                          title,
                          style: GoogleFonts.poppins(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                Responsive.fontSize(16, context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:gig/utils/responsive.dart';
// import 'package:google_fonts/google_fonts.dart';
// class Button extends StatelessWidget {
//   final Color color;
//   final Color textcColor;
//   final String title;
//   final VoidCallback onTap;
//   final bool isLoading;
//   final IconData? icon;
//   final double elevation;

//   const Button({
//     super.key,
//     required this.color,
//     required this.title,
//     required this.textcColor,
//     required this.onTap,
//     this.isLoading = false,
//     this.icon,
//     this.elevation = 6.0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: isLoading ? null : onTap,
//       child: Container(
//         height: Responsive.hp(context, 7),
//         width: Responsive.wp(context, 90),
//         padding: EdgeInsets.symmetric(
//           vertical: Responsive.hp(context, 1.2),
//           horizontal: Responsive.wp(context, 5),
//         ),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.15),
//               blurRadius: elevation,
//               offset: const Offset(0, 4),
//             )
//           ],
//         ),
//         child: Center(
//           child: isLoading
//               ? SizedBox(
//                   width: Responsive.wp(context, 5),
//                   height: Responsive.wp(context, 5),
//                   child: CircularProgressIndicator(
//                     color: textcColor,
//                     strokeWidth: 2,
//                   ),
//                 )
//               : Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (icon != null) ...[
//                       Icon(icon, color: textcColor, size: Responsive.sp(context, 16)),
//                       SizedBox(width: Responsive.wp(context, 2)),
//                     ],
//                     Text(
//                       title,
//                       style: GoogleFonts.poppins(
//                         color: textcColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: Responsive.sp(context, 16),
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'responsive.dart';

// class Button extends StatelessWidget {
//   final Color color;
//   final Color textcColor;
//   final String title;
//   final VoidCallback onTap;

//   const Button({
//     super.key,
//     required this.color,
//     required this.title,
//     required this.textcColor,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: Responsive.hp(context, 7),  // 7% height
//         width: Responsive.wp(context, 90), // 90% width
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Center(
//           child: Text(
//             title,
//             style: GoogleFonts.poppins(
//               color: textcColor,
//               fontWeight: FontWeight.bold,
//               fontSize: Responsive.sp(context, 14),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // class Button extends StatefulWidget {
// //   Color color;
// //   Color textcColor;
// //   String title;
// //   Button({
// //     super.key,
// //     required this.color,
// //     required this.title,
// //     required this.textcColor,
// //   });

// //   @override
// //   State<Button> createState() => _ButtonState();
// // }

// // class _ButtonState extends State<Button> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: MediaQuery.sizeOf(context).height * 0.07,
// //       width: MediaQuery.sizeOf(context).width * 0.9,
// //       decoration: BoxDecoration(
// //         color: widget.color,
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Center(
// //         child: Text(
// //           widget.title.toString(),
// //           style: GoogleFonts.poppins(
// //             color: widget.textcColor,
// //             fontWeight: FontWeight.bold,
// //             fontSize: 14
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
