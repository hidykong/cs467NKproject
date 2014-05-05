function processData(allText) {
    var allTextLines = allText.split(/\r\n|\n/);
    var headers = allTextLines[0].split('~');
    var lines = [];

    for (var i=1; i<allTextLines.length; i++) {
        var data = allTextLines[i].split('~');
        if (data.length == headers.length) {
            var tarr = [];
            tarr.push(headers[0]+" "+data[0]);
            tarr.push(data[1]) //write the testimonial
            lines.push(tarr);
        }
    }
    return lines;
}

function getRandomInt (min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function getTest() {
	$(document).ready(function() {
	    $.ajax({
	        type: "GET",
	        url: "testimonials.csv",
	        dataType: "text",
	        success: function(data) {
	        	var test = processData(data);
	        	index = getRandomInt(0, test.length); //get a random testimonial
				document.getElementById('test').innerHTML = test[index][1];
				document.getElementById('footnote').innerHTML = test[index][0];
	        }
	     });
	});
}

window.onload=getTest;