import 'package:flutter/material.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [_buildBackground(), _buildContent()]),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        const SizedBox(height: 80),
        _buildHacker(),

        const SizedBox(height: 60),
        _buildButtons(),
      ],
    );
  }

  Widget _buildHacker() {
    return GestureDetector(
      onTap: () {
        //aq vai mandar pro faq
        debugPrint('faq');
      },
      child: Image.asset(
        'assets/images/hacker.png',
        width: 180,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStageButton(
              image: 'assets/images/crown_cr.png',
              enabled: true,
              onTap: () {
                //aq manda pra fase 1 (mt fodaaaaa)
                debugPrint('fase 1');
              },
            ),
            const SizedBox(width: 20),
            _buildStageButton(
              image: 'assets/images/unknown_phase.png',
              //vai ter q fazer alguma parada pra fazer isso aq ficar true dps, mas isso eh problema pro futuro
              enabled: false,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStageButton(
              image: 'assets/images/unknown_phase.png',
              enabled: false,
            ),
            const SizedBox(width: 20),
            _buildStageButton(
              image: 'assets/images/unknown_phase.png',
              enabled: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStageButton({
    required String image,
    required bool enabled,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.8,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(child: Image.asset(image, width: 60)),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
