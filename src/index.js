'use strict';

require('./index.html');
import './style.css'

var Elm = require('./main.elm');
var embedNode = document.getElementById('wrapper');

var app = Elm.Main.embed(embedNode);