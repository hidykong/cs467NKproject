LineGraph = 
	graphWidth: 0
	graphHeight: 0
	rootG:null
	minYear: -1
	maxYear: -1
	X:{pol: ColumnX.his - ColumnWidth.his / 2 - ColumnMargin.BETWEEN, food: ColumnX.his}
	axisYOffset: -barWidth
	axisLengthOffset: 2*barWidth
	# max_value:{pol:0,food:0}
	init:->
		@minYear = d3.min years,(d)->d.no
		@maxYear = d3.max years,(d)->d.no

		@graphWidth = ColumnWidth.his / 2 + ColumnMargin.BETWEEN
		@graphHeight = barWidth * (@maxYear - @minYear);

	drawLineGraph: (name, align)->
		data = years.map (d)->
			{
				no:d.no,
				value:d.his.over[name].perc
			}
		
		data.splice 0,0,{no:@minYear,value:0}

		#Setup SVG
		lineGraph = d3.select ".lineGraph"
		
			
		rootG = lineGraph
			.append "g"			
			.attr "transform","translate(#{@X[name]},#{barWidth / 2})"

		#Setup Scale
		maxValue = 10 #force the two graphs to have the same max value
		#d3.max data,(d)->d.value
		
		#value scale
		x = d3.scale.linear()
		.domain [0,maxValue]		

		

		#year scale
		y = d3.scale.linear()
		.domain [@minYear,@maxYear]
		.range [0,@graphHeight]


		switch align
			when Alignment.LEFT 
				x.range [0,@graphWidth]
			when Alignment.RIGHT
				x.range [@graphWidth,0]

		xAxis = d3.svg.axis()
			.scale x
			.orient "top"
			.tickSize -@graphHeight-@axisLengthOffset
			.tickPadding 10
			.tickFormat (d)->"#{d}%"

		

		line = d3.svg.line()
			.x (d)->x(d.value)
			.y (d)->y(d.no)


		rootG.append "path"
			.datum data
			.attr "class","overlapLine his"
			.attr "d",line

		axisG = lineGraph
			.append "g"
			.attr "class", "x axis"
			.attr "transform","translate(#{@X[name]},#{@axisYOffset})"
			.call xAxis

		showGroup(lineGraph,axisTranstionTime,axisTranstionTime*1.5)














