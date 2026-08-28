import 'package:flutter/material.dart';
import '../models/game_config.dart';
import '../widgets/game_engine.dart';
import '../services/iap_service.dart';

class GameScreen extends StatefulWidget {
  final GameConfig config;
  const GameScreen({super.key, required this.config});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentLevel = 0;
  int _coins = 100;
  final IAPService _iap = IAPService();

  @override
  void initState() {
    super.initState();
    if (widget.config.iapEnabled) {
      _iap.initialize();
      _iap.loadProducts();
    }
  }

  @override
  void dispose() {
    if (widget.config.iapEnabled) _iap.dispose();
    super.dispose();
  }

  void _onLevelComplete(int coinsEarned) {
    setState(() {
      if (widget.config.iapEnabled) _coins += coinsEarned;
      _currentLevel++;
    });
  }

  void _onHintUsed() {
    if (widget.config.iapEnabled && _coins >= 20) {
      setState(() => _coins -= 20);
    }
  }

  void _onSpendCoins(int amount) {
    setState(() { _coins -= amount; });
  }

  void _onPrevLevel() {
    if (_currentLevel > 0) {
      setState(() => _currentLevel--);
    }
  }

  void _onNextLevel() {
    if (_currentLevel < widget.config.levels.length - 1) {
      setState(() => _currentLevel++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameEngine(
        config: widget.config,
        currentLevel: _currentLevel,
        coins: _coins,
        iapEnabled: widget.config.iapEnabled,
        onLevelComplete: _onLevelComplete,
        onHintUsed: _onHintUsed,
        onSpendCoins: _onSpendCoins,
        onNavigatePrev: _currentLevel > 0 ? _onPrevLevel : null,
        onNavigateNext: _currentLevel < widget.config.levels.length - 1 ? _onNextLevel : null,
      ),
    );
  }
}