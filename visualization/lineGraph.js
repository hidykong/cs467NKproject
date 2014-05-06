// Generated by CoffeeScript 1.7.1
var LineGraph;

LineGraph = {
  graphWidth: 0,
  graphHeight: 0,
  rootG: null,
  minYear: -1,
  maxYear: -1,
  X: {
    pol: ColumnX.his - ColumnWidth.his / 2 - ColumnMargin.BETWEEN,
    food: ColumnX.his
  },
  axisYOffset: -barWidth,
  axisLengthOffset: 2 * barWidth,
  init: function() {
    this.minYear = d3.min(years, function(d) {
      return d.no;
    });
    this.maxYear = d3.max(years, function(d) {
      return d.no;
    });
    this.graphWidth = ColumnWidth.his / 2 + ColumnMargin.BETWEEN;
    return this.graphHeight = barWidth * (this.maxYear - this.minYear);
  },
  drawLineGraph: function(name, align) {
    var axisG, data, line, lineGraph, maxValue, rootG, x, xAxis, y;
    data = years.map(function(d) {
      return {
        no: d.no,
        value: d.his.over[name].perc
      };
    });
    data.splice(0, 0, {
      no: this.minYear,
      value: 0
    });
    lineGraph = d3.select(".lineGraph");
    rootG = lineGraph.append("g").attr("transform", "translate(" + this.X[name] + "," + (barWidth / 2) + ")");
    maxValue = 10;
    x = d3.scale.linear().domain([0, maxValue]);
    y = d3.scale.linear().domain([this.minYear, this.maxYear]).range([0, this.graphHeight]);
    switch (align) {
      case Alignment.LEFT:
        x.range([0, this.graphWidth]);
        break;
      case Alignment.RIGHT:
        x.range([this.graphWidth, 0]);
    }
    xAxis = d3.svg.axis().scale(x).orient("top").tickSize(-this.graphHeight - this.axisLengthOffset).tickPadding(10).tickFormat(function(d) {
      return "" + d + "%";
    });
    line = d3.svg.line().x(function(d) {
      return x(d.value);
    }).y(function(d) {
      return y(d.no);
    });
    rootG.append("path").datum(data).attr("class", "overlapLine his").attr("d", line);
    axisG = lineGraph.append("g").attr("class", "x axis").attr("transform", "translate(" + this.X[name] + "," + this.axisYOffset + ")").call(xAxis);
    return showGroup(lineGraph, axisTranstionTime, axisTranstionTime * 1.5);
  }
};
