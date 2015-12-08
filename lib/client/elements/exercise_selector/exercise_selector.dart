@HtmlImport('exercise_selector.html')
library exercise_selector;

import 'dart:html';

import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

import 'package:vocal_coach/client/exercise.dart';

@PolymerRegister('exercise-selector')
class ExerciseSelector extends PolymerElement {
  ExerciseSelector.created() : super.created();

  var log = new Logger('$ExerciseSelector');

  @property
  List<Exercise> exercises = [Exercise.one, Exercise.fifth, Exercise.triad, Exercise.birdy, Exercise.gamme];

  @Property(notify: true)
  Exercise selectedExercise;

  @reflectable
  selectExercise(Event event, [_]) {
    var exercise = new DomRepeatModel.fromEvent(event).item;
    log.fine('Selected $exercise');
    set('selectedExercise', exercise);
  }

}