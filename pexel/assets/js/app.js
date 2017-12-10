// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import "jquery"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

const COLOR_PALETTE = [
    0xFFFFFFFF, // white
    0xFFE4E4E4, // light grey
    0xFF888888, // grey
    0xFF222222, // black
    0xFFFFA7D1, // pink
    0xFFE50000, // red
    0xFFE59500, // orange
    0xFFA06A42, // brown
    0xFFE5D900, // yellow
    0xFF94E044, // lime
    0xFF02BE01, // green
    0xFF00D3DD, // cyan
    0xFF0083C7, // blue
    0xFF0000EA, // dark blue
    0xFFCF6EE4, // magenta
    0xFF820080, // purple
]

const apiUrl = window.location.protocol + "//" + window.location.host + "/api"

// import socket from "./socket"
function fillCanvas() {
    var canvasSide = window.canvasSideSize;
    $.getJSON(apiUrl + "/tiles")
    .done(function(jsonRes) {
        var arr32 = new Uint32Array(canvasSide *  canvasSide)
        $.each(jsonRes.data, function(i, elem) {
            arr32[elem.x * canvasSide + elem.y] = COLOR_PALETTE[elem.color]
        });
        var arr = new Uint8ClampedArray(arr32.buffer)
        var c = document.getElementById("main-canvas");
        var ctx = c.getContext("2d");
        ctx.imageSmoothingEnabled = false;
        var imgData = new ImageData(arr, canvasSide, canvasSide)
        ctx.putImageData(imgData, 0, 0);
    });
}

function findPos(canvas, evt) {
    var rect = canvas.getBoundingClientRect(),
        scaleX = canvas.width / rect.width,
        scaleY = canvas.height / rect.height;
    return {
        x: (evt.clientX - rect.left) * scaleX,
        y: (evt.clientY - rect.top) * scaleY
    };
}

function changePixel(x, y, colorIdx) {
    var arr32 = new Uint32Array(1);
    arr32[0] = COLOR_PALETTE[colorIdx];
    var arr = new Uint8ClampedArray(arr32.buffer);
    var imgData = new ImageData(arr, 1, 1);
    var c = document.getElementById("main-canvas");
    var ctx = c.getContext("2d");
    ctx.putImageData(imgData, x, y);
}

$(document).ready(fillCanvas);

$('#main-canvas').click(function(e) {
    var pos = findPos(this, e);
    var x = Math.floor(pos.x);
    var y = Math.floor(pos.y);
    var randIdx = Math.floor(Math.random() * 16);
    var tileObj = {tile: {x: x, y: y, color: randIdx}}
    $.post(apiUrl + "/tiles", tileObj)
        .fail(e => {
            console.warn("Tile update failed: " + JSON.stringify(e));
        })
})


// Channels stuff
socket.connect()

let channel = socket.channel("canvas:updates", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully") })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("new_tile", msg => {
    changePixel(msg.x, msg.y, msg.color);
})
