totalWidth = 1250
totalHeight = 2500
margin = {top: 20, right:10, left:10, bottom:20}
svgWidth = totalWidth - margin.left - margin.right;
svgHeight = totalHeight - margin.top - margin.bottom;

barWidth = 20
circleRadius = 3
barWidthMargin = 0.5
Alignment = {LEFT:1,CENTER:2,RIGHT:3}

ColumnMargin = 0.01 * svgWidth;
ColumnWidth = {pol: 0.3 * svgWidth - 2 * ColumnMargin, his: 0.4 * svgWidth - 2 * ColumnMargin, food: 0.3 * svgWidth - 2 * ColumnMargin}
ColumnX = {pol: 0.3 * svgWidth , his: 0.5 * svgWidth, food: 0.7 * svgWidth  }
ColumnAlignment = {pol: Alignment.RIGHT , his: Alignment.CENTER, food:Alignment.LEFT}

svg = d3.select "svg"
	.attr "height",totalHeight
	.attr "width",totalWidth

svg.selectAll "g"
	.attr "transform","translate(#{margin.left},#{margin.top})"

svg = d3.select ".mainGraph"


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
		.attr "transform",(d)->"translate(0,#{d.year*barWidth})"
	newRects = newBars
		.append "rect"		
		.attr "height",barWidth-barWidthMargin
		.attr "width",0
		.attr "x",0

	newDots = newBars
		.append "circle"
		.attr "cy",(barWidth-barWidthMargin)/2
		.attr "r",circleRadius
		.attr "fill","black"
		.attr "cx",0

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
	word_data = years.map (d)-> {year: d.no - min_year, value:d[name].kw.length}
	word_g = svg.append("g").attr "transform","translate(#{ColumnX[name]},0)"
	drawBarChart(word_g,word_data,name,ColumnAlignment[name], ColumnWidth[name])

drawKeywordsAmount "pol"
drawKeywordsAmount "his"
drawKeywordsAmount "food"

min_year = d3.min years,(d)->d.no

his_data = years.map (d)-> {year: d.no - min_year, value:d.his.over.pol.kw.length}
his_g = svg.append("g").attr "transform","translate(0,0)"
drawBarChart(his_g,his_data,"his",Alignment.LEFT, 50)

food_data = years.map (d)-> {year: d.no - min_year, value:d.his.over.food.kw.length}
food_g = svg.append("g").attr "transform","translate(#{svgWidth},0)"
drawBarChart(food_g,food_data,"food",Alignment.RIGHT, 50)

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



