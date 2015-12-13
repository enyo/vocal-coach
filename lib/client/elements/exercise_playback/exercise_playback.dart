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

@PolymerRegister('exercise-playback')
class ExercisePlayback extends PolymerElement {
  ExercisePlayback.created() : super.created() {
    document.onKeyUp.listen((KeyboardEvent event) {
      if (exercise != null) {
        switch (event.keyCode) {
          case KeyCode.SPACE:
            if (_alreadyPlayed) {
              if (isAscending) {
                moveUp();
              } else {
                moveDown();
              }
            }
            play();
            break;
          case KeyCode.ENTER:
            play();
            break;
          case KeyCode.ESC:
            reset();
            break;
          case KeyCode.P:
            set('playPreview', !playPreview);
            break;
          case KeyCode.A:
            set('isAscending', !isAscending);
            break;
          case KeyCode.DOWN:
            moveDown();
            break;
          case KeyCode.UP:
            moveUp();
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
  @property
  int bpm = 200;

  /// ms for attack
  int attack = 40;

  /// ms for decay
  int decay = 250;

  @property
  bool playPreview = false;

  @Property(computed: 'computeHasExercise(exercise)')
  bool hasExercise = false;

  /// This tracks whether the exercise has already been played
  bool _alreadyPlayed = false;

  @reflectable
  bool computeHasExercise([_]) => exercise != null;

  @Observe('exercise')
  onExercise([_]) => reset();

  @property
  bool isPlaying = false;

  @property
  bool isAscending = true;

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
    _alreadyPlayed = true;
    log.info('Playing $exercise');
    set('isPlaying', true);

    var noteLength = 1 / (int.parse('$bpm') / 60);

    // TODO: improve this so we simply add a note to the list with double the length
    if (playPreview) {
      _playNote(exercise.notes.first);
    }

    exercise.notes.asMap().forEach((index, note) {
      if (playPreview) index += 2;
      var noteTime = (index * noteLength * 1000).round();
      new Timer(new Duration(milliseconds: noteTime), () => _playNote(note));
    });

    new Timer(new Duration(milliseconds: (1000 * exercise.notes.length * noteLength).round()), stop);
  }

  _playNote(Note note) {
    var gain = audioCtx.createGain();
    gain.connectNode(audioCtx.destination);

    // Create envelope
    gain.gain.setValueAtTime(0, audioCtx.currentTime);
    gain.gain.linearRampToValueAtTime(1, audioCtx.currentTime + attack / 1000);
    gain.gain.linearRampToValueAtTime(0, audioCtx.currentTime + decay / 1000);

    var oscillator = audioCtx.createOscillator();
    oscillator.type = 'sine';
    oscillator.frequency.value = centsToHz((note.interval + rootInterval + exerciseInterval) * 100, a4);
    oscillator.connectNode(gain);

    var noteLength = 1 / (int.parse('$bpm') / 60);

    oscillator.start(0);
    new Timer(new Duration(milliseconds: (noteLength * 1000 + decay).round()), () {
      oscillator.stop(0);
      oscillator.disconnect(0);
      gain.disconnect(0);
    });
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
  moveUp([_, __]) {
    _alreadyPlayed = false;
    set('exerciseInterval', exerciseInterval + 1);
  }

  /// Increase the scale by a half tone and play
  @reflectable
  moveUpAndPlay([_, __]) {
    moveUp();
    play();
  }

  /// Decrease the scale by a half tone
  @reflectable
  moveDown([_, __]) {
    _alreadyPlayed = false;
    set('exerciseInterval', exerciseInterval - 1);
  }

  /// Set to 0
  @reflectable
  reset([_, __]) {
    _alreadyPlayed = false;
    set('exerciseInterval', 0);
  }
}
