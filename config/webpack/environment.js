const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)
const sassLoader = environment.loaders.get('sass')
sassLoader.use.find(item => item.loader === 'sass-loader').options.implementation = require('sass')


module.exports = environment