
svg = d3.select "#mainSVG"
	.attr "height",totalHeight
	.attr "width",totalWidth

svg.selectAll "g"
	.attr "transform","translate(#{margin.left},#{margin.top})"

svg = d3.select ".mainGraph"
axisCanvas = d3.select ".axisCanvas"

subColor = d3.scale.ordinal()
	.domain [0,1,2,3,4]
	.range ["#4B4F98","#6A4583","#883A6E","#A73059","#C62644"]

drawBarChart = (group,array,className,align, maxWidth)->
	maxValue = d3.max array,(d)->d.value

	x = d3.scale.linear()
	.range [0,maxWidth]
	.domain [0,maxValue]

	bars = group.selectAll(".bar.#{className}")
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

	newDots = newBars
		.append "circle"
		.attr "cy",(barWidth-barWidthMargin)/2
		.attr "r",circleRadius
		.attr "fill",(d)->
			if d.value == 0
				return "transparent"
			else
				subColor(Math.floor(d.sub/0.2))
		.attr "cx",0
	
	newRects.append "title"
		.text (d)->"#{d.value} keywords"

	newDots.append "title"
		.text (d)->"Subjective: #{Math.floor(d.sub*100)}%, Objective: #{Math.floor(d.obj*100)}%"

	rectX = ->0
	dotX = ->0
	switch align
		when Alignment.LEFT
			rectX = (d)->0
			dotX = (d)->x(d.value)
		when Alignment.CENTER 
			rectX = (d)->x(-d.value/2)
			dotX = (d)->0
		when Alignment.RIGHT
			rectX = (d)->x(-d.value)
			dotX = (d)->x(-d.value)
	
	newRects
		.transition()
		.duration 1000
		.attr "width",(d)->x(d.value)
		.attr "x",rectX
	newDots
		.transition()
		.duration 1000
		.attr "cx",dotX


drawKeywordsAmount = (name)->
	min_year = d3.min years,(d)->d.no
	word_data = years.map (d)-> 
		res_keywords = [];
		if name is 'his' 
			res_keywords = d[name].kw 
		else
			res_keywords =  d.his.over[name].kw.map (d)->{w:d,f:1}
		{no: d.no - min_year, 
		value:d[name].kw.length, 
		sub:d[name].sub, 
		obj:d[name].obj, 
		keywords:res_keywords, 
		name:name}

	word_g = svg.append("g").attr "transform","translate(#{ColumnX[name]},0)"
	drawBarChart(word_g,word_data,name,ColumnAlignment[name], ColumnWidth[name])

drawYearLines = (axisCanvas)->
	min_year = d3.min years,(d)->d.no
	max_year = d3.max years,(d)->d.no
	year_data = years.map (d)->{year:d.no, no:d.no-min_year}
	year_data.push({year:"", no:max_year + 1 - min_year});

	newYearAxisGs = axisCanvas.selectAll(".yearAxis")
		.data(year_data)
		.enter()
		.append("g")
		.attr "transform",(d)->"translate(0,#{d.no*barWidth-barWidthMargin/2})"

	newLines = newYearAxisGs
		.append("line")
		.attr "x1",-margin.left
		.attr "x2",totalWidth
		.attr "y1",0
		.attr "y2",0
		.attr "class","yearLine"

	newYearAxisGs
		.append("text")
		.attr "x",0
		.attr "y",barWidth-5
		.attr "class","yearText"
		.text (d)->d.year

	newYearAxisGs
		.append("text")
		.attr "x",svgWidth
		.attr "y",barWidth-5
		.attr "text-anchor","end"
		.attr "class","yearText"
		.text (d)->d.year

	axisCanvas.append("line")
		.attr "x1",ColumnX.pol
		.attr "x2",ColumnX.pol
		.attr "y1",0
		.attr "y2",year_data[year_data.length-1].no*barWidth
		.attr "class","yearLine"

	axisCanvas.append("line")
		.attr "x1",ColumnX.food
		.attr "x2",ColumnX.food
		.attr "y1",0
		.attr "y2",year_data[year_data.length-1].no*barWidth
		.attr "class","yearLine"
	
mouseClickOnBar = (e)->
	WordCloud.drawKeywords e.name,e.keywords

drawKeywordsAmount "pol"
drawKeywordsAmount "his"
drawKeywordsAmount "food"

drawYearLines axisCanvas

WordCloud.init()

LineGraph.init()

LineGraph.drawLineGraph("pol",Alignment.LEFT)
LineGraph.drawLineGraph("food",Alignment.RIGHT)

PieGraph.init()












# min_year = d3.min years,(d)->d.no

# his_data = years.map (d)-> {year: d.no - min_year, value:d.his.over.pol.kw.length}
# his_g = svg.append("g").attr "transform","translate(0,0)"
# drawBarChart(his_g,his_data,"his",Alignment.LEFT, 50)

# food_data = years.map (d)-> {year: d.no - min_year, value:d.his.over.food.kw.length}
# food_g = svg.append("g").attr "transform","translate(#{svgWidth},0)"
# drawBarChart(food_g,food_data,"food",Alignment.RIGHT, 50)

# line = d3.svg.line()
# 	.x (d)->d.value
# 	.y (d)->d.year*10

# svg.append "path"
# 	.datum array
# 	.style "stroke","black"
# 	.style "stroke-width","1.5px"
# 	.attr "d",line

#array = [13,22,33,14,53,5,36,27,48,39,20].map((d,i)->{year:i,value:d})	



# g = svg.append("g").attr "transform","translate(300,0)"
# drawBarChart(g,array,"food",Alignment.CENTER)

# g = svg.append("g").attr "transform","translate(600,0)"
# drawBarChart(g,array,"food",Alignment.RIGHT)



