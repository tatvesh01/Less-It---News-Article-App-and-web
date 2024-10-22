import 'package:google_sign_in/google_sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Ui/policy_screen.dart';
import 'helper.dart';


class Global {

  static double sWidth = 0, sHeight = 0;
  static GoogleSignIn googleSignIn = GoogleSignIn();

  static deviceSize(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
  }

  static showToast(String txt) {
    Fluttertoast.showToast(msg: txt, toastLength: Toast.LENGTH_SHORT,);
  }

  static Widget networkImage(String url, double height,double width){

    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder:  (context, url) => Container(
        height: height,
        width: width,
        color: Helper.lightGreyColor,
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }


 static Widget roundBubble(){
    return Stack(
      children: [
        Opacity(
          opacity: 0.30,
          child: Container(
            width: 200, // Width of the circle
            height: 200, // Height
            decoration: BoxDecoration(
              color: Helper.parrotColor,
              shape: BoxShape.circle, // Makes it a circle
            ),
          ),
        ),
        Opacity(
          opacity: 0.50,
          child: Container(
            width: 200, // Width of the circle
            height: 200, // Height
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 20,color: Helper.parrotColor)
            ),
          ),
        ),
      ],
    );
  }


  static String formatDate(String timestamp) {
    DateTime parsedDateTime = DateTime.parse(timestamp);
    String formattedDate = DateFormat("d MMMM yy HH:mm").format(parsedDateTime);
    return formattedDate;
  }

  static String convertToAgo(String dateTime) {
    DateTime input =
    DateFormat('yyyy-MM-DDTHH:mm:ss.SSSSSSZ').parse(dateTime, true);
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays}d${diff.inDays == 1 ? '' : ''} ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours}h${diff.inHours == 1 ? '' : ''} ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}m${diff.inMinutes == 1 ? '' : ''} ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds}s${diff.inSeconds == 1 ? '' : ''} ago';
    } else {
      return 'just now';
    }
  }

  static void openPage(String name,String type) async{
    Get.to(()=>PolicyScreen(),arguments: [name, type == "pp" ? PPText : TCText]);
  }

  static String TCText = '''1. Acceptance



By using Lessit, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the app.



2. Use of the App



You agree to use the app in accordance with all applicable laws and regulations. You will not use the app for any unlawful or prohibited purpose.



3. Content



The content provided on the app is for informational purposes only and does not constitute professional advice. We are not responsible for the accuracy or completeness of the content.



4. Intellectual Property



The app and its content are protected by copyright and other intellectual property laws. You may not reproduce, modify, distribute, or otherwise use the app or its content without our prior written permission.



5. User-Generated Content



You may be able to submit user-generated content to the app. You grant us a non-exclusive, worldwide, royalty-free license to use, reproduce, modify, adapt, publish, translate, create derivative works from, distribute, and display such content.



6. Disclaimer of Warranties



The app is provided on an "as is" and "as available" basis, without warranties of any kind. We do not warrant that the app will be error-free or uninterrupted.



7. Limitation of Liability



In no event shall we be liable for any indirect, incidental, special, consequential, or exemplary damages, including but not limited to, damages for loss of profits, goodwill, use, data, or other intangible losses, arising out of or in connection with the use of the app.



8. Indemnification



You agree to indemnify and hold us harmless from any claims, liabilities, damages, and expenses arising out of or in connection with your use of the app or your violation of these Terms and Conditions.



9. Governing Law



These Terms and Conditions shall be governed by and construed in accordance with the laws of India.



10. Changes to These Terms and Conditions



We may update these Terms and Conditions from time to time. We will notify you of any significant changes by posting the updated terms on the app.



11. Contact Us



If you have any questions about these Terms and Conditions or our practices, please contact us at:



less.it.app@gmail.com



By using our app, you consent to the terms and conditions set forth herein.''';

  static String PPText = '''
  1. Introduction



This Privacy Policy outlines how Lessit collects, uses, discloses, and protects your personal information when you use our app. We are committed to safeguarding your privacy and ensuring that your personal information is handled securely and responsibly.



2. Information We Collect



When you use our app, we may collect the following types of information:



- Personal Information:
- Name
- Email address
- Phone number
- Location information (if you enable location services)
- Payment information (if you make a purchase through the app)
- Usage Data:
- Information about how you use the app, such as the pages you visit, the features you use, and the time you spend on the app
- Device Information:
- Your device's operating system, model, and unique identifier



3. How We Use Your Information



We may use your information for the following purposes:



- To provide and improve our app and services
- To personalize your experience and show you relevant offers and deals
- To communicate with you about our app, updates, and promotions
- To process your payments and fulfill your orders
- To analyze and understand how our app is used
- To comply with legal requirements



4. Sharing Your Information



We may share your information with:



- Third-party service providers: We may engage third-party service providers to help us operate our app and provide our services. These service providers may have access to your personal information to perform their functions on our behalf.
- Business partners: We may share your information with our business partners to offer you relevant products and services.
- Law enforcement or regulatory authorities: We may disclose your information to law enforcement or regulatory authorities if required by law or to protect our rights or the rights of others.



5. Cookies and Tracking Technologies



We may use cookies and similar tracking technologies to collect information about your use of our app. You can adjust your browser settings to manage your cookie preferences.



6. Data Security



We implement reasonable security measures to protect your personal information from unauthorized access, disclosure, alteration, or destruction. However, no method of transmission over the internet or electronic storage is 100% secure.



7. Your Rights



You may have certain rights regarding your personal information, such as the right to access, correct, or delete your information. Please contact us if you have any questions or requests regarding your rights.



8. Children's Privacy



Our app is not intended for use by children under the age of 13. We do not knowingly collect personal information from children under 13.



9. Changes to This Privacy Policy



We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting the updated policy on our app.



10. Contact Us



If you have any questions about this Privacy Policy or our practices, please contact us at:



less.it.app@gmail.com



By using our app, you consent to the collection and use of your information as described in this Privacy Policy.
  ''';
}
