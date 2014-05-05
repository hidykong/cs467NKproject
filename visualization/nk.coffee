drawBarChart = (group,array,className,align, maxWidth)->
	maxValue = max_keyword_amount #d3.max array,(d)->d.value

	x = d3.scale.linear()
	.range [0,maxWidth]
	.domain [0,maxValue]

	bars = group.selectAll ".bar.#{className}"
		.data(array)

	newBars = bars
		.enter()
		.append "g"
		.attr "class","bar #{className}"
		.attr "transform",(d)->"translate(0,#{d.no*barWidth})"

	newRects = newBars
		.append "rect"		
		.on "click",mouseClickOnBar
		.attr "height",barWidth-barWidthMargin
		.attr "width",0
		.attr "x",0
	
	newRects.append "title"
		.text (d)->"#{d.value} keywords"

	rectX = switch align
		when Alignment.LEFT then (d)->0
		when Alignment.CENTER then (d)->x(-d.value/2)
		when Alignment.RIGHT then (d)->x(-d.value)
	
	newRects
		.transition()
		.duration 1000
		.attr "width",(d)->x(d.value)
		.attr "x",rectX

drawKeywordsAmount = (name,keywordsAccessor,isOverLap)->
	min_year = d3.min years,(d)->d.no
	word_data = years.map (d)-> 
		res_keywords = keywordsAccessor(d)
		if isOverLap
			res_keywords = res_keywords.map (d)->{w:d,f:1}
		{no: d.no - min_year, 
		value:res_keywords.length, 
		sub:d[name].sub, 
		obj:d[name].obj, 
		keywords:res_keywords, 
		name:name}
	className = if isOverLap then name + " overlap" else name
	word_g = svg.append("g").attr "transform","translate(#{ColumnX[name]},0)"
	drawBarChart(word_g,word_data,className,ColumnAlignment[name], ColumnWidth[name])

drawTotalKeywords = (name)->
	drawKeywordsAmount(name,(d)->d[name].kw);

drawOverlapKeywords = (name)->
	acc = (d)->d.news[name].kw
	drawKeywordsAmount(name,acc,true);

drawYearLines = (axisGroup,overlayGroup, ColLineStartY)->
	min_year = d3.min years,(d)->d.no
	max_year = d3.max years,(d)->d.no
	year_data = years.map (d)->{year:d.no, no:d.no-min_year}
	year_data.push({year:"", no:max_year + 1 - min_year});

	yearScale = d3.scale.linear()
		.domain [min_year,max_year+1]
		.range [0,(max_year-min_year+1)*barWidth]

	yearAxisLine = d3.svg.axis()
		.scale yearScale
		.orient "left"
		.ticks years.length		
		.tickSize -svgWidth

	yearAxisL = d3.svg.axis()
		.scale yearScale
		.orient "left"
		.ticks years.length/5
		.tickSize 0
		.tickFormat d3.format("d")
		.tickPadding yearTicksPadding

	yearAxisR = d3.svg.axis()
		.scale yearScale
		.orient "right"
		.ticks years.length/5
		.tickSize 0
		.tickFormat d3.format("d")
		.tickPadding yearTicksPadding

	axisGroup
		.append "g"
		.attr "class","year axis line"
		.attr "transform","translate(0,-0.5)"
		.call yearAxisLine

	axisGroup
		.append "g"
		.attr "class","year axis"
		.attr "transform","translate(0,#{barWidth/2})"
		.call yearAxisL

	axisGroup
		.append "g"
		.attr "class","year axis"
		.attr "transform","translate(#{svgWidth},#{barWidth/2})"
		.call yearAxisR

	overlayGroup.selectAll "line"
		.remove()
	drawColLine(overlayGroup,ColumnX.pol,ColLineStartY.pol,year_data[year_data.length-1].no*barWidth)
	drawColLine(overlayGroup,ColumnX.food,ColLineStartY.food,year_data[year_data.length-1].no*barWidth)
	drawColLine(overlayGroup,ColumnX.his,ColLineStartY.his,year_data[year_data.length-1].no*barWidth)

drawColLine = (group,x,y1,y2)->
	group.append("line")
		.attr "x1",x
		.attr "x2",x
		.attr "y1",y1
		.attr "y2",y2
		.attr "class","colLine"

drawDocView = ->
	drawTotalKeywords "pol"
	drawTotalKeywords "food"

	drawYearLines axisCanvas,overlayCanvas,{pol:0,his:-margin.top,food:0}

	LineGraph.drawLineGraph("pol",Alignment.LEFT)
	LineGraph.drawLineGraph("food",Alignment.RIGHT)

	WordTable.setColumns ['pol','food']
	WordTable.displayKeywordFunc = WordTable.displayForDocView

drawMediaView = ->
	drawTotalKeywords "pol"
	drawTotalKeywords "his"
	drawTotalKeywords "food"

	drawOverlapKeywords "pol"
	drawOverlapKeywords "his"
	drawOverlapKeywords "food"

	drawYearLines axisCanvas,overlayCanvas,{pol:-margin.top,his:0,food:-margin.top}	

	WordTable.setColumns ['pol','his','food']

	WordTable.displayKeywordFunc = WordTable.displayForMediaView

setLegends = (legendsData)->
	legendTable = d3.select ".legendTable"
	legendTable.selectAll ".legendRow"
		.remove()

	legendRows = legendTable.selectAll ".legendRow"
		.data legendsData
		.enter()
		.append "div"
		.attr "class","legendRow"

	legendRows.append "div"
		.attr "class",(d)->"legendDIV #{d.class}"
	legendRows.append "span"
		.attr "class",(d)->"legendText #{d.class}"
		.text (d)->d.text

clearAllButtons = ->
	d3.selectAll ".viewButtonRow"
		.attr "class","viewButtonRow"

clearAllViews = ->
	svg = d3.select "#mainSVG"
	.attr "height",totalHeight
	.attr "width",totalWidth

	d3.select ".visualContainer"
	.style "opacity",1

	svg.select ".globalG"
	.attr "transform","translate(#{margin.left},#{margin.top})"

	svg.select ".globalG"
		.attr "transform","translate(#{margin.left},#{margin.top})"
	svg.select ".lineGraph"
		.selectAll "*"
		.remove()
	svg.select ".axisCanvas"
		.selectAll "*"
		.remove()
	svg.select ".mainGraph"
		.selectAll "*"
		.remove()
	svg.select ".pieGraph"
		.selectAll "*"
		.remove()
	svg.select ".overlayCanvas"
		.selectAll "*"
		.remove()
	svg.select ".subGraph"
		.selectAll "*"
		.remove()
	
	d3.select ".svgContainer"
		.style "height","350px"

	hideKeywordText();

	clearAllButtons()

	WordTable.clear()

	LineGraph.init()
	WordTable.init()
	PieGraph.init()
	SubGraph.init()

switchToDocView = ->
	clearAllViews();
	d3.select("#DocRow").attr("class","viewButtonRow active")
	setLegends legendsDataLib["Doc"]
	drawDocView();
switchToMediaView = ->
	clearAllViews();
	d3.select("#MediaRow").attr("class","viewButtonRow active")
	setLegends legendsDataLib["Media"]
	drawMediaView();
switchToSubView = ->
	clearAllViews();
	d3.select("#SubRow").attr("class","viewButtonRow active")
	setLegends legendsDataLib["Sub"]
	SubGraph.draw();
switchToPieView = ->
	clearAllViews();
	d3.select("#PieRow").attr("class","viewButtonRow active")
	setLegends legendsDataLib["Pie"]
	PieGraph.draw();

switchToHelpView = ->
	clearAllViews();


mouseClickOnBar = (e)->
	if WordTable.displayKeywordFunc? then WordTable.displayKeywordFunc(e.no)







svg = d3.select "#mainSVG"
	.attr "height",totalHeight
	.attr "width",totalWidth

svg.select ".globalG"
	.attr "transform","translate(#{margin.left},#{margin.top})"

svg = d3.select ".mainGraph"
axisCanvas = d3.select ".axisCanvas"

overlayCanvas = d3.select ".overlayCanvas"

# subColor = d3.scale.ordinal()
# 	.domain [0,1,2,3,4]
# 	.range ["#4B4F98","#6A4583","#883A6E","#A73059","#C62644"]

clearAllViews();



switchToDocView();


# getPost('food', 1990, 'food');

# drawTotalKeywords "pol"
# # drawTotalKeywords "his"
# drawTotalKeywords "food"

# drawOverlapKeywords "pol"
# drawOverlapKeywords "his"
# drawOverlapKeywords "food"

# drawYearLines axisCanvas,overlayCanvas,{pol:0,his:0,food:0}

# LineGraph.init()
# # LineGraph.drawLineGraph("pol",Alignment.LEFT)
# # LineGraph.drawLineGraph("food",Alignment.RIGHT)

# WordTable.init()

# PieGraph.init()
# PieGraph.draw()
# PieGraph.clear()




