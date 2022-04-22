// import postcssLabFunction from 'postcss-lab-function'
const postcssPresetEnv = require('postcss-preset-env')
const cssnano = require('cssnano')

const mode = process.env.NODE_ENV
const dev = mode === 'development'

module.exports = {
  map: false,
  plugins: [
    postcssPresetEnv({
      stage: 2,
      features: {
        'custom-properties': false,
        'nesting-rules': true,
      },
    }),
    !dev &&
      cssnano({
        preset: 'default',
      }),
  ],
}
