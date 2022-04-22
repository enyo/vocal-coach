import { Note } from './note'

export class Exercise {
  constructor(name: string, exercise: string, time?: number)
  constructor(name: string, notes: Note[], time?: number)

  /// Accepts a string of scale degrees and parses that.
  /// Example:
  ///
  ///     new Exercise('triade', '1 3 5 3 1'); // Major triade
  constructor(
    readonly name: string,
    exercise: string | Note[],
    readonly time = 4,
  ) {
    if (exercise instanceof Array) {
      this.notes = exercise
    } else {
      const scaleDegrees = exercise.split(' ')

      this.notes = scaleDegrees.map((degreeString) => new Note(degreeString))
    }
  }

  notes: Note[]

  toString = (): string => `${this.name} ${this.notes.join(' ')}`
}
