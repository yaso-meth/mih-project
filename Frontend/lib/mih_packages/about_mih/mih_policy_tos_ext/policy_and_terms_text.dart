import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class PolicyAndTermsText {
  List<Widget> getPrivacyPolicyText(BuildContext context, bool english) {
    String effectDate = english ? "6 December 2024" : "2024年12月6日";
    String intro = english
        ? "Mzansi Innovation Hub - MIH (\"we,\" \"our,\" \"us\") values your privacy and is committed to protecting your personal data. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our app, Mzansi Innovation Hub - MIH, available globally."
        : "Mzansi Innovation Hub - MIH（“我们”）重视您的隐私，并致力于保护您的个人数据。本隐私政策解释了当您使用我们面向全球推出的应用程序 Mzansi Innovation Hub - MIH 时，我们如何收集、使用、披露和保护您的信息。";
    String infoCollect = english
        ? "We collect the following personal information to provide and improve our services:\n• Personal Details: Name, ID, address, phone number etc.\n• Medical Information: Medical aid details (if applicable).\n• Loyalty Card Information: Loyalty card numbers for the Mzansi Wallet feature."
        : "我们收集以下个人信息以提供和改进我们的服务：\n• 个人详细信息：姓名、身份证、地址、电话号码等。\n• 医疗信息：医疗援助详情（如适用）。\n• 忠诚卡信息：Mzansi Wallet 功能的忠诚卡号码。";
    String useInfo = english
        ? "Your personal information is used for the following purposes:\n• To create and manage your account.\n• To facilitate interactions between clients and businesses.\n• To enable the storage of loyalty card information within the Mzansi Wallet.\n• To provide technical support and improve our app's functionality."
        : "您的个人信息用于以下目的：\n• 创建和管理您的账户。\n• 促进客户与企业之间的互动。\n• 使忠诚卡信息能够存储在 Mzansi Wallet 中。\n• 提供技术支持并改进我们应用程序的功能。";
    String dataShare = english
        ? "We only share your data under the following conditions:\n• With Your Consent: Businesses can access your information only with your explicit permission.\n• Legal Obligations: We may disclose information to comply with applicable laws or regulations."
        : "我们仅在以下情况下共享您的数据：\n• 经您同意：企业只能在您明确许可的情况下访问您的信息。\n• 法律义务：我们可能会披露信息以遵守适用的法律或法规。";
    String dataSec = english
        ? "We implement advanced security measures to protect your personal data:\n• Data encryption during transmission.\n• Secure authentication protocols to prevent unauthorized access.\n• Regular audits to identify and address vulnerabilities."
        : "我们实施先进的安全措施来保护您的个人数据：\n• 传输过程中对数据进行加密。\n• 安全的身份验证协议以防止未经授权的访问。\n• 定期审计以识别和解决漏洞。";

    String yourRights = english
        ? "You have the following rights regarding your personal data:\n• Access and Correction: View and update your information via your account settings.\n• Data Deletion: Request the deletion of your account and associated data.\n• Withdrawal of Consent: Revoke permissions for businesses to access your data is restricted once granted.\n• To exercise these rights, contact us at mzansi.innovation.hub@gmail.com."
        : "您对您的个人数据享有以下权利：\n• 访问和更正：通过您的账户设置查看和更新您的信息。\n• 数据删除：请求删除您的账户及相关数据。\n• 撤回同意：一旦授予权限，撤销企业访问您数据的权限将受到限制。\n• 要行使这些权利，请通过 mzansi.innovation.hub@gmail.com 与我们联系。";
    String dataRet = english
        ? "We retain your personal data for as long as necessary to provide our services. Upon account deletion, your data will be permanently removed unless required by law to retain certain records."
        : "我们会在提供服务所需的时间内保留您的个人数据。账户删除后，您的数据将被永久删除，除非法律要求保留某些记录。";
    String policyChanges = english
        ? "We may update this Privacy Policy to reflect changes in our practices or legal requirements. We will notify you of significant updates via in app notifications and/ or email."
        : "我们可能会更新本隐私政策以反映我们的做法或法律要求的变化。我们将通过应用内通知和/或电子邮件通知您重大更新。";
    String contactUs = english
        ? "If you have questions or concerns about this Privacy Policy, please contact us:\n• Email: mzansi.innovation.hub@gmail.com\n• Phone: +27 655 530 195\n"
        : "如果您对本隐私政策有任何疑问或担忧，请通过以下方式与我们联系：\n• 电子邮件： mzansi.innovation.hub@gmail.com.\n• 电话: +27 655 530 195";
    return [
      SizedBox(
        width: 165,
        child: FittedBox(
          child: Icon(
            MihIcons.mihLogo,
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
        ),
      ),
      const SizedBox(height: 10),
      //=============== Effective Date ===============
      SizedBox(
        width: 1250,
        child: Row(
          children: [
            Text(
              english ? "Effective Date: " : "生效日期: ",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "1. Information We Collect" : "1. 我们收集的信息",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "2. How We Use Your Information" : "2. 我们如何使用您的信息",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "3. Data Sharing" : "3. 数据共享",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "4. Data Security" : "4. 数据安全",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "5. Your Rights" : "5. 您的权利",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "6. Data Retention" : "6. 数据保留",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "7. Changes to This Privacy Policy" : "7. 本隐私政策的变更",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "8. Contact Us" : "8. 联系我们",
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

  List<Widget> getTermsOfServiceText(BuildContext context, bool english) {
    String effectDate = english ? "6 December 2024" : "2024年12月6日";
    String intro = english
        ? "Welcome to Mzansi Innovation Hub (MIH)! These Terms of Service (\"Terms\") govern your access to and use of our application and services (\"Services\"). By accessing or using Mzansi Innovation Hub (MIH), you agree to these Terms."
        : "欢迎使用 Mzansi Innovation Hub (MIH)！本服务条款（“条款”）管理您对我们应用程序和服务（“服务”）的访问和使用。通过访问或使用 Mzansi Innovation Hub (MIH)，您同意这些条款。";
    String acceptTerms = english
        ? "By creating an account or using the app, you agree to be bound by these Terms. If you do not agree, please do not use the Services."
        : "通过创建账户或使用该应用程序，您同意受这些条款的约束。如果您不同意，请不要使用该服务。";
    String eligib = english
        ? "You must be at least 18 years old or the age of majority in your jurisdiction to use this app. By using the app, you represent and warrant that you meet these eligibility requirements."
        : "您必须年满18岁或达到您所在司法管辖区的法定年龄才能使用此应用程序。通过使用该应用程序，您声明并保证您符合这些资格要求。";
    String yourResponse = english
        ? "• Account Security: You are responsible for maintaining the confidentiality of your login credentials.\n• Accurate Information: Ensure that all data you provide is accurate and up to date.\n• Prohibited Uses:\n\t\t• Do not use the app for unlawful purposes.\n\t\t• Do not engage in activities that could harm the app or its users, such as hacking, data scraping, or introducing malware."
        : "• 账户安全：您有责任维护您的登录凭据的机密性。\n• 准确信息：确保您提供的所有数据都是准确和最新的。\n• 禁止使用：\n\t\t• 不得将该应用程序用于非法目的。\n\t\t• 不得从事可能损害该应用程序或其用户的活动，例如黑客攻击、数据抓取或引入恶意软件。";
    String ourServ = english
        ? "• We provide tools to help businesses and clients interact, including a patient manager and the Mzansi Wallet etc.\n• We do not guarantee uninterrupted or error-free services, though we strive to maintain high reliability."
        : "• 我们提供工具来帮助企业和客户互动，包括患者管理器和 Mzansi Wallet 等。\n• 我们不保证服务不中断或无错误，但我们努力保持高可靠性。";

    String dataCol = english
        ? "Your use of the app is subject to our Privacy Policy, which explains how we collect, use, and protect your data. By using the app, you consent to these practices."
        : "您对该应用程序的使用受我们的隐私政策约束，该政策解释了我们如何收集、使用和保护您的数据。通过使用该应用程序，您同意这些做法。";
    String userContent = english
        ? "• Ownership: Any content you submit to the app (e.g., loyalty card data, client profiles) remains your property.\n• License: By using the app, you grant us a non-exclusive license to use your content solely to operate the app and provide services."
        : "• 所有权：您提交到该应用程序的任何内容（例如，忠诚卡数据、客户档案）仍然是您的财产。\n• 许可：通过使用该应用程序，您授予我们非独占许可，仅用于运营该应用程序和提供服务。";
    String intelProp = english
        ? "• All rights to the app, including designs, code, and trademarks, belong to Mzansi Innovation Hub.\n• Users may not copy, distribute, or reverse-engineer any part of the app."
        : "• 该应用程序的所有权利，包括设计、代码和商标，均属于 Mzansi Innovation Hub。\n• 用户不得复制、分发或反向工程该应用程序的任何部分。";
    String termUse = english
        ? "We reserve the right to suspend or terminate your account for violations of these Terms or if required by law."
        : "我们保留因违反这些条款或法律要求而暂停或终止您账户的权利。";
    String disclaimerWarens = english
        ? "The app and services are provided \"as is\" without warranties of any kind, whether express or implied. We do not guarantee that the app will meet your expectations or requirements."
        : "该应用程序和服务按“原样”提供，不附带任何形式的明示或暗示保证。我们不保证该应用程序将满足您的期望或要求。";
    String limitLiability = english
        ? "To the maximum extent permitted by law, we are not liable for:\n• Indirect, incidental, or consequential damages arising from the use or inability to use the app.\n• Loss of data, revenue, or profits."
        : "在法律允许的最大范围内，我们不对以下事项承担责任：\n• 因使用或无法使用该应用程序而产生的间接、附带或后果性损害。\n• 数据、收入或利润的损失。";
    String modifyTerms = english
        ? "We may update these Terms periodically. Continued use of the app after changes are posted constitutes your acceptance of the new Terms."
        : "我们可能会定期更新这些条款。在更改发布后继续使用该应用程序即表示您接受新的条款。";
    String governLaw = english
        ? "These Terms are governed by the laws of South Africa. Any disputes will be resolved in courts located in South Africa."
        : "这些条款受南非法律管辖。任何争议将由位于南非的法院解决。";
    String contactUs = english
        ? "If you have questions about these Terms, please contact us:\n• Email: mzansi.innovation.hub@gmail.com\n• Phone: +27 655 530 195\n"
        : "如果您对这些条款有任何疑问，请通过以下方式与我们联系：\n• 电子邮件： mzansi.innovation.hub@gmail.com.\n• 电话: +27 655 530 195";
    return [
      SizedBox(
        width: 165,
        child: FittedBox(
          child: Icon(
            MihIcons.mihLogo,
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
            Text(
              english ? "Effective Date: " : "生效日期: ",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "1. Acceptance of Terms" : "1. 接受条款",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "2. Eligibility" : "2. 资格",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "3. Your Responsibilities" : "3. 您的责任",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "4. Our Services" : "4. 我们的服务",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "5. Data Collection and Privacy" : "5. 数据收集和隐私",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "6. User-Generated Content" : "6. 用户生成的内容",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "7. Intellectual Property" : "7. 知识产权",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "8. Termination of Use" : "8. 使用终止",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "9. Disclaimer of Warranties" : "9. 免责声明",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "10. Limitation of Liability" : "10. 责任限制",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "11. Modifications to Terms" : "11. 条款修改",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "12. Governing Law" : "12. 适用法律",
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
      SizedBox(
        width: 1250,
        child: Row(
          // crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              english ? "13. Contact Information" : "13. 联系信息",
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
