import 'package:bars/utilities/exports.dart';

class OnboardingInfoPage extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressed;

  OnboardingInfoPage({
    required this.title,
    required this.content,
    required this.onPressed,
  });

  // Builds the animated circle widget
  Widget _buildAnimatedCircle() {
    return Center(
      child: AnimatedCircle(
        size: 50,
        animateSize: true,
        animateShape: false,
      ),
    );
  }

  // Builds the title with a shake transition
  Widget _buildTitle(BuildContext context) {
    return ShakeTransition(
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  // Builds the content text
  Widget _buildContent(BuildContext context) {
    return Text(
      content,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  // Builds the next button
  Widget _buildNextButton() {
    return Center(
      child: BlueOutlineButton(
        buttonText: 'Next',
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildAnimatedCircle(),
          const SizedBox(height: 50),
          _buildTitle(context),
          const SizedBox(height: 30),
          _buildContent(context),
          const SizedBox(height: 50),
          _buildNextButton(),
        ],
      ),
    );
  }
}


