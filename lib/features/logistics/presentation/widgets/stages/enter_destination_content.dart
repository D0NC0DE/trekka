import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/icon_text_button.dart';
import 'package:trekka/core/widgets/connector/route_connector.dart';
import 'package:trekka/core/widgets/input/location_search_field.dart';

/// Content for the enter destination stage
class EnterDestinationContent extends StatefulWidget {
  const EnterDestinationContent({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  State<EnterDestinationContent> createState() =>
      _EnterDestinationContentState();
}

class _EnterDestinationContentState extends State<EnterDestinationContent> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: Text(
            'Enter a destination',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.mdLg),
      
        IconTextButton(
          text: 'Current location',
          leadingIcon: AppAssetIcons.riderMarker,
          textColor: AppColors.textPrimary50,
          onPressed: null, // Disabled for now
        ),
        const RouteConnector(),
        
        LocationSearchField(
          controller: _controller,
          focusNode: _focusNode,
          hintText: 'Where to go?',
          readOnly: false,
          autofocus: true,
          onChanged: (String value) {
            // TODO: Handle search input
          },
        ),
      ],
    );
  }
}
