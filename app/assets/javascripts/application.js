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

$('document').ready(function() {

  var raw_mutation_data = $(".mutation_graph").data('thong')
  console.log(raw_mutation_data.length);
  var mutation_number = raw_mutation_data.length
  // if (mutation_number === 0) {
  //   $(".mutation_graph").addClass("graph_hide")
  //   $(".mutation_graph").attr("width", 1200)
  // }
  // else {
  //   $(".mutation_graph").removeClass("graph_hide")
  // }
    variable_with_mulitplier = mutation_number/45;
  if (mutation_number < 20) {
    variable_with_mulitplier = .3;
  }
  else if (mutation_number < 30) {
    variable_with_mulitplier = .5;
  }
  else if (mutation_number < 100) {
    variable_with_mulitplier = 1;
  }
  else if (mutation_number < 200) {
    variable_with_mulitplier = 2;
  }
  else if (mutation_number < 400) {
    variable_with_mulitplier = 3.5;
  }
  else if (mutation_number < 800) {
    variable_with_mulitplier = 5
  }
  else {
    variable_with_mulitplier = 10;
  }
  var margin = {top: 20, right: 20, bottom: 30, left: 40},
  width = 960*variable_with_mulitplier - margin.left - margin.right,
  height = 400 - margin.top - margin.bottom;
  var final_mutation_data = []
  // console.log(raw_mutation_data)
  $(raw_mutation_data).each(function (index, obj) {
    hash = {
           letter: obj.nuc_position1.toString(),
           frequency: obj.mutation_counter
           }
    final_mutation_data.push(hash);
  });
  var thing2 = final_mutation_data

  var x = d3.scale.ordinal()
  .rangeRoundBands([0, width], .1);
  // console.log( "I am x: "+ x);

  var y = d3.scale.linear()
  .range([height, 0]);
  // console.log( "I am y: "+ y);

  var xAxis = d3.svg.axis()
  .scale(x)
  .orient("bottom");

  // console.log( "I am xAxis: "+ xAxis);

  var yAxis = d3.svg.axis()
  .scale(y)
  .orient("left")
  .ticks(10, "");
  // console.log( "I am yAxis: "+ yAxis);

  // var test = d3.svg.axis(thing2.)
  // .scale(d.frequency);
  // console.log(test);
  // // $index( "li" )

  var svg = d3.select(".mutation_graph").append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
// console.log(svg[0][0].attr(".x"));
    x.domain(thing2.map(function(d) {
      return d.letter;
    }));

  // $(".mutation_graph").append("div").attr("class", "chart-header-one").text("HI MARK")

    y.domain([0, d3.max(thing2, function(d) { return (d.frequency/0.8); })]);
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
    .text("Mutation Count");

    svg.selectAll(".bar")
    .data(thing2)
    .enter()
    .append("svg:a")
    // .attr("xlink:href", function(d, i){
    //   return i;
    //  })
    .append("rect")
    .attr("class", "bar")
    .attr("x", function(d, i) { return x(d.letter); })
    .attr("width", x.rangeBand())
    .attr("y", function(d) { return y((d.frequency/0.99)); })
    .attr("height", function(d) { return (height - y(d.frequency/0.99)); })
    .attr("colour",function(d) { if (d.frequency === 1) {return "pinky";} });





  $(".bar").on('click', function(){
    console.log($());
  })
  function type(d) {
    d.frequency = +d.frequency;
    return d;
  }


 });
