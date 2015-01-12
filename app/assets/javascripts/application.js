// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require_tree .
function filled_circle(cx, cy, rad)
{
  dc.beginPath();
  dc.arc(cx, cy, rad, 0,2*Math.PI, false);
  dc.fill();
}

refresh(dc, width, height) // Sample code by Jim Bumgardner
{
  dc.clearRect(0,0,width,height);

  dc.fillStyle='#000';
  var nbr_circles = 100;

  var angle_incr = 2 * Math.PI/180;  // 2 degrees, converted to radians

  var cx = width/2;
  var cy = height/2;
  var outer_rad = width*.45;

  var sm_rad = 2;

  for (var i = 1; i <= nbr_circles; ++i) {
    var ratio = i/nbr_circles;
    var angle = i*angle_incr;
    var spiral_rad = ratio * outer_rad;
    var x = cx + Math.cos(angle) * spiral_rad;
    var y = cy + Math.sin(angle) * spiral_rad;

    // draw tiny circle at x,y
    dc.beginPath();
    dc.arc(x, y, sm_rad, 0, 2*Math.PI, false);
    dc.fill();
  }

}
