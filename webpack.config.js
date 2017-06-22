'use strict';

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
        test: /\.(css|scss)$/,
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
      }
    ],
    noParse: /\.elm$/
  }
};

