import 'package:flutter/material.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

class ShakingText extends StatefulWidget {
  const ShakingText({super.key});

  @override
  _ShakingTextState createState() => _ShakingTextState();
}

class _ShakingTextState extends State<ShakingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _offsetAnimation = Tween<double>(
      begin: -4.0,
      end: 4.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offsetAnimation.value, 0),
          child: child,
        );
      },
      child: Text("👋", style: TextStyle(fontSize: 22)),
    );
  }
}

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.inputBGColor100,
        foregroundColor: AppColor.whiteColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height * 0.15,
              width: MediaQuery.sizeOf(context).width * 1,
              decoration: BoxDecoration(color: AppColor.inputBGColor100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          " Hello",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            color: AppColor.whiteColor, // Or AppColor.textColor
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6),
                        ShakingText(),
                      ],
                    ),

                    SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          color: AppColor.whiteColor, // Or AppColor.textColor
                          fontWeight: FontWeight.w500,
                        ),
                        text:
                            "Before you create an account , please read our Term & Conditions",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                // height: MediaQuery.sizeOf(context).height * 0.7,
                width: MediaQuery.sizeOf(context).width * 1,
                decoration: BoxDecoration(color: AppColor.whiteColor),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Terms & Conditions",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            color: AppColor.blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "1. Acceptance of Terms",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          text:
                              "By downloading or using this app, you agree to be bound by these Terms and Conditions.",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColor.textColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "2. User Responsibilities",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          text:
                              "You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account.",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColor.textColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "3. Prohibited Activities",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          text: "No spamming, hacking, or unauthorized access.",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColor.textColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "4. Intellectual Property",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          text:
                              "All content, trademarks, logos, and features are owned by [Your Company Name] or licensed to us. You may not copy or use them without permission.",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColor.textColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "5. Subscription & Payments (if applicable)",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          text:
                              "By downloading or using this app, you agree to be bound by these Terms and Conditions.",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColor.textColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "6. Privacy",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          text:
                              "Your privacy is important to us. Please review our [Privacy Policy] for details on how we collect, use, and protect your information.",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColor.textColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "7. Termination",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text:
                              "We reserve the right to suspend or terminate your account at any time for violations of these Terms.",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColor.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
