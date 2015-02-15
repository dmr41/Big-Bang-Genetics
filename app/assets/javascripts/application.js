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
  var mutation_number = raw_mutation_data.length
  var variable_with_mulitplier = mutation_number/45;

  if (mutation_number === 1) {
      variable_with_mulitplier = .3;
  }
  else if (mutation_number < 3) {
      variable_with_mulitplier = .4;
  }
  else if (mutation_number < 10) {
    variable_with_mulitplier = 0.5;
  }
  else if (mutation_number < 20) {
    variable_with_mulitplier = .7;
  }
  else if (mutation_number < 30) {
    variable_with_mulitplier = 1.8;
  }
  else if (mutation_number < 40) {
    variable_with_mulitplier = 2;
  }
  else if (mutation_number < 50) {
    variable_with_mulitplier = 2.3;
  }
  else if (mutation_number < 60) {
    variable_with_mulitplier = 2.5;
  }
  else if (mutation_number < 70) {
    variable_with_mulitplier = 2.8;
  }
  else if (mutation_number < 80) {
    variable_with_mulitplier = 3;
  }
  else if (mutation_number < 100) {
    variable_with_mulitplier = 4.4;
  }
  else if (mutation_number < 200) {
    variable_with_mulitplier = 8;
  }
  else if (mutation_number < 250) {
    variable_with_mulitplier = 10;
  }
  else if (mutation_number < 300) {
    variable_with_mulitplier = 13;
  }
  else if (mutation_number < 400) {
    variable_with_mulitplier = 16;
  }
  else if (mutation_number < 500) {
    variable_with_mulitplier = 18;
  }
  else if (mutation_number < 800) {
    variable_with_mulitplier = 24;
  }
  else if (mutation_number < 1000) {
    variable_with_mulitplier = 26;
  }
  else if (mutation_number < 1200) {
    variable_with_mulitplier = 28;
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
           frequency: obj.mutation_counter,
           mutation_type: obj.ins_del_single,
           mutation_from: obj.nuc_change_from,
           mutation_to: obj.nuc_change_to,
           mutation_count: obj.mutation_counter
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
    x.domain(thing2.map(function(d, i) {
      return d.letter;
    }));


  // $(".mutation_graph").append("div").attr("class", "chart-header-one").text("HI MARK")
    y.domain([0, d3.max(thing2, function(d) {return (d.frequency/0.8); })]);
    svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis)
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
    .append("rect")
    .attr("class", "bar")
    .attr("data-ids", function(d, i){
      return i;
    })
    .attr("x", function(d, i) {return x(d.letter); })
    .attr("width", x.rangeBand())
    .attr("y", function(d) { return y((d.frequency/0.99)); })
    .attr("height", function(d) { return (height - y(d.frequency/0.99)); });

  svg.selectAll(".x.axis g text").attr("data-ids", function(d, i){
    return i;
  });

  $(".mutation_graph").on("mouseenter mouseleave", "rect", function(){
    var single_mutation = $(this).data("ids");
    console.log(thing2[single_mutation].mutation_type);
    $(".single_mutation_data").addClass("visible");
    var mut_type = thing2[single_mutation].mutation_type;
    if (mut_type === "standard") {
      mut_type = "point";
    }
    var mut_from = thing2[single_mutation].mutation_from;
    var mut_to = thing2[single_mutation].mutation_to;
    var inital_position = thing2[single_mutation].letter;
    var repeat_hits = thing2[single_mutation].mutation_count
    $("#mtype").text(mut_type);
    $("#wtype").text(mut_from);
    $("#specific_mutation").text(mut_to);
    $("#initial_position").text(inital_position);
    $("#mutation_count").text(repeat_hits)

  });

 });
