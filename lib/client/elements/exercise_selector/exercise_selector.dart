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

  @property
  String newExercise = '';

  @reflectable
  createExercise([_, __]) {
    add('exercises', new Exercise.fromDegrees('User created exercise', newExercise));
    set('newExercise', '');
  }

  @Property(notify: true)
  Exercise selectedExercise;



  @reflectable
  selectExercise(Event event, [_]) {
    exercises.forEach((exercise) => exercise.isSelected = false);
    DomRepeatModel repeatModel = new DomRepeatModel.fromEvent(event);
    Exercise exercise = repeatModel.item;
    exercise.isSelected = true;
    log.fine('Selected $exercise');
    set('selectedExercise', exercise);
  }

}