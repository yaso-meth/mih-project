import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';

class MihLinuxUpdateInstructions extends StatefulWidget {
  const MihLinuxUpdateInstructions({super.key});

  @override
  State<MihLinuxUpdateInstructions> createState() =>
      _MihLinuxUpdateInstructionsState();
}

class _MihLinuxUpdateInstructionsState
    extends State<MihLinuxUpdateInstructions> {
  Widget _buildInstructionStep(BuildContext context,
      {required String stepNumber,
      required String title,
      required String command}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$stepNumber $title',
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
                      'Update MIH for Linux',
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
                  'Flatpak apps usually update automatically via your system\'s Software Center. To manually force an update via the terminal, use one of the following commands:',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(height: 1.4),
                ),
                const SizedBox(height: 16),

                Text(
                  'Update Instructions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),

                // Command 1
                _buildInstructionStep(
                  context,
                  stepNumber: '•',
                  title: 'Update only the MIH app:',
                  command: 'flatpak update za.co.mzansiinnovationhub.mih',
                ),
                const SizedBox(height: 12),

                // Command 2
                _buildInstructionStep(
                  context,
                  stepNumber: '•',
                  title: 'Update all Flatpak apps on your system:',
                  command: 'flatpak update',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
