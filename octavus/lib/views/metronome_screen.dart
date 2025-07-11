import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MetronomeScreen extends StatefulWidget {
  const MetronomeScreen({super.key});

  @override
  State<MetronomeScreen> createState() => _MetronomeScreenState();
}

class _MetronomeScreenState extends State<MetronomeScreen> {
  double _bpm = 120;
  bool _isPlaying = false;
  Timer? _timer;

  @override
  void dispose() {
    _stopMetronome();
    super.dispose();
  }

  void _startMetronome() {
    final interval = Duration(milliseconds: (60000 / _bpm).round());
    _timer = Timer.periodic(interval, (_) => _playTick());
  }

  void _stopMetronome() {
    _timer?.cancel();
    _timer = null;
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);

    if (_isPlaying) {
      _startMetronome();
    } else {
      _stopMetronome();
    }
  }

  void _onBpmChanged(double value) {
    setState(() => _bpm = value);

    if (_isPlaying) {
      _stopMetronome();
      Future.microtask(() => _startMetronome());
    }
  }

  Future<void> _playTick() async {
    try {
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/tick.mp3'));
    } catch (e) {
      print('Erro ao tocar som: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metrônomo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Ajuste o BPM:', style: TextStyle(fontSize: 16)),
            Slider(
              value: _bpm,
              min: 40,
              max: 240,
              divisions: 200,
              label: _bpm.toInt().toString(),
              onChanged: _onBpmChanged,
            ),
            Text(
              '${_bpm.toInt()} BPM',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                size: 80,
                color: Colors.blueAccent,
              ),
              onPressed: _togglePlay,
            ),
          ],
        ),
      ),
    );
  }
}
