import 'package:flutter/material.dart';

import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/screens/start_screen.dart';
import 'package:quiz_app/screens/questions_screen.dart';
import 'package:quiz_app/screens/results_screen.dart';

enum QuizScreen { start, questions, results }

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  List<String> _selectedAnswers = [];
  QuizScreen _activeScreen = QuizScreen.start;

  void _startQuiz() {
    setState(() {
      _activeScreen = QuizScreen.questions;
    });
  }

  void _chooseAnswer(String answer) {
    _selectedAnswers.add(answer);

    if (_selectedAnswers.length == questions.length) {
      setState(() {
        _activeScreen = QuizScreen.results;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _selectedAnswers = [];
      _activeScreen = QuizScreen.questions;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = switch (_activeScreen) {
      QuizScreen.start => StartScreen(onStartQuiz: _startQuiz),
      QuizScreen.questions => QuestionsScreen(onSelectAnswer: _chooseAnswer),
      QuizScreen.results => ResultsScreen(
          chosenAnswers: _selectedAnswers,
          onRestart: _restartQuiz,
        ),
    };

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 78, 13, 151),
                Color.fromARGB(255, 107, 15, 168),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}
