import adapter from '@sveltejs/adapter-auto'
import preprocess from 'svelte-preprocess'
import Icons from 'unplugin-icons/vite'

/** @type {import('@sveltejs/kit').Config} */
const config = {
  // Consult https://github.com/sveltejs/svelte-preprocess
  // for more information about preprocessors
  preprocess: [
    preprocess({
      postcss: true,
    }),
  ],

  kit: {
    adapter: adapter(),
    vite: {
      build: {
        target: ['es2020'],
      },
      plugins: [
        Icons({
          compiler: 'svelte',
        }),
      ],
      define: {
        'import.meta.vitest': 'undefined',
      },
      test: {},
    },
  },
}

export default config
