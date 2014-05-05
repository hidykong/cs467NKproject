// Generated by CoffeeScript 1.7.1
var WordTable;

WordTable = {
  maxKeywordAount: 20,
  threeColumnWidths: [
    {
      pol: 350,
      his: 550,
      food: 350
    }
  ],
  twoColumnWidths: [
    {
      pol: 550,
      his: 0,
      food: 550
    }
  ],
  displayKeywordFunc: null,
  init: function() {},
  setColumns: function(colNames) {
    var colWidths, row;
    colWidths = colNames.length === 3 ? this.threeColumnWidths : this.twoColumnWidths;
    row = d3.select(".keywordTable tr");
    row.selectAll("td").remove();
    return row.selectAll("td").data(colNames).enter().append("td").append("div").append("p").style("width", function(d) {
      return "" + colWidths[d] + "px";
    }).attr("id", function(d) {
      return "" + d;
    });
  },
  clear: function() {
    return d3.select(".keywordTable tr").selectAll("td").remove();
  },
  clearKeywords: function() {
    var row;
    row = d3.select(".keywordTable tr");
    return row.selectAll("span").remove();
  },
  setKeywords: function(setName, keywords) {
    var htmlText, res, row, targetP;
    row = d3.select(".keywordTable tr");
    targetP = row.select("#" + setName);
    targetP.selectAll(".keyword").data(keywords).enter().append("span").attr("class", function(d) {
      return d["class"];
    }).text(function(d) {
      return d.word;
    });
    htmlText = targetP.html();
    res = htmlText.replace(/></g, "> <");
    return targetP.html(res);
  },
  displayOverlapKeywords: function(name, set1, set2) {
    var keywordsToShow;
    keywordsToShow = set1.concat(set2);
    keywordsToShow.sort(function(a, b) {
      if (((a["class"] === name && name === b["class"])) || (!(a["class"] === name) && (name === b["class"]))) {
        return b.freq - a.freq;
      } else {
        if (a["class"] === name) {
          return 1;
        } else {
          return -1;
        }
      }
    });
    console.log(keywordsToShow);
    keywordsToShow = keywordsToShow.slice(0, this.maxKeywordAount);
    return this.setKeywords(name, keywordsToShow);
  },
  displayKeywordsWithMedia: function(name, yearData) {
    var docKeywords, mediaOverlapWords;
    docKeywords = yearData[name].kw.map(function(d) {
      return {
        word: d.w,
        freq: d.f,
        "class": name
      };
    });
    mediaOverlapWords = yearData.news[name].kw.map(function(d) {
      return {
        word: d.w,
        freq: d.f,
        "class": "" + name + " overlap"
      };
    });
    return this.displayOverlapKeywords(name, docKeywords, mediaOverlapWords);
  },
  displayKeywordsOnlyDocument: function(name, yearData) {
    var docKeywords, historyOverlapWords;
    docKeywords = yearData[name].kw.map(function(d) {
      return {
        word: d.w,
        freq: d.f,
        "class": name
      };
    });
    historyOverlapWords = yearData.his.over[name].kw.map(function(d) {
      return {
        word: d,
        freq: 1,
        "class": "his"
      };
    });
    return this.displayOverlapKeywords(name, docKeywords, historyOverlapWords);
  },
  displayForMediaView: function(yearno) {
    WordTable.setColumns(['pol', 'his', 'food']);
    WordTable.clearKeywords();
    WordTable.displayKeywordsWithMedia("pol", years[yearno]);
    WordTable.displayKeywordsWithMedia("his", years[yearno]);
    return WordTable.displayKeywordsWithMedia("food", years[yearno]);
  },
  displayForDocView: function(yearno) {
    WordTable.setColumns(['pol', 'food']);
    WordTable.clearKeywords();
    WordTable.displayKeywordsOnlyDocument("pol", years[yearno]);
    return WordTable.displayKeywordsOnlyDocument("food", years[yearno]);
  }
};