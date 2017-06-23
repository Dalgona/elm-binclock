'use strict';

var webpack = require('webpack');
var path = require('path');

module.exports = {
  entry: './src/index.js',

  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist')
  },

  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          'style-loader',
          'css-loader'
        ]
      },
      {
        test: /\.html$/,
        exclude: /node_modules/,
        use: [
          'file-loader?name=[name].[ext]'
        ]
      },
      {
        test: /\.elm$/,
        use: [
          'elm-webpack-loader'
        ]
      },
      {
        test: /\.svg$/,
        use: [
          'file-loader'
        ]
      }
    ],
    noParse: /\.elm$/
  },

  plugins: [
    new webpack.optimize.UglifyJsPlugin()
  ]
};

