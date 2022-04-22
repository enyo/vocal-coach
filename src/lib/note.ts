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

const _notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']

type Accidental = '#' | 'b'

export class Note {
  /// The degree in the tonic (tonic, dominant, etc...)
  degree: number

  /// How many octaves this degree spans
  octave: number

  accidental: null | Accidental = null

  /// Returns the note in given scale.
  /// The scale is represented as semitons starting at C4 (or c'). So a scale value of
  /// 2 means D1.
  getNote = (scale: number): string => {
    const scaleInterval = this.interval + scale
    const note = _notes[(scaleInterval + 12 * 5) % 12]
    const octave = Math.floor(scaleInterval / 12)
    return `${note}${octave + 4}`
  }

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
