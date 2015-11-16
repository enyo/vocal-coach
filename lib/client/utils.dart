library vocal_coach.utils;

import 'dart:math' as math;

/// Converts a given interval in cents from A4 to Hz
/// 1200 cents == 1 octave
num centsToHz(int cents, [int a4 = 440]) {
  return double.parse('$a4') * math.pow(2, cents / 1200);
}

var _notes = ['a', 'a#', 'b', 'c', 'c#', 'd', 'd#', 'e', 'f', 'f#', 'g', 'g#'];

/// Returns the name of a note from given interval (which refers to a4)
String noteNameFromInterval(int intervalToA4) {
  var index = intervalToA4 % _notes.length;
  return _notes[index];
}