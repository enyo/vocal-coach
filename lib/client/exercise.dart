library vocal_coach.exercise;

import 'dart:html';
import 'dart:svg';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';

/// This defines the semitons for any given scale degree in the diatonic scales
const _semitones = const {
  1: 0, // Tonic
  2: 2, // Supertonic
  3: 4, // Mediant
  4: 5, // Subdominant
  5: 7, // Dominant
  6: 9, // Submediant
  7: 11, // Leading tone
};

var log = new Logger('Exercise');

class Exercise extends JsProxy {
  static var one = new Exercise.fromDegrees('One note', '1');
  static var fifth = new Exercise.fromDegrees('Fifth', '1 5');
  static var triad = new Exercise.fromDegrees('Triad', '1 3 5 3 1');
  static var birdy = new Exercise.fromDegrees('Birdy', '1 5 3 8 5 3 1');
  static var gamme = new Exercise.fromDegrees('Gamme', '1 3 5 8 5 3 1');

  /// Accepts a string of scale degrees and parses that.
  /// Example:
  ///
  ///     new Exercise.fromDegrees('triade', '1 3 5 3 1'); // Major triade
  factory Exercise.fromDegrees(String name, String exercise) {
    if (exercise?.isEmpty ?? true) throw new ArgumentError('No exercise provided');

    try {
      var scaleDegrees = exercise.split(' ');

      var notes = scaleDegrees.map((degreeString) => new Note.fromDegree(degreeString));

      return new Exercise(name, notes.toList(growable: false));
    } catch (e) {
      throw new ArgumentError(e.toString());
    }
  }

  @reflectable
  final String name;

  @reflectable
  final List<Note> notes;

  Exercise(this.name, this.notes) {
    log.finer('Creating exerice "$name" with notes: $notes');
    var svgElement = getImage();
    document.body.append(svgElement);
    svgElement
      ..style.background = '#fefefe'
      ..style.margin = '10px';
  }

  /// Generates an SVG image for this exercise
  SvgElement getImage() {
    var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    var width = 80, height = 44;

    var lineOffset = 10,
        lineDistance = (height - lineOffset * 2) / 4,
        noteOffset = 15,
        noteDistance = notes.length == 1 ? 0 : (width - noteOffset * 2) / (notes.length - 1),
        ellipseWidth = width / 20,
        ellipseHeight = ellipseWidth / 1.5;

    svg.setAttribute('viewPort', '0 0 $width $height');
    svg.setAttribute('width', '$width');
    svg.setAttribute('height', '$height');

    var svgNS = svg.namespaceUri;

    // Draw the lines
    for (var i = 0; i < 5; i++) {
      var lineY = lineOffset + lineDistance * i;
      var line = document.createElementNS(svgNS, 'line');
      line.setAttribute('stroke', 'rgba(0, 0, 0, 0.1)');
      line.setAttribute('stroke-width', '1');
      line.setAttribute('x1', '0');
      line.setAttribute('y1', '$lineY');
      line.setAttribute('x2', '$width');
      line.setAttribute('y2', '$lineY');
      svg.append(line);
    }

    // Draw the notes
    for (var i = 0; i < notes.length; i++) {
      var note = notes[i];
      var noteY = height - (lineOffset + (note.degree + (note.octaves * 7)) * lineDistance / 2),
          noteX = noteOffset + noteDistance * i;
      var ellipse = document.createElementNS(svgNS, 'ellipse');

      ellipse.setAttribute('stroke', 'rgba(0, 0, 0, 1)');
      ellipse.setAttribute('stroke-width', '1');
      ellipse.setAttribute('fill-opacity', '1');
      ellipse.setAttribute('cx', '$noteX');
      ellipse.setAttribute('cy', '$noteY');
      ellipse.setAttribute('rx', '$ellipseWidth');
      ellipse.setAttribute('ry', '$ellipseHeight');
      svg.append(ellipse);
    }

    return svg;
  }

  String toString() => 'Exercise "$name" with ${notes.length} notes';
}

class Note extends JsProxy {
  /// The degree in the tonic (tonic, dominant, etc...)
  @reflectable
  int degree;

  /// How many octaves this degree spans
  @reflectable
  int octaves;

  @reflectable
  Accidental accidental;

  /// The interval from the tonic in semitones.
  @reflectable
  int interval;

  /// The length of the note in quarter notes
  @reflectable
  int length;

  Note.fromDegree(String degreeString, {this.length: 1}) {
    var match = new RegExp(r'^(\d+)(b|\#)?$').firstMatch(degreeString);
    degree = int.parse(match[1]);

    octaves = ((degree - 1) / 7).floor();
    if (octaves > 0) {
      // This exercise includes octaves
      degree -= 7 * octaves;
    }

    if (match[2] != null) {
      accidental = match[2] == 'b' ? Accidental.flat : Accidental.sharp;
    }
    interval = _semitones[degree];

    if (accidental == Accidental.flat) interval -= 1;
    if (accidental == Accidental.sharp) interval += 1;

    // Add the necessary semitones for given octave
    interval += octaves * 12;
  }

  String toString() => 'Note: ${''.padLeft(length, '♩')} $interval semitones';
}

enum Accidental { flat, sharp }
