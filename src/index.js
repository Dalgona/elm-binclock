'use strict';

require('./index.html');
import './style.css'

var Elm = require('./Main.elm');
var embedNode = document.getElementById('wrapper');

var app = Elm.Main.embed(embedNode);