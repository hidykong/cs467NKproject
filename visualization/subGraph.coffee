SubGraph =
	minYear: -1
	maxYear:-1
	radius: 5
	x:null
	y:null
	rootG:null		
	init:->
		@minYear = d3.min years,(d)->d.no
		@maxYear = d3.max years,(d)->d.no

		@rootG = d3.select ".subGraph"

		@x = d3.scale.linear()
			.domain [0,1]
			.range [ColumnX.pol,ColumnX.food]
		@y = d3.scale.linear()
			.domain [@minYear,@maxYear]
			.range [barWidth/2,barWidth/2 + barWidth * (@maxYear-@minYear)]

	draw:->
		WordTable.clear()
		drawYearLines axisCanvas,overlayCanvas,{pol:0,his:0,food:0}

		@drawLine "food"
		@drawLine "his"
		@drawLine "pol"
		@drawLine "news"

	drawLine:(name,className,acc)->
		if !className? then className = name
		if !acc? then acc = (d)->{value:d[name].obj, no:d.no}
		data = []
		years.forEach (d)->
			if name is "news" or d[name].kw.length != 0
				data.push acc(d)	

		group = SubGraph.rootG.append "g"
			.attr "class", className

		line = d3.svg.line()
			.x (d)->SubGraph.x(d.value)
			.y (d)->SubGraph.y(d.no)

		group.append "path"
			.datum data
			.attr "d",line

		group.selectAll ".dot"
			.data data
			.enter()
			.append "circle"
			.attr "r",SubGraph.radius
			.attr "cx",(d)->SubGraph.x(d.value)
			.attr "cy",(d)->SubGraph.y(d.no)


