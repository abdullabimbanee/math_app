import 'package:flutter/material.dart';
// Import the Google Generative AI SDK
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:async'; // Required for the image slider Timer
import 'package:url_launcher/url_launcher.dart'; // To open external links (social media, learning links)

// ====================================================================
// 1. APP CONFIGURATION
// ====================================================================

// Enum to manage the current screen state for navigation
enum AppScreen { home, mathBot, mathLearn, mathQuiz, login }

// ====================================================================
// 2. MAIN APPLICATION WIDGET (Stateful to manage screen changes)
// ====================================================================

class MathApp extends StatefulWidget {
  const MathApp({super.key});

  @override
  State<MathApp> createState() => _MathAppState();
}

class _MathAppState extends State<MathApp> {
  // State variable to track the currently displayed page
  AppScreen _currentScreen = AppScreen.home;

  // Method to navigate to a new screen
  void _navigateTo(AppScreen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  // Helper method to build the common app bar for all screens
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Math.App',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
      ),
      backgroundColor: Colors.white,
      elevation: 4,
      automaticallyImplyLeading: false, // Prevents automatic back button
      actions: <Widget>[
        // Navigation Bar Buttons (Right Side)

        // --- HOME BUTTON ---
        _buildNavButton(AppScreen.home, 'Home'),

        _buildNavButton(AppScreen.mathBot, 'Math Bot'),
        _buildNavButton(AppScreen.mathLearn, 'Math Learn'),
        _buildNavButton(AppScreen.mathQuiz, 'Math Quiz'),
        // Login/User Button
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ElevatedButton.icon(
            onPressed: () => _navigateTo(AppScreen.login), // Mock login action
            icon: const Icon(Icons.person, size: 18),
            label: const Text('Login'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method for Navigation Bar Buttons
  Widget _buildNavButton(AppScreen targetScreen, String title) {
    return TextButton(
      onPressed: () => _navigateTo(targetScreen),
      child: Text(
        title,
        style: TextStyle(
          color: _currentScreen == targetScreen
              ? Colors.indigo.shade700
              : Colors.grey.shade700,
          fontWeight: _currentScreen == targetScreen
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
  }

  // Method to return the correct screen widget based on the current state
  Widget _buildScreen() {
    switch (_currentScreen) {
      case AppScreen.home:
        return HomePage(onNavigate: _navigateTo);
      case AppScreen.mathBot:
        return const MathBotPage();
      case AppScreen.mathLearn:
        return const MathLearnPage();
      case AppScreen.mathQuiz:
        return const MathQuizPage();
      case AppScreen.login:
        // Simple placeholder for the login page
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login Page - Authentication Placeholder',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateTo(AppScreen.home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        );
      default:
        return HomePage(onNavigate: _navigateTo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math.App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      home: Scaffold(appBar: _buildAppBar(), body: _buildScreen()),
    );
  }
}

// ====================================================================
// 3. HOME PAGE
// ====================================================================

class HomePage extends StatelessWidget {
  final Function(AppScreen) onNavigate;
  const HomePage({super.key, required this.onNavigate});

  // Helper method to build a feature box/button
  Widget _buildFeatureBox(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    AppScreen targetScreen,
  ) {
    return InkWell(
      onTap: () => onNavigate(targetScreen),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: targetScreen == AppScreen.mathBot
                  ? [Colors.indigo.shade400, Colors.indigo.shade600]
                  : [Colors.grey.shade100, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: targetScreen == AppScreen.mathBot
                    ? Colors.white
                    : Colors.indigo,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: targetScreen == AppScreen.mathBot
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: targetScreen == AppScreen.mathBot
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // 3 Feature Boxes
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              children: <Widget>[
                _buildFeatureBox(
                  context,
                  Icons.smart_toy,
                  'Math Bot',
                  'Ask any math problem and get a solution with great steps easily.',
                  AppScreen.mathBot,
                ),
                _buildFeatureBox(
                  context,
                  Icons.book,
                  'Math Learn',
                  'Access curated lessons and resources to learn maths easily.',
                  AppScreen.mathLearn,
                ),
                _buildFeatureBox(
                  context,
                  Icons.quiz,
                  'Math Quiz',
                  'Solve problems and test your knowledge. Quiz will be updated soon.',
                  AppScreen.mathQuiz,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Image Slider Title (Still needs padding)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Featured Math Tutorials',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Image Slider (Now full width)
          const ImageSlider(),

          const SizedBox(height: 30),

          // Footer
          const Footer(),
        ],
      ),
    );
  }
}

// ====================================================================
// 4. IMAGE SLIDER WIDGET
// ====================================================================

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  // --- UPDATED IMAGE URLs ---
  final List<String> _sliderImages = [
    'https://static.vecteezy.com/system/resources/previews/013/115/385/non_2x/cartoon-maths-elements-background-education-logo-vector.jpg',
    'https://images.squarespace-cdn.com/content/v1/54905286e4b050812345644c/9105b4d8-2044-4f2c-b033-2653b9c188f6/Quote-01.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpTEM9BBScQavANQR2ATcCCyss6WWFx3moYg&s',
    'https://images.squarespace-cdn.com/content/v1/54905286e4b050812345644c/9105b4d8-2044-4f2c-b033-2653b9c188f6/Quote-01.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    // Setup the timer to move the slider every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _sliderImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is removed
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _sliderImages.length,
        itemBuilder: (context, index) {
          // --- MODIFIED: Removed horizontal padding to make the image full-width ---
          return ClipRRect(
            borderRadius: BorderRadius.circular(
              0,
            ), // Set to 0 to be truly full width
            child: Image.network(
              _sliderImages[index],
              // Fit mode set to cover to fill the area and prevent cutting issues
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Text(
                  "Image Load Error",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ====================================================================
// 5. MATH BOT PAGE (Integration with Gemini API and Animations)
// ====================================================================

class MathBotPage extends StatefulWidget {
  const MathBotPage({super.key});

  @override
  State<MathBotPage> createState() => _MathBotPageState();
}

class _MathBotPageState extends State<MathBotPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _solution =
      'Enter a math problem below to get a step-by-step solution!';
  bool _isLoading = false;

  // Animation controllers for the animated typing indicator
  late AnimationController _animationController;

  // State to trigger the solution bubble animation (slide in)
  int _solutionKey = 0;

  // ⚠️ API KEY INTEGRATION POINT ⚠️
  // Key inserted here. (Using gemini-2.5-flash model)
  final String _apiKey = 'AIzaSyCGKPZcL5BSSCWqPzviXR-17mBj0PTZ1fY';

  // Generative Model instance (initialized late)
  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    // Initialize the model instance
    if (_apiKey.isNotEmpty && _apiKey.length > 20) {
      _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
    } else {
      _solution = 'Initialization Error: API Key is missing or invalid.';
    }

    // Initialize animation controller for the typing indicator
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Function to call the Gemini API with retry logic
  Future<void> _solveMathProblem() async {
    final problem = _textController.text.trim();
    if (problem.isEmpty || _apiKey.length < 20) return;

    setState(() {
      _isLoading = true;
      _solution = 'Solving... Please wait for the steps.';
      _solutionKey++; // Increment key to trigger new animation
    });

    try {
      // Scroll to the bottom to see the 'Solving...' message
      Future.delayed(const Duration(milliseconds: 50), () => _scrollToBottom());

      // 1. Crafting the System Prompt
      const systemInstruction =
          "You are a friendly, detailed math tutor. Solve the following problem step-by-step and provide a clear final answer. Use numbered steps and Markdown for good formatting (e.g., **bold** and `code blocks` for math symbols).";

      final fullPrompt = [
        Content.text(systemInstruction),
        Content.text("Problem: $problem"),
      ];

      const maxRetries = 3;
      for (int i = 0; i < maxRetries; i++) {
        try {
          final response = await _model.generateContent(fullPrompt);

          setState(() {
            _solution =
                response.text ??
                'I could not find a solution for that problem. Please try rephrasing.';
          });
          _scrollToBottom();
          return;
        } catch (e) {
          debugPrint('API Request Failed (Attempt ${i + 1}): $e');

          if (i == maxRetries - 1) {
            throw Exception(
              'The math bot failed after $maxRetries attempts. Error details: $e',
            );
          }

          await Future.delayed(
            Duration(seconds: 1 << i),
          ); // Exponential Backoff
        }
      }
    } catch (e) {
      setState(() {
        _solution =
            'An API Error occurred: The model failed to respond. This often means the API key is incorrect or is missing billing permissions. Please check your console for detailed error information, and verify your key in Google AI Studio.';
      });
      _scrollToBottom();
    } finally {
      setState(() {
        _isLoading = false;
      });
      _textController.clear();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Animated Widget for the typing indicator (pulsing dots)
  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.only(left: 18.0, top: 8, bottom: 8),
      alignment: Alignment.topLeft,
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.2,
          end: 1.0,
        ).animate(_animationController),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade700,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // Method to build a styled chat bubble for the response (Bot's reply)
  Widget _buildSolutionBox() {
    // Use an AnimatedBuilder for the slide-in effect
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Slide the new solution in from the left
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      child: Container(
        key: ValueKey<int>(
          _solutionKey,
        ), // Key changes to trigger AnimatedSwitcher
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(18.0),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors
              .indigo
              .shade100, // Colorful: Light Indigo background for bot response
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20), // Asymmetric bubble style
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.shade100.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: SelectableText(
          _solution,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.indigo,
          ), // Text color changed for contrast
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Chat History / Solution Display Area
        Expanded(
          child: Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _buildSolutionBox(),
                  // Animated typing indicator only shown when loading
                  if (_isLoading) _buildTypingIndicator(),
                ],
              ),
            ),
          ),
        ),

        // --- STYLIZED INPUT FIELD ---
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white, // White background for the input bar
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, -2), // Shadow above the input bar
              ),
            ],
          ),
          child: SafeArea(
            // Protects input from system navigation area
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your math problem here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          Colors.indigo.shade50, // Light blue input background
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 15.0,
                      ),
                    ),
                    onSubmitted: (_) => _solveMathProblem(),
                  ),
                ),
                const SizedBox(width: 8),
                // Stylized Send Button
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.indigo.shade700,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _isLoading ? null : _solveMathProblem,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ====================================================================
// 6. MATH LEARN PAGE
// ====================================================================

class MathLearnPage extends StatelessWidget {
  const MathLearnPage({super.key});

  // Data structure for mock learning resources
  final List<Map<String, String>> resources = const [
    {
      'title': 'Beginner Algebra',
      'source': 'YouTube',
      'link':
          'https://www.youtube.com/results?search_query=algebra+basics+tutorial',
      'icon': '▶️',
    },
    {
      'title': 'Advanced Calculus Guide',
      'source': 'GeeksforGeeks',
      'link': 'https://www.geeksforgeeks.org/calculus-tutorial/',
      'icon': '📚',
    },
    {
      'title': 'Trigonometry Deep Dive',
      'source': 'YouTube',
      'link':
          'https://www.youtube.com/results?search_query=trigonometry+full+course',
      'icon': '▶️',
    },
    {
      'title': 'Data Structures in Math',
      'source': 'GeeksforGeeks',
      'link':
          'https://www.geeksforgeeks.org/math-concepts-for-data-structures/',
      'icon': '📚',
    },
  ];

  // Function to open a URL in the browser
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Handle error (e.g., show a snackbar)
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Math Learning Resources',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Explore curated links and videos to deepen your mathematical understanding.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),

          ...resources.map((resource) {
            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Text(
                  resource['icon']!,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(
                  resource['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Source: ${resource['source']}'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.indigo,
                ),
                onTap: () => _launchUrl(resource['link']!),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// ====================================================================
// 7. MATH QUIZ PAGE
// ====================================================================

class MathQuizPage extends StatelessWidget {
  const MathQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 80, color: Colors.orange),
          SizedBox(height: 20),
          Text(
            'Quiz Section Under Construction',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'The math quiz feature will be updated soon. Check back later!',
            style: TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// 8. FOOTER WIDGET
// ====================================================================

class Footer extends StatelessWidget {
  const Footer({super.key});

  // Helper function to launch social media links
  Future<void> _launchSocial(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // --- MODIFIED: Increased vertical padding for a larger footer area ---
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
      color: Colors.indigo.shade50,
      child: Column(
        children: [
          // App and Creator Info
          const Text(
            'Math.App',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Created by Abdulla Bimbanee',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 15),

          // Social Media Buttons (Using basic Icons and Mock URLs)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // GitHub
              IconButton(
                icon: const Icon(Icons.code, color: Colors.black87),
                onPressed: () => _launchSocial(
                  'https://github.com/',
                ), // Replace with your GitHub URL
              ),
              // LinkedIn
              IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Colors.blue,
                ), // Mock LinkedIn icon
                onPressed: () => _launchSocial(
                  'https://linkedin.com/',
                ), // Replace with your LinkedIn URL
              ),
              // Instagram
              IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.pink,
                ), // Mock Instagram icon
                onPressed: () => _launchSocial(
                  'https://instagram.com/',
                ), // Replace with your Instagram URL
              ),
              // X (Twitter)
              IconButton(
                icon: const Icon(
                  Icons.alternate_email,
                  color: Colors.black,
                ), // Mock X icon
                onPressed: () =>
                    _launchSocial('https://x.com/'), // Replace with your X URL
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// 9. Main Function
// ====================================================================

void main() {
  runApp(const MathApp());
}
