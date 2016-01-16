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
import 'package:vocal_coach/client/elements/option_toggle/option_toggle.dart';

// create web audio api context
AudioContext audioCtx = new AudioContext();

Map<HtmlElement, Timer> _focusFlashTimers = {};

@PolymerRegister('exercise-playback')
class ExercisePlayback extends PolymerElement {
  ExercisePlayback.created() : super.created() {
    document.onKeyUp.listen((KeyboardEvent event) {
      var flashFocus = (HtmlElement element) {
        if (_focusFlashTimers.containsKey(element)) {
          _focusFlashTimers[element].cancel();
        }
        document.activeElement.blur();
        element.classes.add('focus');
        _focusFlashTimers[element] = new Timer(new Duration(milliseconds: 500), () => element.classes.remove('focus'));
      };

      if (exercise != null) {
        var acted = false;
        switch (event.keyCode) {
          case KeyCode.SPACE:
            if (isPlaying && isContinuous) {
              // Setting _alreadyPlayed to false, so when resuming the exercise it's on the right scale
              _alreadyPlayed = false;
              stop();
            } else playNext();
            flashFocus($['play-next-button']);
            acted = true;
            break;
          case KeyCode.ENTER:
            if (isPlaying && isContinuous) {
              // Setting _alreadyPlayed to false, so when resuming the exercise it's on the right scale
              _alreadyPlayed = false;
              stop();
            } else play();
            flashFocus($['play-button']);
            acted = true;
            break;
          case KeyCode.ESC:
            reset();
            flashFocus($['reset-button']);
            acted = true;
            break;
          case KeyCode.P:
            set('playPreview', !playPreview);
            acted = true;
            break;
          case KeyCode.A:
            set('isAscending', !isAscending);
            acted = true;
            break;
          case KeyCode.C:
            set('isContinuous', !isContinuous);
            acted = true;
            break;
          case KeyCode.DOWN:
            moveDown();
            flashFocus($['move-down-button']);
            acted = true;
            break;
          case KeyCode.UP:
            moveUp();
            flashFocus($['move-up-button']);
            acted = true;
            break;
        }
        if (acted) {
          event.preventDefault();
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

  /// Whether the player automatically plays the next exercise without needing to press space
  @property
  bool isContinuous = false;

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

  /// List of notes that are still scheduled to play
  List<Timer> _scheduledNotes = [];

  @reflectable
  play([_, __]) {
    if (isPlaying) return;
    _alreadyPlayed = true;
    log.info('Playing $exercise');
    set('isPlaying', true);

    var noteDuration = 1 / (int.parse('$bpm') / 60);

    var notes = new List<Note>.from(exercise.notes);

    // TODO: improve this so we simply add a note to the list with double the length
    if (playPreview) {
      var firstNote = notes.first;
      notes.insert(0,
          new Note(degree: firstNote.degree, octaves: firstNote.octaves, accidental: firstNote.accidental, length: 4));
    }

    var getLengthForNotes = (List<Note> notes) => notes.fold(0, (prevValue, note) => prevValue + note.length);
    ;

    notes.asMap().forEach((index, note) {
      var previousLengths = getLengthForNotes(notes.sublist(0, index));
      var noteTime = (previousLengths * noteDuration * 1000).round();
      _scheduledNotes.add(new Timer(new Duration(milliseconds: noteTime), () => _playNote(note)));
    });

    _scheduledNotes
        .add(new Timer(new Duration(milliseconds: (1000 * getLengthForNotes(notes) * noteDuration).round()), () {
      var _isPlaying = isPlaying; // Saving the value, since stop() overwrites it.

      stop();

      if (isContinuous && _isPlaying) {
        // If [isPlaying] is false, it means that the player has been stopped by user action and
        // continuous playback should not be used.
        _scheduledNotes.add(new Timer(new Duration(milliseconds: (noteDuration * 1000 * 3).round()), playNext));
      }
    }));
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
    _scheduledNotes.forEach((timer) => timer.cancel());
    _scheduledNotes = [];
    set('isPlaying', false);
  }

  /// Increase or decrease the scale by a half tone and play
  @reflectable
  playNext([_, __]) {
    if (isPlaying) stop();
    if (_alreadyPlayed) {
      // We don't want to increase / decrease the scale, if it's
      // the first time this exercise is beeing played.
      if (isAscending) {
        moveUp();
      } else {
        moveDown();
      }
    }
    play();
  }

  @reflectable
  togglePlayback([_, __]) {
    isPlaying ? stop() : play();
  }

  /// Increase the scale by a half tone
  @reflectable
  moveUp([_, __]) {
    _alreadyPlayed = false;
    stop();
    set('exerciseInterval', exerciseInterval + 1);
  }

  /// Decrease the scale by a half tone
  @reflectable
  moveDown([_, __]) {
    _alreadyPlayed = false;
    stop();
    set('exerciseInterval', exerciseInterval - 1);
  }

  /// Set to 0
  @reflectable
  reset([_, __]) {
    stop();
    _alreadyPlayed = false;
    set('exerciseInterval', 0);
  }
}
