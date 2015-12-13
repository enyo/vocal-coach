@HtmlImport('root_app.html')
library root_app;

import 'dart:html';

import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer/polymer.dart';

import 'package:vocal_coach/client/exercise.dart';
import 'package:vocal_coach/client/elements/exercise_selector/exercise_selector.dart';
import 'package:vocal_coach/client/elements/exercise_playback/exercise_playback.dart';

/// Using [ExerciseSelector], [ExercisePlayback]
@PolymerRegister('root-app')
class RootApp extends PolymerElement {
  @property String color = 'red';

  @property
  Exercise selectedExercise;

  /// The pitch for A
  /// See https://en.wikipedia.org/wiki/A440_(pitch_standard)
  @property
  int a4 = 440;

  @property
  int bpm = 300;

  @reflectable
  increaseBpm([_, __]) => set('bpm', bpm + 10);

  @reflectable
  decreaseBpm([_, __]) => set('bpm', bpm - 10);

  RootApp.created() : super.created() {
    document.onKeyUp.listen((KeyboardEvent event) {
      switch (event.keyCode) {
        case KeyCode.NUM_PLUS:
          increaseBpm();
          break;
        case KeyCode.NUM_MINUS:
          decreaseBpm();
          break;
      }
    });
  }
}
