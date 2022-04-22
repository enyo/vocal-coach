<script lang="ts">
  import { Exercise } from '$lib/exercise'
  import { Note } from '$lib/note'

  import { onMount } from 'svelte'

  import * as Tone from 'tone'

  let sampler: Tone.Sampler | undefined

  let tempo = 120

  let exerciseString = '1 3 5 8 5 3 1'
  let scale = 0
  $: scaleNote = new Note('1').getNote(scale)
  let preview = false

  $: {
    Tone.Transport.bpm?.setValueAtTime(tempo, Tone.now())
  }

  onMount(() => {
    sampler = new Tone.Sampler({
      urls: {
        A4: 'A4.mp3',
        C4: 'C4.mp3',
        'D#4': 'Ds4.mp3',
        'F#4': 'Fs4.mp3',
      },
      baseUrl: 'https://tonejs.github.io/audio/salamander/',
      onload: () => {
        Tone.Transport.bpm.setValueAtTime(tempo, Tone.now())
        console.log('loaded')
      },
    }).toDestination()
    return () => sampler.dispose()
  })

  const play = () => {
    const now = Tone.now()
    const time = Tone.Time('8n').toSeconds()

    const exercise = new Exercise('Triad', exerciseString)

    if (preview) {
      sampler.triggerAttackRelease(exercise.notes[0].getNote(scale), '4n', now)
    }
    exercise.notes.forEach((note, i) => {
      sampler.triggerAttackRelease(
        note.getNote(scale),
        '4n',
        now + time * (i + (preview ? 2 : 0)),
      )
    })
  }

  const exercises = {
    fifth: '1 5',
    triad: '1 3 5 3 1',
    birdy: '1 5 3 8 5 3 1',
    gamme: '1 3 5 8 5 3 1',
    gu: '8 5 3 1 3 5 8 5 3 1',
  }
</script>

Scale: {scaleNote}
<button on:click={() => (scale = scale + 1)}>+</button>
<button on:click={() => (scale = scale - 1)}>-</button>
Preview: <input type="checkbox" bind:checked={preview} />
<br />

<input type="text" bind:value={exerciseString} />
<button on:click={play}>Play</button>
<button
  on:click={() => {
    scale = scale - 1
    play()
  }}>Previous</button
>

<button
  on:click={() => {
    scale = scale + 1
    play()
  }}>Next</button
>

<br />

{#each Object.keys(exercises) as name}
  <button on:click={() => (exerciseString = exercises[name])}>{name}</button>
{/each}
<!-- <a on:click|preventDefault={}></a> -->
<br />
Tempo:
<input type="text" bind:value={tempo} /> bpm
