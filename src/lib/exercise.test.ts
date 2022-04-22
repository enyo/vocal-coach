import { expect, it } from 'vitest'
import { Exercise } from './exercise'

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
