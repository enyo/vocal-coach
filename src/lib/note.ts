/// This defines the semitons for any given scale degree in the diatonic scales
const _semitones = {
  1: 0, // Tonic
  2: 2, // Supertonic
  3: 4, // Mediant
  4: 5, // Subdominant
  5: 7, // Dominant
  6: 9, // Submediant
  7: 11, // Leading tone
}

type Accidental = '#' | 'b'

export class Note {
  /// The degree in the tonic (tonic, dominant, etc...)
  degree: number

  /// How many octaves this degree spans
  octave: number

  accidental: null | Accidental = null

  /// The interval from the tonic in semitones.
  get interval(): number {
    let interval = _semitones[this.degree]

    if (this.accidental === 'b') interval -= 1
    if (this.accidental === '#') interval += 1

    // Add the necessary semitones for given octave
    interval += this.octave * 12
    return interval
  }

  constructor(degreeString: string, readonly length: number = 1) {
    const match = degreeString.match(/^(\d+)(b|#)?$/)

    this.degree = parseInt(match[1], 10)

    this.octave = Math.floor((this.degree - 1) / 7)

    if (this.octave > 0) {
      // This exercise includes octaves
      this.degree -= 7 * this.octave
    }

    if (match[2] != null) {
      this.accidental = match[2] == 'b' ? 'b' : '#'
    }
  }

  toString = (): string =>
    `${this.degree + 7 * this.octave}${this.accidental ?? ''}`
}

if (import.meta.vitest) {
  const { it, expect } = import.meta.vitest
  it('properly parses strings', () => {
    let note = new Note('1')
    expect(note.accidental).toBeNull()
    expect(note.degree).toBe(1)
    expect(note.interval).toBe(0)
    expect(note.octave).toBe(0)

    note = new Note('2')
    expect(note.accidental).toBeNull()
    expect(note.degree).toBe(2)
    expect(note.interval).toBe(2)
    expect(note.octave).toBe(0)

    note = new Note('5')
    expect(note.accidental).toBeNull()
    expect(note.degree).toBe(5)
    expect(note.interval).toBe(7)
    expect(note.octave).toBe(0)

    note = new Note('8')
    expect(note.accidental).toBeNull()
    expect(note.degree).toBe(1)
    expect(note.interval).toBe(12)
    expect(note.octave).toBe(1)

    note = new Note('7#')
    expect(note.accidental).toBe('#')
    expect(note.degree).toBe(7)
    expect(note.interval).toBe(12)
    expect(note.octave).toBe(0)

    note = new Note('4b')
    expect(note.accidental).toBe('b')
    expect(note.degree).toBe(4)
    expect(note.interval).toBe(4)
    expect(note.octave).toBe(0)

    expect(`${new Note('4b')}`).toBe('4b')
    expect(`${new Note('8')}`).toBe('8')
    expect(`${new Note('12#')}`).toBe('12#')
  })
}
