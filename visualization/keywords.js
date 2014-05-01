
//AJAX call for the json file
var ajax = new XMLHttpRequest();
ajax.open("GET", "history.json", false);
ajax.send(null);
var history = JSON.parse(ajax.responseText);

ajax.open("GET", "food.json", false);
ajax.send(null);
var food = JSON.parse(ajax.responseText);

ajax.open("GET", "political.json", false);
ajax.send(null);
var political = JSON.parse(ajax.responseText);


function getPost(category, year, keyword) {
  switch(category){
    case 'history':
      var result = $.grep(history, function(e){ return e.year == year; }); //find all matching years
    case 'food':
      var result = $.grep(food, function(e){ return e.year == year; });
    case 'political':
      var result = $.grep(political, function(e){ return e.year == year; });  
  }

  $.each(result, function(index, value) {

      var sentence = value.content;
      if (sentence.indexOf(keyword) > -1){ //if the sentence contains the keyword
        $("#kwSentences").val($("#kwSentences").val() + "\n\n" +  sentence);
      }
  });
  
}

getPost('food', 1990, 'Camp');

