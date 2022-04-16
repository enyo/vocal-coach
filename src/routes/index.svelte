<script lang="ts">
  import { onMount } from 'svelte'

  import * as Tone from 'tone'

  const notes = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ]
  // const
  const melody = [1, 3, 5, 3]
  let synth: Tone.Synth

  onMount(() => {
    synth = new Tone.Synth().toDestination()
    return () => synth.dispose()
  })

  const play = () => {
    const now = Tone.now()
    const time = Tone.Time('8n').toSeconds()

    Tone.Transport.bpm.setValueAtTime(120, now)

    synth.triggerAttackRelease('C#4', '8n')
    synth.triggerAttackRelease('E#4', '8n', now + time)
    synth.triggerAttackRelease('G#4', '8n', now + time * 2)
  }
</script>

<h1>Welcome to SvelteKit</h1>
<p>
  Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation
</p>

<button on:click={play}>Play</button>
