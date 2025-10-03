import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.poppins(
      fontSize: 14,
      color: Colors.black87,
      height: 1.5,
    );

    final headingStyle = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Privacy Policy", style: headingStyle.copyWith(fontSize: 20)),
            const SizedBox(height: 8),
            Text("Effective date: [Insert Date]", style: textStyle),
            const SizedBox(height: 16),
            Text(
              "This Privacy Policy explains what information GIG (“we”, “us”) collects, why we collect it, how we use and share it, and the rights available to users regarding their personal information. This Policy applies to our website, mobile apps, and related services (collectively “Services”).",
              style: textStyle,
            ),

            const SizedBox(height: 24),
            Text("1. Summary of key points", style: headingStyle),
            const SizedBox(height: 8),
            _bullet("Data we collect: account info, contact details, job details (location, employer info, wages), device & usage data, analytics, and optionally payment information.", textStyle),
            _bullet("Why we collect it: to provide and improve the Services, send reminders/notifications, process payments, comply with legal obligations, and for safety/security.", textStyle),
            _bullet("User rights: access, correction, deletion, portability, objection/complaint (GDPR); opt-out of sale/sharing (CCPA/CPRA) where applicable.", textStyle),
            _bullet("Third parties: we share data with service providers, payment processors, analytics vendors, and legal authorities when required.", textStyle),

            const SizedBox(height: 24),
            Text("2. What information we collect", style: headingStyle),
            const SizedBox(height: 8),
            Text("A. Information you provide", style: headingStyle.copyWith(fontSize: 15)),
            _bullet("Account registration: name, email, phone number, password.", textStyle),
            _bullet("Profile: display name, photo (optional).", textStyle),
            _bullet("Job tracking fields: job title/description, employer contact info, job location (address / GPS if enabled), date/time, wages, notes, invoices you upload.", textStyle),
            _bullet("Communications: support requests, feedback, messages to other users (if applicable).", textStyle),

            const SizedBox(height: 12),
            Text("B. Automatically collected information", style: headingStyle.copyWith(fontSize: 15)),
            _bullet("Device identifiers, IP address, device model, operating system, app usage logs, crash reports, analytics events.", textStyle),
            _bullet("Location data if you enable GPS/location services.", textStyle),

            const SizedBox(height: 12),
            Text("C. Payment & billing information", style: headingStyle.copyWith(fontSize: 15)),
            _bullet("Payment tokens, transaction records, billing address (processed by PCI-compliant third-party payment providers).", textStyle),

            const SizedBox(height: 12),
            Text("D. Sensitive data", style: headingStyle.copyWith(fontSize: 15)),
            _bullet("We do not request medical or highly sensitive categories. If processing sensitive categories (e.g., wage/financial details considered sensitive by law), we will request explicit consent where required.", textStyle),

            const SizedBox(height: 24),
            Text("3. How we use your information", style: headingStyle),
            _bullet("Provide, operate, maintain and improve the Services.", textStyle),
            _bullet("Process payments and invoices.", textStyle),
            _bullet("Send transactional messages and reminders (with your consent).", textStyle),
            _bullet("Provide customer support.", textStyle),
            _bullet("Prevent fraud and abuse; secure our Services.", textStyle),
            _bullet("Comply with legal obligations.", textStyle),
            Text(
              "Legal bases (GDPR/EEA users): contract performance, consent (notifications), legitimate interests (security, analytics).",
              style: textStyle,
            ),

            const SizedBox(height: 24),
            Text("4. Sharing and disclosure", style: headingStyle),
            _bullet("Service providers (hosting, analytics, notifications, payment processors).", textStyle),
            _bullet("Business transfers (mergers, acquisitions).", textStyle),
            _bullet("Legal requirements (court orders, authorities).", textStyle),
            _bullet("With your consent (if you share job info externally).", textStyle),

            const SizedBox(height: 24),
            Text("5. Data retention", style: headingStyle),
            Text(
              "Account data is typically retained up to 3 years after account deletion. Transaction/billing records are retained up to 7 years as required by law.",
              style: textStyle,
            ),

            const SizedBox(height: 24),
            Text("6. Data security", style: headingStyle),
            Text(
              "We use administrative, technical, and physical safeguards to protect your data. No internet transmission is 100% secure; absolute security cannot be guaranteed.",
              style: textStyle,
            ),

            const SizedBox(height: 24),
            Text("7. Your rights and choices", style: headingStyle),
            _bullet("Access & portability of your data.", textStyle),
            _bullet("Correction of inaccurate data.", textStyle),
            _bullet("Deletion (with legal exceptions).", textStyle),
            _bullet("Restriction or objection to processing.", textStyle),
            _bullet("Opt-out of sale/sharing (California residents).", textStyle),
            Text(
              "Contact us at privacy@gig.com with 'Privacy Request' in the subject. We will verify your identity before fulfilling requests.",
              style: textStyle,
            ),

            const SizedBox(height: 24),
            Text("8. International transfers", style: headingStyle),
            Text(
              "Data may be stored or processed in other countries. Safeguards such as Standard Contractual Clauses apply where required.",
              style: textStyle,
            ),

            const SizedBox(height: 24),
            Text("9. Children’s privacy", style: headingStyle),
            Text(
              "We do not knowingly collect data from children under 13. If collected unintentionally, it will be deleted.",
              style: textStyle,
            ),

            const SizedBox(height: 24),
            Text("10. Third-party links & services", style: headingStyle),
            Text(
              "Our Services may link to third-party tools (maps, payments, analytics). Their privacy policies apply separately.",
              style: textStyle,
            ),

            const SizedBox(height: 24),
            Text("11. Google Play / App Store notices", style: headingStyle),
            Text(
              "We comply with platform-specific data-safety requirements. Disclosures must match this Policy.",
              style: textStyle,
            ),

            const SizedBox(height: 24),
            Text("12. Changes to this Policy", style: headingStyle),
            Text(
              "We may update this Policy. If changes are material, we will notify you via email or in-app.",
              style: textStyle,
            ),

            const SizedBox(height: 24),
            Text("13. Contact & complaints", style: headingStyle),
            Text(
              "Data Controller: GIG\nEmail: privacy@gig.com\nAddress: [Insert business address]",
              style: textStyle,
            ),
            Text(
              "EU residents: contact your local supervisory authority. California residents: may contact the California Attorney General or CPPA.",
              style: textStyle,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _bullet(String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: style)),
        ],
      ),
    );
  }
}































// import 'package:flutter/material.dart';
// import 'package:gig/res/colors/app_color.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ShakingText extends StatefulWidget {
//   const ShakingText({super.key});

//   @override
//   _ShakingTextState createState() => _ShakingTextState();
// }

// class _ShakingTextState extends State<ShakingText>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _offsetAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     )..repeat(reverse: true);

//     _offsetAnimation = Tween<double>(
//       begin: -4.0,
//       end: 4.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _offsetAnimation,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(_offsetAnimation.value, 0),
//           child: child,
//         );
//       },
//       child: Text("👋", style: TextStyle(fontSize: 22)),
//     );
//   }
// }

// class PrivacyPolicy extends StatefulWidget {
//   const PrivacyPolicy({super.key});

//   @override
//   State<PrivacyPolicy> createState() => _PrivacyPolicyState();
// }

// class _PrivacyPolicyState extends State<PrivacyPolicy> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColor.inputBGColor100,
//         foregroundColor: AppColor.whiteColor,
//       ),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Container(
//               height: MediaQuery.sizeOf(context).height * 0.15,
//               width: MediaQuery.sizeOf(context).width * 1,
//               decoration: BoxDecoration(color: AppColor.inputBGColor100),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           " Hello",
//                           style: GoogleFonts.poppins(
//                             fontSize: 22,
//                             color: AppColor.whiteColor, // Or AppColor.textColor
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(width: 6),
//                         ShakingText(),
//                       ],
//                     ),

//                     SizedBox(height: 5),
//                     RichText(
//                       text: TextSpan(
//                         style: GoogleFonts.poppins(
//                           color: AppColor.whiteColor, // Or AppColor.textColor
//                           fontWeight: FontWeight.w500,
//                         ),
//                         text:
//                             "Before you create an account , please read our Term & Conditions",
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 // height: MediaQuery.sizeOf(context).height * 0.7,
//                 width: MediaQuery.sizeOf(context).width * 1,
//                 decoration: BoxDecoration(color: AppColor.whiteColor),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       RichText(
//                         text: TextSpan(
//                           text: "Privacy Policy ",
//                           style: GoogleFonts.poppins(
//                             fontSize: 22,
//                             color: AppColor.blackColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         "Effective date: ",
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           color: AppColor.blackColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       RichText(
//                         text: TextSpan(
//                           text:
//                               "This Privacy Policy explains what information GIG (“we”, “us”) collects, why we collect it, how we use and share it, and the rights available to users regarding their personal information. This Policy applies to our website, mobile apps, and related services (collectively “Services”).",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: AppColor.textColor,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       SizedBox(height: 8),
//                       Text(
//                         "1. Summary of key points",
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           color: AppColor.blackColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       RichText(
//                         text: TextSpan(
//                           text:
//                               "● Data we collect: account info, contact details, job details (location, employer info, wages), device & usage data, analytics, and optionally payment information.\n\n"
//                               "● Why we collect it: to provide and improve the Services, send reminders/notifications, process payments, comply with legal obligations, and for safety/security.\n\n"
//                               "● User rights: access, correction, deletion, portability, objection/complaint (GDPR); opt-out of sale/sharing (CCPA/CPRA) where applicable.\n\n"
//                               "● Third parties: we share data with service providers, payment processors, analytics vendors, and legal authorities when required.",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: AppColor.textColor,
//                           ),
//                         ),
//                       ),

//                       SizedBox(height: 8),
//                       Text(
//                         "2. What information we collect",
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           color: AppColor.blackColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         "We collect the following categories of information:",
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           color: AppColor.blackColor,
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         "A. Information you provide",
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           color: AppColor.blackColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       RichText(
//                         text: TextSpan(
//                           text:
//                               "● Account registration: name, email, phone number, password.\n\n"
//                               "● Profile: display name, photo (optional).\n\n"
//                               "● Job tracking fields: job title/description, employer contact info, location of job (address / GPS if you allow location), date/time, wages, notes, invoices you upload.\n\n"
//                               "● Communications: support requests, feedback, messages to other users (if applicable).",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: AppColor.textColor,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         "B. Automatically collected information",
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           color: AppColor.blackColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       RichText(
//                         text: TextSpan(
//                           text:
//                               "● Device identifiers, IP address, device model, operating system, app usage logs, crash reports, analytics events.\n\n"
//                               "● Location data if you enable GPS/location services (for job location and mapping features).\n\n",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: AppColor.textColor,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         "C. Payment & billing information",
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           color: AppColor.blackColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       RichText(
//                         text: TextSpan(
//                           text:
//                               "●	If you use paid features, we may collect payment tokens, transaction records, billing address (payments processed via PCI-compliant third parties).\n\n",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: AppColor.textColor,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         "D. Sensitive data",
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           color: AppColor.blackColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       RichText(
//                         text: TextSpan(
//                           text:
//                               "●	We do not ask for medical or highly sensitive categories. If we process sensitive categories (e.g., certain wage/financial details that laws treat as sensitive), we will request explicit consent where required.\n\n",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: AppColor.textColor,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         "3. How we use your information",
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           color: AppColor.blackColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       RichText(
//                         text: TextSpan(
//                           text:
//                               "●	Provide, operate, maintain and improve the Services (account management, task tracking, reminders).\n\n"
//                               "●	Process payments and invoices.\n\n"
//                               "●	Send transactional messages and reminders you opt in to receive.\n\n"
//                               "●	Provide customer support.\n\n"
//                               "●	Comply with legal obligations.\n\n"
//                               "●	Prevent fraud and abuse; secure our Services.\n\n",

//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: AppColor.textColor,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         "4. Intellectual Property",
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           color: AppColor.blackColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       RichText(
//                         text: TextSpan(
//                           text:
//                               "All content, trademarks, logos, and features are owned by [Your Company Name] or licensed to us. You may not copy or use them without permission.",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: AppColor.textColor,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         "5. Subscription & Payments (if applicable)",
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           color: AppColor.blackColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       RichText(
//                         text: TextSpan(
//                           text:
//                               "By downloading or using this app, you agree to be bound by these Terms and Conditions.",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: AppColor.textColor,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         "6. Privacy",
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           color: AppColor.blackColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       RichText(
//                         text: TextSpan(
//                           text:
//                               "Your privacy is important to us. Please review our [Privacy Policy] for details on how we collect, use, and protect your information.",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: AppColor.textColor,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         "7. Termination",
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           color: AppColor.blackColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       RichText(
//                         text: TextSpan(
//                           text:
//                               "We reserve the right to suspend or terminate your account at any time for violations of these Terms.",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: AppColor.textColor,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
