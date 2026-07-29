import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';

class MihLinuxInstallInstructions extends StatefulWidget {
  const MihLinuxInstallInstructions({super.key});

  @override
  State<MihLinuxInstallInstructions> createState() =>
      _MihLinuxInstallInstructionsState();
}

class _MihLinuxInstallInstructionsState
    extends State<MihLinuxInstallInstructions> {
  Widget _buildInstructionStep(BuildContext context,
      {required String stepNumber,
      required String title,
      required String command}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$stepNumber. $title',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900], // Dark background for terminal look
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  command,
                  style: const TextStyle(
                    fontFamily: 'Courier', // Monospace font for commands
                    color: Colors.lightGreenAccent,
                    fontSize: 13,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.grey, size: 18),
                onPressed: () {
                  // Clipboard functionality (Requires: import 'package:flutter/services.dart';)
                  Clipboard.setData(ClipboardData(text: command));
                  ScaffoldMessenger.of(context).showSnackBar(
                    MihSnackBar(
                      child: Text('Command copied to clipboard!'),
                    ),
                  );
                },
                tooltip: 'Copy command',
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: null,
      onWindowTapClose: () {
        context.pop();
      },
      windowBody: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: FaIcon(
                    FontAwesomeIcons.linux,
                    color: MihColors.secondary(),
                    size: 125,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get MIH for Linux',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  'Download the official MIH desktop application for Linux. Distributed as a sandboxed Flatpak package, it ensures seamless integration and automatic updates across any Linux distribution.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(height: 1.4),
                ),
                const SizedBox(height: 16),

                // Prerequisite
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Prerequisite: Ensure Flatpak is installed on your machine.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Instructions Header
                Text(
                  'Installation Instructions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),

                // Command 1
                _buildInstructionStep(
                  context,
                  stepNumber: '1',
                  title: 'Add the MIH repository:',
                  command:
                      'flatpak remote-add --if-not-exists mih-fphub https://fphub.mzansi-innovation-hub.co.za/mih-fphub.flatpakrepo',
                ),
                const SizedBox(height: 12),

                // Command 2
                _buildInstructionStep(
                  context,
                  stepNumber: '2',
                  title: 'Install the application:',
                  command:
                      'flatpak install mih-fphub za.co.mzansiinnovationhub.mih',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
