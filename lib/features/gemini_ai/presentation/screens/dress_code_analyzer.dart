/// The `DressCodeAnalyzer` widget allows users to select an image of their attire
/// and analyzes its appropriateness for a given event based on dress code and other event details.

import 'package:bars/utilities/exports.dart';

class DressCodeAnalyzer extends StatefulWidget {
  final Event event;

  const DressCodeAnalyzer({required this.event});

  @override
  _DressCodeAnalyzerState createState() => _DressCodeAnalyzerState();
}

class _DressCodeAnalyzerState extends State<DressCodeAnalyzer> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  String _analysisResult = '';
  bool _isLoading = false;
  bool _animationComplete = false;
  bool? _isAppropriate;

  // Builds the app bar for the screen
  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
    );
  }

  // Builds an animated circle widget
  Center _buildAnimatedCircle() {
    return Center(
      child: AnimatedCircle(
        size: 50,
        stroke: 2,
        animateSize: true,
        animateShape: true,
      ),
    );
  }

  // Builds the introductory text for the user
  Text _buildIntroText(UserData _provider) {
    return Text(
      """
Hi ${_provider.user!.userName}, let's select the perfect dress for ${widget.event.title}. The dress code ${widget.event.dressCode.isEmpty ? 'wasn\'t provided by the organizers, but don\'t worry, we\'ll figure something out' : widget.event.dressCode}. Select a picture and let\'s see if it goes with the event. I would use a heart to represent a perfect attire and a thumbs-down to indicate an attire that isn\'t appropriate.
    """,
      style: TextStyle(
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
        color: Colors.white,
      ),
    );
  }

  // Builds the options for image selection
  Widget _buildImageOptions() {
    return ShakeTransition(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildImageOptionButton(
              icon: Icons.dashboard_outlined,
              onPressed: _pickImage,
              text: 'Upload from Gallery',
            ),
            _buildDivider(),
            _buildImageOptionButton(
              icon: MdiIcons.thoughtBubbleOutline,
              onPressed: _takePicture,
              text: 'Take a Picture',
            ),
          ],
        ),
      ),
    );
  }

  // Reusable button widget for image options
  Widget _buildImageOptionButton(
      {required IconData icon,
      required VoidCallback onPressed,
      required String text}) {
    return BottomModelSheetIconActionWidget(
      minor: true,
      dontPop: true,
      icon: icon,
      onPressed: onPressed,
      text: text,
    );
  }

  // Divider widget for separating image options
  Container _buildDivider() {
    return Container(
      width: 1,
      height: 50,
      color: Colors.grey,
    );
  }

  // Builds the analysis result display
  Widget _buildAnalysisResult() {
    if (_analysisResult.isNotEmpty) {
      return _animationComplete
          ? MarkdownBody(
              data: _analysisResult,
              styleSheet: _buildMarkdownStyle(),
            )
          : _buildAnimatedText();
    } else {
      return SizedBox.shrink();
    }
  }

  // Markdown style for displaying analysis results
  MarkdownStyleSheet _buildMarkdownStyle() {
    return MarkdownStyleSheet(
      h1: TextStyle(
          fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
      h2: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 3, 2, 2)),
      p: TextStyle(fontSize: 14.0, color: Colors.white),
      listBullet: TextStyle(fontSize: 12.0, color: Colors.white),
    );
  }

  // Animated text for displaying analysis results
  AnimatedTextKit _buildAnimatedText() {
    return AnimatedTextKit(
      repeatForever: false,
      totalRepeatCount: 1,
      animatedTexts: [
        TyperAnimatedText(
          _analysisResult,
          textStyle: TextStyle(fontSize: 14.0, color: Colors.white),
        ),
      ],
      onFinished: () {
        setState(() {
          _animationComplete = true;
        });
      },
    );
  }

  // Handles the image selection process
  Future<void> _pickImage() async {
    await _selectAndAnalyzeImage(ImageSource.gallery);
  }

  // Handles the picture taking process
  Future<void> _takePicture() async {
    await _selectAndAnalyzeImage(ImageSource.camera);
  }

  // Selects and analyzes the image
  Future<void> _selectAndAnalyzeImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      final croppedFile = await _cropImage(image);
      if (croppedFile != null) {
        setState(() {
          _selectedImage = XFile(croppedFile.path);
          _isLoading = true;
        });
        await _analyzeImage(_selectedImage!);
      }
    }
  }

  // Crops the selected image
  Future<File> _cropImage(XFile imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.5),
    );
    return croppedImage!;
  }

  // Analyzes the image for dress code compliance
  Future<void> _analyzeImage(XFile image) async {
    final bytes = await image.readAsBytes();
    final analysis = await analyzeImageWithGemini(bytes);
    setState(() {
      _isLoading = false;
      _analysisResult = analysis;
      _isAppropriate = analysis.trim().endsWith('true');
    });
  }

  final _googleGenerativeAIService = GoogleGenerativeAIService();

  // Generates a prompt for the AI analysis
  String _buildPrompt() {
    final dressCode = widget.event.dressCode;
    final eventDetails = '''
event title: ${widget.event.title},
event theme: ${widget.event.theme},
event type: ${widget.event.type},
Analyze the event's date: '${MyDateFormat.toDate(widget.event.startDate.toDate())}' and location: '${widget.event.address}'. Based on historical weather data, predict the likely weather conditions and suggest suitable attire.''';

    return dressCode.isEmpty
        ? '''
Analyze the uploaded image to determine if the dress in the image is suitable for this event. 
Consider this additional information about the event:
$eventDetails
If the dress in the image doesn't match, please provide advice on an appropriate attire.
Conclude with either "true" or "false" as the last word indicating suitability.'''
        : '''
Analyze the uploaded image to determine if the dress in the image is suitable for this event's dress code: $dressCode.
Consider this additional information about the event: 
$eventDetails
If the dress in the image doesn't match, please provide advice on an appropriate attire.
Conclude with either "true" or "false" as the last word indicating suitability.''';
  }

  // Calls the AI service to analyze the image
  Future<String> analyzeImageWithGemini(Uint8List imageBytes) async {
    final prompt = _buildPrompt();
    return await _generateResponse(prompt, imageBytes);
  }

  // Generates a response from the AI service
  Future<String> _generateResponse(String prompt, Uint8List image) async {
    try {
      final response = await _googleGenerativeAIService
          .generateResponseWithImage(prompt, image);
      return response ?? 'No response received false';
    } catch (e) {
      print('Error: $e');
      return 'Error occurred: $e false';
    }
  }

  // Displays the selected image or a placeholder icon
  Widget _buildImagePreview() {
    return _selectedImage == null
        ? Icon(Icons.checkroom, size: 100, color: Colors.white)
        : Stack(
            children: [
              Image.file(
                File(_selectedImage!.path),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              if (_isAppropriate != null)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: ShakeTransition(
                      child: Center(
                        child: Icon(
                          _isAppropriate!
                              ? Icons.favorite_rounded
                              : Icons.thumb_down_outlined,
                          color: Colors.white,
                          size: ResponsiveHelper.responsiveHeight(context, 100),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    var _sizedBox = const SizedBox(height: 20);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildAnimatedCircle(),
            _buildIntroText(_provider),
            _sizedBox,
            _buildImageOptions(),
            _sizedBox,
            _isLoading ? LinearProgressIndicator() : SizedBox.shrink(),
            _buildImagePreview(),
            _sizedBox,
            _buildAnalysisResult(),
          ],
        ),
      ),
    );
  }
}
