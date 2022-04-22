import { expect, it } from 'vitest'
import { Note } from './note'

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
it('translates to note string', () => {
  expect(new Note('1').getNote(0)).toBe('C4')
  expect(new Note('3').getNote(0)).toBe('E4')
  expect(new Note('5').getNote(0)).toBe('G4')
  expect(new Note('5b').getNote(0)).toBe('F#4')
  expect(new Note('4').getNote(0)).toBe('F4')
  expect(new Note('4b').getNote(0)).toBe('E4')
  expect(new Note('8').getNote(0)).toBe('C5')
  expect(new Note('15').getNote(0)).toBe('C6')
  expect(new Note('14').getNote(0)).toBe('B5')
  expect(new Note('14#').getNote(0)).toBe('C6')
  expect(new Note('1').getNote(-12)).toBe('C3')
  expect(new Note('3').getNote(-12)).toBe('E3')
})
