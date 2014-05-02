
//AJAX call for the json file
var ajax = new XMLHttpRequest();
ajax.open("GET", "json/history.json", false);
ajax.send(null);
var history = JSON.parse(ajax.responseText);

ajax.open("GET", "json/food.json", false);
ajax.send(null);
var food = JSON.parse(ajax.responseText);

ajax.open("GET", "json/political.json", false);
ajax.send(null);
var political = JSON.parse(ajax.responseText);



function getPost(category, year, keyword) {
  document.getElementById('kwSentences').innerHTML = "<span class=\"header\">" +category + ": " + year + "</span>";
  switch(category){
    case 'History':
      var result = $.grep(history, function(e){ return e.year == year; }); //find all matching years
      break;
    case 'Food':
      var result = $.grep(food, function(e){ return e.year == year; });
      break;
    case 'Political':
      var result = $.grep(political, function(e){ return e.year == year; });
      break;  
  }
  $.each(result, function(index, value) {
      var sentence = value.content;
      if (sentence.indexOf(keyword) > -1){ //if the sentence contains the keyword
        sentence = sentence.replace(keyword, "<span class=\"keyword\"> " + keyword + "</span>")
        document.getElementById('kwSentences').innerHTML = document.getElementById('kwSentences').innerHTML + "<br/><br/>" + sentence;
        
        console.log(sentence);

      }
  });
}


getPost('History', 1990, 'food');

