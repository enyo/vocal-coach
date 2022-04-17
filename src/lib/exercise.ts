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

if (import.meta.vitest) {
  const { it, expect } = import.meta.vitest
  it('properly parses strings', () => {
    let exercise = new Exercise('Triad', '1 3 5 3 1')
    expect(exercise.name).toBe('Triad')
    expect(exercise.notes).toHaveLength(5)
    expect(exercise.notes[0].toString()).toBe('1')
    expect(exercise.notes[1].toString()).toBe('3')
    expect(exercise.notes[2].toString()).toBe('5')
    expect(exercise.notes[3].toString()).toBe('3')
    expect(exercise.notes[4].toString()).toBe('1')
    expect(exercise.toString()).toBe('Triad 1 3 5 3 1')

    exercise = new Exercise('Fifth', '1 5')
    expect(exercise.name).toBe('Fifth')
    expect(exercise.notes).toHaveLength(2)
    expect(exercise.toString()).toBe('Fifth 1 5')

    exercise = new Exercise('Diminished fifth', '1 5b')
    expect(exercise.toString()).toBe('Diminished fifth 1 5b')
  })
}
