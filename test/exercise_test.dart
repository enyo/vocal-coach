@TestOn('content-shell || dartium || phantomjs')

import 'package:test/test.dart';

import 'package:logging/logging.dart';
import 'package:vocal_coach/client/exercise.dart';

main() {
  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen(print);

  group('Exercise', () {
    group('.fromDegrees', () {
      test('throws ArgumentError exception when degrees are not correct', () {
        expect(() => new Exercise.fromDegrees('test', ''), throwsA(new isInstanceOf<ArgumentError>()));
        expect(() => new Exercise.fromDegrees('test', 'sdf'), throwsA(new isInstanceOf<ArgumentError>()));
        expect(() => new Exercise.fromDegrees('test', '1bbb 3'), throwsA(new isInstanceOf<ArgumentError>()));
      });
      test('parses simple exercises properly', () {
        var exercise = new Exercise.fromDegrees('test', '1 3 5 7');
        expect(exercise.name, 'test');
        expect(exercise.notes, hasLength(4));
        expect(exercise.notes[0].interval, 0);
        expect(exercise.notes[1].interval, 4);
        expect(exercise.notes[2].interval, 7);
        expect(exercise.notes[3].interval, 11);
      });
      test('properly handles octaves', () {
        var exercise = new Exercise.fromDegrees('test', '1 8 15 10');
        expect(exercise.name, 'test');
        expect(exercise.notes, hasLength(4));
        expect(exercise.notes[0].interval, 0);
        expect(exercise.notes[1].interval, 12);
        expect(exercise.notes[2].interval, 24);
        expect(exercise.notes[3].interval, 16);
      });
      test('properly handles accidents', () {
        var exercise = new Exercise.fromDegrees('test', '1# 8b 7#');
        expect(exercise.name, 'test');
        expect(exercise.notes, hasLength(3));
        expect(exercise.notes[0].interval, 1);
        expect(exercise.notes[1].interval, 11);
        expect(exercise.notes[2].interval, 12);
      });
    });
  });
}