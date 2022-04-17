<script lang="ts">
  import { Exercise } from '$lib/exercise'
  import { Note } from '$lib/note'

  import { onMount } from 'svelte'

  import * as Tone from 'tone'

  let synth: Tone.Synth | undefined

  let exerciseString = '1 3 5 8 5 3 1'
  let scale = 0
  $: scaleNote = new Note('1').getNote(scale)
  let preview = false

  onMount(() => {
    return () => synth?.dispose()
  })

  const play = () => {
    synth?.dispose()
    synth = new Tone.Synth().toDestination()
    const now = Tone.now()
    const time = Tone.Time('8n').toSeconds()

    Tone.Transport.bpm.setValueAtTime(120, now)

    const exercise = new Exercise('Triad', exerciseString)

    if (preview) {
      synth.triggerAttackRelease(exercise.notes[0].getNote(scale), '8n', now)
    }
    exercise.notes.forEach((note, i) => {
      synth.triggerAttackRelease(
        note.getNote(scale),
        '8n',
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
