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

// console.log('d3 here: ', d3.h);
// console.log('jQuery here: ', $);


// $('document').ready(function() {
//   thing1 = $(".chart").data('thing')
//   d3.select(".chart")
//     .selectAll("div")
//     .data(thing1)
//     .enter().append("div").attr('class', 'bar')
//     .style("width", function(d) { return d * 100 + "px"; })
//     .text(function(d) { return d; });
// });

$('document').ready(function() {
  // thing2 = [{
  //     letter: 'B',
  //     frequency: 10
  //   },
  // {
  //   letter: 'A',
  //   frequency: 5
  // },
  // {
  //   letter: 'F',
  //   frequency: 1
  // }];
  var thing2 = $(".monkeys").data('thong')
  thang1 = $(".sheep").data('thang')
  var margin = {top: 20, right: 20, bottom: 30, left: 40},
  width = 960 - margin.left - margin.right,
  height = 500 - margin.top - margin.bottom;

  var x = d3.scale.ordinal()
  .rangeRoundBands([0, width], .1);

  var y = d3.scale.linear()
  .range([height, 0]);

  var xAxis = d3.svg.axis()
  .scale(x)
  .orient("bottom");

  var yAxis = d3.svg.axis()
  .scale(y)
  .orient("left")
  .ticks(10, "%");

  var svg = d3.select(".monkeys").append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    x.domain(thing2.map(function(d) {
      return d.letter;
    }));

    y.domain([0, d3.max(thing2, function(d) { return d.frequency; })]);

    svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);

    svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6)
    .attr("dy", ".71em")
    .style("text-anchor", "end")
    .text("Frequency");

    svg.selectAll(".bar")
    .data(thing2)
    .enter().append("rect")
    .attr("class", "bar")
    .attr("x", function(d) { return x(d.letter); })
    .attr("width", x.rangeBand())
    .attr("y", function(d) { return y(d.frequency); })
    .attr("height", function(d) { return height - y(d.frequency); });

  function type(d) {
    d.frequency = +d.frequency;
    return d;
  }

 });
