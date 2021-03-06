// Generated by CoffeeScript 1.7.1
var axisCanvas, clearAllButtons, clearAllViews, drawBarChart, drawColLine, drawDocView, drawKeywordsAmount, drawMediaView, drawOverlapKeywords, drawTotalKeywords, drawYearLines, mouseClickOnBar, overlayCanvas, setLegends, showAllViews, showGroup, svg, switchToDocView, switchToHelpView, switchToMediaView, switchToPieView, switchToSubView;

drawBarChart = function(group, array, className, align, maxWidth) {
  var bars, maxValue, newBars, newRects, rectX, x;
  maxValue = max_keyword_amount;
  x = d3.scale.linear().range([0, maxWidth]).domain([0, maxValue]);
  bars = group.selectAll(".bar." + className).data(array);
  newBars = bars.enter().append("g").attr("class", "bar " + className).attr("transform", function(d) {
    return "translate(0," + (d.no * barWidth) + ")";
  });
  newRects = newBars.append("rect").on("click", mouseClickOnBar).attr("height", barWidth - barWidthMargin).attr("width", 0).attr("x", 0);
  newRects.append("title").text(function(d) {
    return "" + d.value + " keywords";
  });
  rectX = (function() {
    switch (align) {
      case Alignment.LEFT:
        return function(d) {
          return 0;
        };
      case Alignment.CENTER:
        return function(d) {
          return x(-d.value / 2);
        };
      case Alignment.RIGHT:
        return function(d) {
          return x(-d.value);
        };
    }
  })();
  return newRects.transition().duration(function(d) {
    return d.no * 100 + 500;
  }).delay(axisTranstionTime).attr("width", function(d) {
    return x(d.value);
  }).attr("x", rectX);
};

drawKeywordsAmount = function(name, keywordsAccessor, isOverLap) {
  var className, min_year, word_data, word_g;
  min_year = d3.min(years, function(d) {
    return d.no;
  });
  word_data = years.map(function(d) {
    var res_keywords;
    res_keywords = keywordsAccessor(d);
    if (isOverLap) {
      res_keywords = res_keywords.map(function(d) {
        return {
          w: d,
          f: 1
        };
      });
    }
    return {
      no: d.no - min_year,
      value: res_keywords.length,
      sub: d[name].sub,
      obj: d[name].obj,
      keywords: res_keywords,
      name: name
    };
  });
  console.log(word_data);
  className = isOverLap ? name + " overlap" : name;
  word_g = svg.append("g").attr("transform", "translate(" + ColumnX[name] + ",0)");
  return drawBarChart(word_g, word_data, className, ColumnAlignment[name], ColumnWidth[name]);
};

drawTotalKeywords = function(name) {
  return drawKeywordsAmount(name, function(d) {
    return d[name].kw;
  });
};

drawOverlapKeywords = function(name) {
  var acc;
  acc = function(d) {
    return d.news[name].kw;
  };
  return drawKeywordsAmount(name, acc, true);
};

drawYearLines = function(axisGroup, overlayGroup, ColLineStartY) {
  var max_year, min_year, yearAxisL, yearAxisLine, yearAxisR, yearScale, year_data;
  min_year = d3.min(years, function(d) {
    return d.no;
  });
  max_year = d3.max(years, function(d) {
    return d.no;
  });
  year_data = years.map(function(d) {
    return {
      year: d.no,
      no: d.no - min_year
    };
  });
  year_data.push({
    year: "",
    no: max_year + 1 - min_year
  });
  yearScale = d3.scale.linear().domain([min_year, max_year + 1]).range([0, (max_year - min_year + 1) * barWidth]);
  yearAxisLine = d3.svg.axis().scale(yearScale).orient("left").ticks(years.length).tickSize(-svgWidth);
  yearAxisL = d3.svg.axis().scale(yearScale).orient("left").ticks(years.length / 5).tickSize(0).tickFormat(d3.format("d")).tickPadding(yearTicksPadding);
  yearAxisR = d3.svg.axis().scale(yearScale).orient("right").ticks(years.length / 5).tickSize(0).tickFormat(d3.format("d")).tickPadding(yearTicksPadding);
  axisGroup.append("g").attr("class", "year axis line").attr("transform", "translate(0,-0.5)").call(yearAxisLine);
  axisGroup.append("g").attr("class", "year axis").attr("transform", "translate(0," + (barWidth / 2) + ")").call(yearAxisL);
  axisGroup.append("g").attr("class", "year axis").attr("transform", "translate(" + svgWidth + "," + (barWidth / 2) + ")").call(yearAxisR);
  overlayGroup.selectAll("line").remove();
  drawColLine(overlayGroup, ColumnX.pol, ColLineStartY.pol, year_data[year_data.length - 1].no * barWidth);
  drawColLine(overlayGroup, ColumnX.food, ColLineStartY.food, year_data[year_data.length - 1].no * barWidth);
  return drawColLine(overlayGroup, ColumnX.his, ColLineStartY.his, year_data[year_data.length - 1].no * barWidth);
};

drawColLine = function(group, x, y1, y2) {
  return group.append("line").attr("x1", x).attr("x2", x).attr("y1", y1).attr("y2", y2).attr("class", "colLine");
};

drawDocView = function() {
  drawTotalKeywords("pol");
  drawTotalKeywords("food");
  drawYearLines(axisCanvas, overlayCanvas, {
    pol: 0,
    his: -margin.top,
    food: 0
  });
  LineGraph.drawLineGraph("pol", Alignment.LEFT);
  LineGraph.drawLineGraph("food", Alignment.RIGHT);
  WordTable.setColumns(['pol', 'food']);
  return WordTable.displayKeywordFunc = WordTable.displayForDocView;
};

drawMediaView = function() {
  drawTotalKeywords("pol");
  drawTotalKeywords("his");
  drawTotalKeywords("food");
  drawOverlapKeywords("pol");
  drawOverlapKeywords("his");
  drawOverlapKeywords("food");
  drawYearLines(axisCanvas, overlayCanvas, {
    pol: -margin.top,
    his: 0,
    food: -margin.top
  });
  WordTable.setColumns(['pol', 'his', 'food']);
  return WordTable.displayKeywordFunc = WordTable.displayForMediaView;
};

setLegends = function(legendsData) {
  var legendRows, legendTable;
  legendTable = d3.select(".legendTable");
  legendTable.selectAll(".legendRow").remove();
  legendRows = legendTable.selectAll(".legendRow").data(legendsData).enter().append("div").attr("class", "legendRow");
  legendRows.append("div").attr("class", function(d) {
    return "legendDIV " + d["class"];
  });
  return legendRows.append("span").attr("class", function(d) {
    return "legendText " + d["class"];
  }).text(function(d) {
    return d.text;
  });
};

clearAllButtons = function() {
  return d3.selectAll(".viewButtonRow").attr("class", "viewButtonRow");
};

showGroup = function(group, durationT, delayT) {
  return group.style("opacity", 0).transition().duration(durationT).delay(delayT).style("opacity", 1);
};

showAllViews = function() {
  showGroup(d3.select("#mainSVG"), axisTranstionTime, 0);
  showGroup(d3.select(".keywordTable"), axisTranstionTime, 0);
  return showGroup(d3.select(".legendContainer"), axisTranstionTime, 0);
};

clearAllViews = function() {
  var svg;
  svg = d3.select("#mainSVG").attr("height", totalHeight).attr("width", totalWidth);
  d3.select(".visualContainer").style("opacity", 1);
  svg.select(".globalG").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
  svg.select(".globalG").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
  svg.select(".lineGraph").selectAll("*").remove();
  svg.select(".axisCanvas").selectAll("*").remove();
  svg.select(".mainGraph").selectAll("*").remove();
  svg.select(".pieGraph").selectAll("*").remove();
  svg.select(".overlayCanvas").selectAll("*").remove();
  svg.select(".subGraph").selectAll("*").remove();
  d3.select(".svgContainer").style("height", "350px");
  hideKeywordText();
  clearAllButtons();
  WordTable.clear();
  LineGraph.init();
  WordTable.init();
  PieGraph.init();
  return SubGraph.init();
};

switchToDocView = function() {
  clearAllViews();
  d3.select("#DocRow").attr("class", "viewButtonRow active");
  setLegends(legendsDataLib["Doc"]);
  drawDocView();
  return showAllViews();
};

switchToMediaView = function() {
  clearAllViews();
  d3.select("#MediaRow").attr("class", "viewButtonRow active");
  setLegends(legendsDataLib["Media"]);
  drawMediaView();
  return showAllViews();
};

switchToSubView = function() {
  clearAllViews();
  d3.select("#SubRow").attr("class", "viewButtonRow active");
  setLegends(legendsDataLib["Sub"]);
  SubGraph.draw();
  return showAllViews();
};

switchToPieView = function() {
  clearAllViews();
  d3.select("#PieRow").attr("class", "viewButtonRow active");
  setLegends(legendsDataLib["Pie"]);
  PieGraph.draw();
  return showGroup(d3.select(".legendContainer"), axisTranstionTime, 0);
};

switchToHelpView = function() {
  clearAllViews();
  return d3.select(".overlayCanvas").append("text").attr("y", 20).text("There is no help in North Korea").attr("fill", "white").attr("font-size", "3em").style("font-family", "Oswald").style("text-transform", "uppercase").style("opacity", 0).transition().duration(2000).style("opacity", 1);
};

mouseClickOnBar = function(e) {
  if (WordTable.displayKeywordFunc != null) {
    return WordTable.displayKeywordFunc(e.no);
  }
};

svg = d3.select("#mainSVG").attr("height", totalHeight).attr("width", totalWidth);

svg.select(".globalG").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

svg = d3.select(".mainGraph");

axisCanvas = d3.select(".axisCanvas");

overlayCanvas = d3.select(".overlayCanvas");

clearAllViews();

switchToDocView();
