@HtmlImport('exercise_creator.html')
library exercise_creator;

import 'dart:html';

import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

import 'package:vocal_coach/client/exercise.dart';

/// Fires `new-exercise` when a new exercise has been created.
@PolymerRegister('exercise-creator')
class ExerciseCreator extends PolymerElement {
  ExerciseCreator.created() : super.created();

  var log = new Logger('$ExerciseCreator');

  @property
  String newExercise = '';

  @reflectable
  createExercise([_, __]) {
    fire('new-exercise', detail: newExercise);
    set('newExercise', '');
  }
}
