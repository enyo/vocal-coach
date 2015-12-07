@HtmlImport('root_app.html')
library root_app;

import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer/polymer.dart';

import 'elements/exercise_selector/exercise_selector.dart';
import 'elements/exercise_playback/exercise_playback.dart';

import 'package:vocal_coach/client/exercise.dart';

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

  RootApp.created() : super.created();
}
