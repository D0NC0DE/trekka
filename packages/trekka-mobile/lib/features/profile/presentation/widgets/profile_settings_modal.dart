import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/card/gradient_volume_card.dart';
import 'package:trekka/core/widgets/sheet/center_modal_sheet.dart';

/// Settings modal content with interactive audio controls.
class ProfileSettingsModal extends StatefulWidget {
  const ProfileSettingsModal({super.key});

  @override
  State<ProfileSettingsModal> createState() => _ProfileSettingsModalState();
}

class _ProfileSettingsModalState extends State<ProfileSettingsModal> {
  bool _effectsEnabled = true;
  double _effectsLevel = 0.7;
  bool _musicEnabled = true;
  double _musicLevel = 0.5;

  @override
  Widget build(BuildContext context) {
    return CenterModalSheet(
      dismissible: true,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      topButton: Image.asset(AppAssetIcons.settings, width: 24, height: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GradientVolumeCard(
            label: 'hfx Audio',
            icon: Image.asset(AppAssetIcons.volume, width: 20, height: 20),
            isEnabled: _effectsEnabled,
            onToggle: () {
              setState(() {
                _effectsEnabled = !_effectsEnabled;
              });
            },
            value: _effectsLevel,
            onChanged: (double value) {
              setState(() {
                _effectsLevel = value;
              });
            },
          ),
          const SizedBox(height: AppSpacing.smLg),
          GradientVolumeCard(
            label: 'Music',
            icon: Image.asset(AppAssetIcons.music, width: 20, height: 20),
            isEnabled: _musicEnabled,
            onToggle: () {
              setState(() {
                _musicEnabled = !_musicEnabled;
              });
            },
            value: _musicLevel,
            onChanged: (double value) {
              setState(() {
                _musicLevel = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
