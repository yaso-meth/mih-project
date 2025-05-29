import 'package:mzansi_innovation_hub/main.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';

class PolicyAndTermsText {
  List<Widget> getPrivacyPolicyText(BuildContext context) {
    String effectDate = "6 December 2024";
    String intro =
        "Mzansi Innovation Hub - MIH (\"we,\" \"our,\" \"us\") values your privacy and is committed to protecting your personal data. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our app, Mzansi Innovation Hub - MIH, available globally.";
    String infoCollect =
        "We collect the following personal information to provide and improve our services:\n• Personal Details: Name, ID, address, phone number etc.\n• Medical Information: Medical aid details (if applicable).\n• Loyalty Card Information: Loyalty card numbers for the Mzansi Wallet feature.";
    String useInfo =
        "Your personal information is used for the following purposes:\n• To create and manage your account.\n• To facilitate interactions between clients and businesses.\n• To enable the storage of loyalty card information within the Mzansi Wallet.\n• To provide technical support and improve our app's functionality.";
    String dataShare =
        "We only share your data under the following conditions:\n• With Your Consent: Businesses can access your information only with your explicit permission.\n• Legal Obligations: We may disclose information to comply with applicable laws or regulations.";
    String dataSec =
        "We implement advanced security measures to protect your personal data:\n• Data encryption during transmission.\n• Secure authentication protocols to prevent unauthorized access.\n• Regular audits to identify and address vulnerabilities.";

    String yourRights =
        "You have the following rights regarding your personal data:\n• Access and Correction: View and update your information via your account settings.\n• Data Deletion: Request the deletion of your account and associated data.\n• Withdrawal of Consent: Revoke permissions for businesses to access your data is restricted once granted.\n• To exercise these rights, contact us at mzansi.innovation.hub@gmail.com.";
    String dataRet =
        "We retain your personal data for as long as necessary to provide our services. Upon account deletion, your data will be permanently removed unless required by law to retain certain records.";
    String policyChanges =
        "We may update this Privacy Policy to reflect changes in our practices or legal requirements. We will notify you of significant updates via in app notifications and/ or email.";
    String contactUs =
        "If you have questions or concerns about this Privacy Policy, please contact us:\n• Email: mzansi.innovation.hub@gmail.com\n• Phone: +27 655 530 195\n";
    return [
      SizedBox(
        width: 165,
        child: FittedBox(
          child: Icon(
            MihIcons.mihLogo,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
      ),
      const SizedBox(height: 10),
      //=============== Effective Date ===============
      SizedBox(
        width: 1250,
        child: Row(
          children: [
            const Text(
              "Effective Date: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              effectDate,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== Introduction ===============
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              intro,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 1. Information We Collect ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "1. Information We Collect",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              infoCollect,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 2. How We Use Your Information ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "2. How We Use Your Information",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              useInfo,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 3. Data Sharing ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "3. Data Sharing",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              dataShare,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 4. Data Security ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "4. Data Security",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              dataSec,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 5. Your Rights ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "5. Your Rights",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              yourRights,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 6. Data Retention ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "6. Data Retention",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              dataRet,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 7. Changes to This Privacy Policy ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "7. Changes to This Privacy Policy",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              policyChanges,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 8. Contact Us ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "8. Contact Us",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              contactUs,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ];
  }

  List<Widget> getTermsOfServiceText(BuildContext context) {
    String effectDate = "6 December 2024";
    String intro =
        "Welcome to Mzansi Innovation Hub (MIH)! These Terms of Service (\"Terms\") govern your access to and use of our application and services (\"Services\"). By accessing or using Mzansi Innovation Hub (MIH), you agree to these Terms.";
    String acceptTerms =
        "By creating an account or using the app, you agree to be bound by these Terms. If you do not agree, please do not use the Services.";
    String eligib =
        "You must be at least 18 years old or the age of majority in your jurisdiction to use this app. By using the app, you represent and warrant that you meet these eligibility requirements.";
    String yourResponse =
        "• Account Security: You are responsible for maintaining the confidentiality of your login credentials.\n• Accurate Information: Ensure that all data you provide is accurate and up to date.\n• Prohibited Uses:\n\t\t• Do not use the app for unlawful purposes.\n\t\t• Do not engage in activities that could harm the app or its users, such as hacking, data scraping, or introducing malware.";
    String ourServ =
        "• We provide tools to help businesses and clients interact, including a patient manager and the Mzansi Wallet etc.\n• We do not guarantee uninterrupted or error-free services, though we strive to maintain high reliability.";

    String dataCol =
        "Your use of the app is subject to our Privacy Policy, which explains how we collect, use, and protect your data. By using the app, you consent to these practices.";
    String userContent =
        "• Ownership: Any content you submit to the app (e.g., loyalty card data, client profiles) remains your property.\n• License: By using the app, you grant us a non-exclusive license to use your content solely to operate the app and provide services.";
    String intelProp =
        "• All rights to the app, including designs, code, and trademarks, belong to Mzansi Innovation Hub.\n• Users may not copy, distribute, or reverse-engineer any part of the app.";
    String termUse =
        "We reserve the right to suspend or terminate your account for violations of these Terms or if required by law.";
    String disclaimerWarens =
        "The app and services are provided \"as is\" without warranties of any kind, whether express or implied. We do not guarantee that the app will meet your expectations or requirements.";
    String limitLiability =
        "To the maximum extent permitted by law, we are not liable for:\n• Indirect, incidental, or consequential damages arising from the use or inability to use the app.\n• Loss of data, revenue, or profits.";
    String modifyTerms =
        "We may update these Terms periodically. Continued use of the app after changes are posted constitutes your acceptance of the new Terms.";
    String governLaw =
        "These Terms are governed by the laws of South Africa. Any disputes will be resolved in courts located in South Africa.";
    String contactUs =
        "If you have questions about these Terms, please contact us:\n• Email: mzansi.innovation.hub@gmail.com\n• Phone: +27 655 530 195\n";
    return [
      SizedBox(
        width: 165,
        child: FittedBox(
          child: Icon(
            MihIcons.mihLogo,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== Effective Date ===============
      SizedBox(
        width: 1250,
        child: Row(
          children: [
            const Text(
              "Effective Date: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              effectDate,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== Introduction ===============
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              intro,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 1. Acceptance of Terms ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "1. Acceptance of Terms",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              acceptTerms,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 2. Eligibility ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "2. Eligibility",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              eligib,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 3. Your Responsibilities ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "3. Your Responsibilities",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              yourResponse,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 4. Data Security ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "4. Our Services",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              ourServ,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 5. Data Collection and Privacy ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "5. Data Collection and Privacy",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              dataCol,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 6. User-Generated Content ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "6. User-Generated Content",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              userContent,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 7. Intellectual Property ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "7. Intellectual Property",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              intelProp,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 8. Termination of Use ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "8. Termination of Use",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              termUse,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 9. Disclaimer of Warranties ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "9. Disclaimer of Warranties",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              disclaimerWarens,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 10. Limitation of Liability ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "10. Limitation of Liability",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              limitLiability,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 11. Modifications to Terms ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "11. Modifications to Terms",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              modifyTerms,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 12. Governing Law ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "12. Governing Law",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              governLaw,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //=============== 13. Contact Information ===============
      const SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "13. Contact Information",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 1250,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              contactUs,
              textAlign: TextAlign.start,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ];
  }
}
