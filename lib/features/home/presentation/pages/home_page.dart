import 'package:flutter/material.dart';

import 'package:trekka/features/home/presentation/widgets/home_bottom_nav.dart';

const _homeBackgroundAssetPath = 'assets/images/home_bg.png';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            _homeBackgroundAssetPath,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: isIOS
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 20, left: 47, right: 47),
                    child: HomeBottomNav(),
                  )
                : const SafeArea(
                    minimum:
                        EdgeInsets.only(bottom: 20, left: 47, right: 47),
                    child: HomeBottomNav(),
                  ),
          ),
        ],
      ),
    );
  }
}
