import 'package:bars/utilities/exports.dart';

class GeminiOnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final TextEditingController textController;
  final String hintText;
  final String example;
  final VoidCallback onPressed;

  GeminiOnboardingPage({
    required this.title,
    required this.description,
    required this.textController,
    required this.hintText,
    required this.example,
    required this.onPressed,
  });

  // Builds the label style
  TextStyle _buildLabelStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
      color: Colors.blue,
    );
  }

  // Builds the hint style
  TextStyle _buildHintStyle(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
      color: Colors.grey,
    );
  }

  // Builds the save button with animation
  Widget _buildSaveButton(BuildContext context, UserData provider) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        duration: Duration(seconds: 1),
        height: textController.text.trim().isNotEmpty ? 40 : 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: MiniCircularProgressButton(
            color: provider.int1 == 26 ? Colors.blue : Colors.white,
            text: provider.int1 == 26 ? 'Save' : 'Next',
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  // Builds the animated title
  Widget _buildAnimatedTitle(BuildContext context) {
    return ShakeTransition(
      duration: Duration(seconds: 2),
      curve: Curves.easeOutBack,
      child: Row(
        children: [
          AnimatedCircle(
            size: 40,
            stroke: 3,
            animateSize: true,
            animateShape: true,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 700),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builds the description widget
  Widget _buildDescription(BuildContext context) {
    return DirectionWidget(
      sizedBox: 0,
      text: description,
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
    );
  }

  // Builds the text field
  Widget _buildTextField(
    BuildContext context,
  ) {
    return TextField(
      controller: textController,
      style: Theme.of(context).textTheme.bodyLarge,
      maxLines: null,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        hintText: hintText,
        labelStyle: _buildLabelStyle(context),
        hintStyle: _buildHintStyle(context),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Builds the example box
  Widget _buildExampleBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Text(
            'Examples',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Text(
            example,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserData>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSaveButton(context, provider),
            const SizedBox(height: 20),
            _buildAnimatedTitle(context),
            const SizedBox(height: 16),
            _buildDescription(context),
            const SizedBox(height: 40),
            _buildTextField(
              context,
            ),
            const SizedBox(height: 50),
            _buildExampleBox(context),
          ],
        ),
      ),
    );
  }
}

