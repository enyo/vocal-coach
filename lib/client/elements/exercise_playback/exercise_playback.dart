@HtmlImport('exercise_playback.html')
library exercise_playback;

import 'dart:html';
import 'dart:async';
import 'dart:web_audio';

import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

import 'package:vocal_coach/client/exercise.dart';
import 'package:vocal_coach/client/utils.dart';

// create web audio api context
AudioContext audioCtx = new AudioContext();
OscillatorNode oscillator;

@PolymerRegister('exercise-playback')
class ExercisePlayback extends PolymerElement {
  ExercisePlayback.created() : super.created() {
    document.onKeyPress.listen((KeyboardEvent event) {
      if (exercise != null) {
        switch (event.keyCode) {
          case KeyCode.SPACE:
            moveUp();
            play();
            break;
          case KeyCode.ENTER:
            play();
            break;
        }
      }
    });
  }

  var log = new Logger('$ExercisePlayback');

  @property
  Exercise exercise;

  @property
  int a4;

  /// In seconds
  double noteLength = 0.3;

  @Property(computed: 'computeHasExercise(exercise)')
  bool hasExercise = false;

  @reflectable
  bool computeHasExercise([_]) => exercise != null;

  @Observe('exercise')
  onExercise([_]) => reset();

  @property
  bool isPlaying = false;

  /// Defining the semitones relative to a4 to start the exercise from
  @property
  int rootInterval = -12;

  /// The interval defining the current state of the exercise relative to [rootInterval]
  @property
  int exerciseInterval = 0;

  @Property(computed: 'computeExerciseNote(rootInterval, exerciseInterval)')
  String exerciseNote;

  @reflectable
  String computeExerciseNote([_, __]) => noteNameFromInterval(rootInterval + exerciseInterval);

  @reflectable
  play([_, __]) {
    if (isPlaying) return;
    log.info('Playing $exercise');
    set('isPlaying', true);

    oscillator = audioCtx.createOscillator();
    oscillator.connectNode(audioCtx.destination);
//    var gain = audioCtx.createGain();
//    gain.gain.value = 0.0;
//
//    // create Oscillator node
//    oscillator.connectNode(gain);

    oscillator.type = 'sine';
    exercise.notes.asMap().forEach((index, note) {
      oscillator.frequency
          .setValueAtTime(centsToHz((note.interval + rootInterval + exerciseInterval) * 100, a4), audioCtx.currentTime + index * noteLength);
    });
    oscillator.start(audioCtx.currentTime);
    oscillator.stop(audioCtx.currentTime + exercise.notes.length * noteLength);
    new Timer(new Duration(milliseconds: (1000 * exercise.notes.length * noteLength).round()), stop);
  }

  @reflectable
  stop([_, __]) {
    log.info('Stopping $exercise');
    set('isPlaying', false);
  }

  @reflectable
  togglePlayback([_, __]) {
    isPlaying ? stop() : play();
  }

  /// Increase the scale by a half tone
  @reflectable
  moveUp([_, __]) => set('exerciseInterval', exerciseInterval + 1);

  /// Increase the scale by a half tone and play
  @reflectable
  moveUpAndPlay([_, __]) {
    moveUp();
    play();
  }

  /// Decrease the scale by a half tone
  @reflectable
  moveDown([_, __]) => set('exerciseInterval', exerciseInterval - 1);

  /// Set to 0
  @reflectable
  reset([_, __]) => set('exerciseInterval', 0);
}
