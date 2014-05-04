// Generated by CoffeeScript 1.7.1
var WordTable;

WordTable = {
  maxKeywordAount: 20,
  init: function() {
    var colNames, keywords, name, row;
    row = d3.select(".keywordTable tr");
    row.selectAll("td").remove();
    colNames = ['pol', 'his', 'food'];
    row.selectAll("td").data(colNames).enter().append("td").append("div").append("p").attr("id", function(d) {
      return "" + d;
    });
    name = 'pol';
    return keywords = [
      {
        word: "Lorem",
        "class": "his"
      }, {
        word: "ipsum",
        "class": "his"
      }, {
        word: "dolor",
        "class": "his overlap"
      }, {
        word: "sit",
        "class": "his"
      }, {
        word: "amet",
        "class": "pol"
      }, {
        word: "insolens",
        "class": "his"
      }, {
        word: "mediocrem",
        "class": "his"
      }, {
        word: "aliquando",
        "class": "his"
      }, {
        word: "has",
        "class": "pol"
      }, {
        word: "ea",
        "class": "his"
      }, {
        word: "mel",
        "class": "pol"
      }, {
        word: "ad",
        "class": "his"
      }, {
        word: "dolore",
        "class": "his"
      }, {
        word: "i",
        "class": "his"
      }
    ];
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
      return b.freq - a.freq;
    });
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
  }
};
