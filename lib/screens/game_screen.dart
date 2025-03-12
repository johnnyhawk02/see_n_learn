import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/pic_card.dart';
import '../services/game_service.dart';
import '../widgets/pic_card_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final GameService _gameService = GameService();
  List<PicCard> displayCards = [];
  late PicCard dragCard;
  bool isCorrect = false;
  bool showFeedback = false;
  bool isLoading = false; // Add loading state
  
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;
  
  final FocusNode _draggableFocusNode = FocusNode(debugLabel: 'DraggableCard');
  List<FocusNode> _targetFocusNodes = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeGame();
  }

  void _initializeGame() {
    if (!mounted) return;
    
    try {
      displayCards = _gameService.getRandomCards(3);
      dragCard = _gameService.getRandomCardFromList(displayCards);
      
      // Clean up old focus nodes
      for (final node in _targetFocusNodes) {
        if (node.hasListeners) {
          node.dispose();
        }
      }
      
      // Initialize focus nodes for each target
      _targetFocusNodes = List.generate(
        displayCards.length,
        (index) => FocusNode(debugLabel: 'Target${index + 1}'),
      );

      if (mounted) {
        setState(() {
          isCorrect = false;
          showFeedback = false;
        });
      }
    } catch (e) {
      debugPrint('Error initializing game: $e');
      displayCards = [];
      dragCard = _gameService.getRandomCards(1).first;
      _targetFocusNodes = [];
    }
  }

  void _initializeAnimations() {
    if (!mounted) return;
    
    try {
      _controller?.dispose();
      _pulseController?.dispose();
      
      _controller = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      
      _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
      );
      
      _pulseController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );
      
      _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
        CurvedAnimation(parent: _pulseController!, curve: Curves.easeInOut),
      );
      
      _pulseController!.repeat(reverse: true);
    } catch (e) {
      debugPrint('Error initializing animations: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pulseController?.dispose();
    _draggableFocusNode.dispose();
    for (final node in _targetFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    _initializeAnimations();
    _initializeGame();
  }

  void _shuffleCards() {
    if (!mounted) return;
    
    try {
      displayCards = _gameService.getRandomCards(3);
      dragCard = _gameService.getRandomCardFromList(displayCards);
      if (mounted) {
        setState(() {
          isCorrect = false;
          showFeedback = false;
        });
      }
    } catch (e) {
      debugPrint('Error shuffling cards: $e');
    }
  }

  void _handleDragEnd(bool success) {
    if (!mounted) return;
    
    setState(() {
      isCorrect = success;
      showFeedback = true;
      if (success) {
        isLoading = true; // Set loading state when successful
      }
    });

    if (success) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _shuffleCards();
          setState(() {
            isLoading = false; // Reset loading state after new cards are ready
          });
        }
      });
    }
  }

  // Handle keyboard interaction
  void _handleKeyPress(RawKeyEvent event, int index) {
    if (!mounted) return;
    
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space ||
          event.logicalKey == LogicalKeyboardKey.enter) {
        _handleDragEnd(dragCard.name == displayCards[index].name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final cardSize = isLandscape ? size.height * 0.25 : size.width * 0.25;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue[100]!,
                  Colors.purple[50]!,
                ],
              ),
            ),
            child: SafeArea(
              child: FocusScope(
                child: Column(
                  children: [
                    // App Bar
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.school, size: 32, color: Colors.blue),
                          const SizedBox(width: 12),
                          Text(
                            'See & Learn',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    
                    // Top section with target cards
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Center(
                                child: Wrap(
                                  spacing: 32,
                                  runSpacing: 32,
                                  alignment: WrapAlignment.center,
                                  children: displayCards.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final card = entry.value;
                                    return Focus(
                                      focusNode: _targetFocusNodes[index],
                                      onKey: (node, event) {
                                        _handleKeyPress(event, index);
                                        return KeyEventResult.handled;
                                      },
                                      child: DragTarget<PicCard>(
                                        builder: (context, candidateData, rejectedData) {
                                          final isTargeted = candidateData.isNotEmpty;
                                          return AnimatedScale(
                                            scale: isTargeted ? 1.05 : 1.0,
                                            duration: const Duration(milliseconds: 200),
                                            child: PicCardWidget(
                                              card: card,
                                              size: cardSize,
                                            ),
                                          );
                                        },
                                        onWillAccept: (data) => !isLoading, // Prevent drops during loading
                                        onAccept: (data) {
                                          _handleDragEnd(data.name == card.name);
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            // Loading overlay for target cards
                            if (isLoading)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Feedback section
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: showFeedback
                          ? Container(
                              key: ValueKey<bool>(isCorrect),
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Column(
                                children: [
                                  Text(
                                    isCorrect ? 'Great job! 🎉' : 'Try again! 💪',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: isCorrect ? Colors.green[600] : Colors.orange[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (isLoading && isCorrect) ...[
                                    const SizedBox(height: 16),
                                    const CircularProgressIndicator(),
                                  ],
                                ],
                              ),
                            )
                          : const SizedBox(height: 64),
                    ),

                    // Bottom section with draggable card
                    Container(
                      margin: const EdgeInsets.all(24.0),
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.touch_app_outlined, 
                                color: Colors.blue,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tap and drag card',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Focus(
                            focusNode: _draggableFocusNode,
                            child: Stack(
                              children: [
                                Draggable<PicCard>(
                                  data: dragCard,
                                  feedback: Material(
                                    color: Colors.transparent,
                                    child: PicCardWidget(
                                      card: dragCard,
                                      size: cardSize,
                                    ),
                                    elevation: 8.0,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  childWhenDragging: Opacity(
                                    opacity: 0.3,
                                    child: PicCardWidget(
                                      card: dragCard,
                                      size: cardSize,
                                    ),
                                  ),
                                  onDragStarted: () => _controller?.forward(),
                                  onDragEnd: (_) => _controller?.reverse(),
                                  maxSimultaneousDrags: isLoading ? 0 : 1, // Prevent dragging during loading
                                  dragAnchorStrategy: (draggable, context, position) {
                                    return Offset(cardSize / 2, cardSize / 2);
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!isLoading) { // Only allow tapping when not loading
                                        _pulseController?.stop();
                                        _pulseController?.reset();
                                        _pulseController?.repeat(reverse: true);
                                      }
                                    },
                                    child: AnimatedBuilder(
                                      animation: _pulseAnimation!,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _pulseAnimation!.value,
                                          child: PicCardWidget(
                                            card: dragCard,
                                            size: cardSize,
                                            withPulse: !isLoading, // Disable pulse during loading
                                            pulseAnimation: _pulseAnimation!,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                if (isLoading)
                                  Container(
                                    width: cardSize,
                                    height: cardSize + 40, // Account for label height
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(16),
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
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isLoading ? null : _shuffleCards, // Disable shuffle during loading
        backgroundColor: isLoading ? Colors.grey : Colors.blue[600],
        icon: const Icon(Icons.shuffle, color: Colors.white),
        label: const Text(
          'Shuffle',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}