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

// import socket from "./socket"
function fillCanvas() {
		var arr32 = new Uint32Array(10000)
    arr32.fill(0xFF00FF00)
		var arr = new Uint8ClampedArray(arr32.buffer)
    var c = document.getElementById("main-canvas");
    var ctx = c.getContext("2d");
    ctx.imageSmoothingEnabled = false;
    var imgData = new ImageData(arr, 100, 100)
    ctx.putImageData(imgData, 0, 0);
}

function findPos(obj) {
    var curleft = 0, curtop = 0;
    if (obj.offsetParent) {
        do {
            curleft += obj.offsetLeft;
            curtop += obj.offsetTop;
        } while (obj = obj.offsetParent);
        return { x: curleft, y: curtop };
    }
    return undefined;
}

function rgbToHex(r, g, b) {
    if (r > 255 || g > 255 || b > 255)
        throw "Invalid color component";
    return ((r << 16) | (g << 8) | b).toString(16);
}

$('#fill-button').click(fillCanvas);

$('#main-canvas').mousemove(function(e) {
    var pos = findPos(this);
    var x = Math.floor((e.pageX - pos.x) / 5);
    var y = Math.floor((e.pageY - pos.y) / 5);
    var coord = "x=" + x + ", y=" + y;
    var c = this.getContext('2d');
    var p = c.getImageData(x, y, 1, 1).data;
    var hex = "#" + ("000000" + rgbToHex(p[0], p[1], p[2])).slice(-6);
    $('#status').html(coord + "<br>" + hex);
});

$('#main-canvas').click(function(e) {
		var pos = findPos(this);
    var x = Math.floor((e.pageX - pos.x) / 5);
    var y = Math.floor((e.pageY - pos.y) / 5);
    var c = document.getElementById("main-canvas");
    var ctx = c.getContext("2d");
    var id = ctx.createImageData(1,1);
    var d  = id.data;
    d[0] = 0xff;
    d[1] = 0x00;
    d[2] = 0x00;
    d[3] = 0xff;
    ctx.putImageData(id, x, y);
})
