import 'package:flutter/material.dart';
import 'package:gig/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';
class Button extends StatelessWidget {
  final Color color;
  final Color textcColor;
  final String title;
  final VoidCallback onTap;
  final bool isLoading;
  final IconData? icon;
  final double elevation;

  const Button({
    super.key,
    required this.color,
    required this.title,
    required this.textcColor,
    required this.onTap,
    this.isLoading = false,
    this.icon,
    this.elevation = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: Responsive.hp(context, 7),
        width: Responsive.wp(context, 90),
        padding: EdgeInsets.symmetric(
          vertical: Responsive.hp(context, 1.2),
          horizontal: Responsive.wp(context, 5),
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
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
                  width: Responsive.wp(context, 5),
                  height: Responsive.wp(context, 5),
                  child: CircularProgressIndicator(
                    color: textcColor,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: textcColor, size: Responsive.sp(context, 16)),
                      SizedBox(width: Responsive.wp(context, 2)),
                    ],
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: textcColor,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 16),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}





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
