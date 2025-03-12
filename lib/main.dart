import 'package:flutter/material.dart';
import 'dart:math';
import 'package:collection/collection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'See & Learn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}

class PicCard {
  final String imagePath;
  final String name;

  PicCard({required this.imagePath, required this.name});
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late List<PicCard> allCards;
  late List<PicCard> displayCards;
  late PicCard dragCard;
  bool isCorrect = false;
  bool showFeedback = false;
  
  // Add animation controllers for smooth transitions and feedback
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    // Scale animation for drag feedback
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    // Pulse animation to indicate card is ready to drag
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Make the pulse animation repeat
    _pulseController.repeat(reverse: true);
    
    // Include all available images from assets
    allCards = [
      PicCard(imagePath: 'assets/images/word-images/apple.jpeg', name: 'Apple'),
      PicCard(imagePath: 'assets/images/word-images/baby.jpeg', name: 'Baby'),
      PicCard(imagePath: 'assets/images/word-images/bag.jpeg', name: 'Bag'),
      PicCard(imagePath: 'assets/images/word-images/ball.jpeg', name: 'Ball'),
      PicCard(imagePath: 'assets/images/word-images/banana.jpeg', name: 'Banana'),
      PicCard(imagePath: 'assets/images/word-images/bath.jpeg', name: 'Bath'),
      PicCard(imagePath: 'assets/images/word-images/bear.jpeg', name: 'Bear'),
      PicCard(imagePath: 'assets/images/word-images/bed.jpeg', name: 'Bed'),
      PicCard(imagePath: 'assets/images/word-images/bird.jpeg', name: 'Bird'),
      PicCard(imagePath: 'assets/images/word-images/biscuit.jpeg', name: 'Biscuit'),
      PicCard(imagePath: 'assets/images/word-images/blocks.jpeg', name: 'Blocks'),
      PicCard(imagePath: 'assets/images/word-images/book.jpeg', name: 'Book'),
      PicCard(imagePath: 'assets/images/word-images/brush.jpeg', name: 'Brush'),
      PicCard(imagePath: 'assets/images/word-images/car.jpeg', name: 'Car'),
      PicCard(imagePath: 'assets/images/word-images/cat.jpeg', name: 'Cat'),
      PicCard(imagePath: 'assets/images/word-images/chair.jpeg', name: 'Chair'),
      PicCard(imagePath: 'assets/images/word-images/coat.jpeg', name: 'Coat'),
      PicCard(imagePath: 'assets/images/word-images/cow.jpeg', name: 'Cow'),
      PicCard(imagePath: 'assets/images/word-images/cup.jpeg', name: 'Cup'),
      PicCard(imagePath: 'assets/images/word-images/daddy.jpeg', name: 'Daddy'),
      PicCard(imagePath: 'assets/images/word-images/dog.jpeg', name: 'Dog'),
      PicCard(imagePath: 'assets/images/word-images/doll.jpeg', name: 'Doll'),
      PicCard(imagePath: 'assets/images/word-images/drink.jpeg', name: 'Drink'),
      PicCard(imagePath: 'assets/images/word-images/duck.jpeg', name: 'Duck'),
      PicCard(imagePath: 'assets/images/word-images/eyes.jpeg', name: 'Eyes'),
      PicCard(imagePath: 'assets/images/word-images/fish.jpeg', name: 'Fish'),
      PicCard(imagePath: 'assets/images/word-images/flower.jpeg', name: 'Flower'),
      PicCard(imagePath: 'assets/images/word-images/hair.jpeg', name: 'Hair'),
      PicCard(imagePath: 'assets/images/word-images/hat.jpeg', name: 'Hat'),
      PicCard(imagePath: 'assets/images/word-images/keys.jpeg', name: 'Keys'),
      PicCard(imagePath: 'assets/images/word-images/mouth.jpeg', name: 'Mouth'),
      PicCard(imagePath: 'assets/images/word-images/mummy.jpeg', name: 'Mummy'),
      PicCard(imagePath: 'assets/images/word-images/nose.jpeg', name: 'Nose'),
      PicCard(imagePath: 'assets/images/word-images/phone.jpeg', name: 'Phone'),
      PicCard(imagePath: 'assets/images/word-images/pig.jpeg', name: 'Pig'),
      PicCard(imagePath: 'assets/images/word-images/sheep.jpeg', name: 'Sheep'),
      PicCard(imagePath: 'assets/images/word-images/shoes.jpeg', name: 'Shoes'),
      PicCard(imagePath: 'assets/images/word-images/socks.jpeg', name: 'Socks'),
      PicCard(imagePath: 'assets/images/word-images/spoon.jpeg', name: 'Spoon'),
      PicCard(imagePath: 'assets/images/word-images/table.jpeg', name: 'Table'),
    ];
    _shuffleCards();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _shuffleCards() {
    final random = Random();
    // Randomly choose number of cards (2, 4, or 6)
    final numCards = [2, 4, 6][random.nextInt(3)];
    
    // Shuffle and select cards
    final shuffled = List<PicCard>.from(allCards)..shuffle(random);
    displayCards = shuffled.take(numCards).toList();
    dragCard = displayCards[random.nextInt(displayCards.length)];
    
    setState(() {
      isCorrect = false;
      showFeedback = false;
    });
  }

  void _handleDragEnd(bool success) {
    setState(() {
      isCorrect = success;
      showFeedback = true;
    });

    if (success) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _shuffleCards();
        }
      });
    }
  }

  Widget _buildCard(PicCard card, double size, {bool isDraggable = false, bool withPulse = false}) {
    final cardWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          card.imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );

    // If this card is meant to be dragged, add a visual indicator
    if (withPulse) {
      return Stack(
        children: [
          // The card itself
          cardWidget,
          
          // Animated arrow indicator
          Positioned(
            right: 8,
            top: 8,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value * 0.8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.touch_app,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return cardWidget;
  }

  // Build a deck of cards visual to represent where cards are dealt from
  Widget _buildDeckVisual(double size) {
    return Container(
      width: size + 10,
      height: size + 10,
      child: Stack(
        children: [
          // Multiple card backs stacked to create deck illusion
          for (int i = 3; i >= 0; i--)
            Positioned(
              top: i * 2.0,
              left: i * 2.0,
              child: Container(
                width: size - i * 1.0,
                height: size - i * 1.0,
                decoration: BoxDecoration(
                  color: Colors.blue[50 + i * 50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade200),
                  boxShadow: i == 0 
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : [],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    // Adjust card size to prevent overflow
    final cardSize = isLandscape ? 
      size.height * 0.25 : // Slightly smaller in landscape
      size.width * 0.25;   // Slightly smaller in portrait

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'See & Learn',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top section with target cards
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: Center(
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: displayCards.map((card) {
                            return DragTarget<PicCard>(
                              builder: (context, candidateData, rejectedData) {
                                final isTargeted = candidateData.isNotEmpty;
                                return AnimatedScale(
                                  scale: isTargeted ? 1.05 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: _buildCard(card, cardSize),
                                );
                              },
                              onWillAccept: (data) => true,
                              onAccept: (data) {
                                _handleDragEnd(data.name == card.name);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Feedback section with animated opacity
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: showFeedback
                  ? Container(
                      key: ValueKey<bool>(isCorrect),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        isCorrect ? 'Great job! 🎉' : 'Try again! 💪',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: isCorrect ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox(height: 48),
            ),

            // Bottom section with draggable card and deck
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.touch_app_outlined, 
                          color: Colors.blue,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tap and drag card', // Updated instructions
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Card deck visual
                        _buildDeckVisual(cardSize * 0.8),
                        const SizedBox(width: 20),
                        // Replace LongPressDraggable with Draggable for easier interaction
                        Draggable<PicCard>(
                          data: dragCard,
                          feedback: Material(
                            color: Colors.transparent,
                            child: _buildCard(dragCard, cardSize),
                            elevation: 8.0,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: _buildCard(dragCard, cardSize),
                          ),
                          onDragStarted: () => _controller.forward(),
                          onDragEnd: (_) => _controller.reverse(),
                          // Add drag physics for more natural feel
                          maxSimultaneousDrags: 1,
                          dragAnchorStrategy: (draggable, context, position) {
                            return Offset(cardSize / 2, cardSize / 2);
                          },
                          // Apply a bounce effect when tapped
                          child: GestureDetector(
                            onTap: () {
                              // Add a small bounce animation when tapped
                              _pulseController.stop();
                              _pulseController.reset();
                              _pulseController.repeat(reverse: true);
                            },
                            child: AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: _buildCard(dragCard, cardSize, withPulse: true),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _shuffleCards,
        icon: const Icon(Icons.shuffle),
        label: const Text('Shuffle'),
      ),
    );
  }
}
