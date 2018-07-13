const { environment } = require('@rails/webpacker')
const sass = require('./loaders/sass')

environment.loaders.append('sass', sass)

// resolve-url-loader must be used before sass-loader
environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader',
  options: {
    attempts: 1
  }
});

module.exports = environment
