PieGraph =
	centerR:{in:0,out:80}
	objR:{in:80,out:85}
	overlapR:{in:85,out:100}
	mediaR:{in:100,out:115}
	transitionTime: 1000
	# delayTime:{obj:0,pol:0,food:0,his:0,media:0,center:0}
	delayTime:{obj:1300,pol:1600,food:1600,his:1600,media:1900,center:0, title:1000,caption:3000}
	captionLineLength: 50;
	pointerLineLength: {obj:100,pol:30,food:30,his:50,media:50,center:0}
	categoryName:{his:"History",pol:"Politics Camp",food:"Food"}
	hisR:null
	polR:null
	foodR:null
	
	PieX:{pol:ColumnX.pol - ColumnWidth.pol * 2 / 3, his:ColumnX.his, food: ColumnX.food + ColumnWidth.food* 2 / 3}
	init:->
		@hisR = @polR = @foodR = @overlapR 

		
	draw:->
		WordTable.clear()
		
		d3.select "#mainSVG"
		.attr "height","550"

		d3.select ".svgContainer"
		.style "height","550px"



		@createCategory "his"
		@createCategory "pol"
		@createCategory "food"
	
	clear:->
		d3.select ".pieGraph"
		.selectAll ".pie"
		.remove();

	createCategory:(name)->	
		graph = d3.select ".pieGraph"
			.append "g"
			.attr "transform","translate(#{@PieX[name]},225)"
			.attr "class",name+' pie'
		
		captionGraph = d3.select ".pieGraph"
			.append "g"
			.attr "transform","translate(#{@PieX[name]},225)"
			.attr "class",'caption'

		captionGraph.append("text")
			.attr "class","captionTitle"
			.attr "x",0
			.attr "y","0.3em"
			.text @categoryName[name]
			.attr "opacity",0
			.transition()
			.duration @transitionTime
			.delay @delayTime['title']
			.attr "opacity",1



		data = overall[name]

		@createSection(graph,"obj",data)
		@createCaption(captionGraph,"obj",data)

		sectionName = switch name 
			when 'his' then 'pol' 
			else 'his'
		
		@createSection(graph,sectionName,data)
		@createCaption(captionGraph,sectionName,data)
		
		if name is 'his'
			startAngle = @getAngle data['pol']
			endAngle = @getAngle data['pol']
			graph.append "path"
				.datum @createDatum('food',startAngle+endAngle,startAngle)
				.attr "class","food fore"
				.transition()
				.duration @transitionTime
				.delay @delayTime['food']
				.attrTween "d",@tweenFunc
			@createCaption(captionGraph,"food",data,0.9)

		@createSection(graph,"media",data)
		@createCaption(captionGraph,"media",data)

		@createSection(graph,"center")

		
		

	createDatum:(name,endAngle,startAngle=0)->
		{
			innerRadius:PieGraph["#{name}R"].in
			outerRadius:PieGraph["#{name}R"].out
			startAngle: startAngle
			endAngle: endAngle
		}

	createSection:(group,name,data)->
		arc = d3.svg.arc()
		if name is 'center'
			group.append "path"
				.datum @createDatum(name,2 * Math.PI)
				.attr "class","#{name} back"		
				.attr "d",arc
				.attr "transform","scale(0.1)"
				.transition()
				.ease('elastic')
				.duration @transitionTime
				.attr "transform","scale(1)"
		else
			group.append "path"
				.datum @createDatum(name,2 * Math.PI)
				.attr "class","#{name} back"		
				.transition()
				.duration @transitionTime
				.delay @delayTime[name]
				.attrTween "d",@tweenFunc
				# .attr "d",arc

		if data?
			group.append "path"
				.datum @createDatum(name,@getAngle(data[name]))	
				.attr "class","#{name} fore"
				.transition()
				.duration @transitionTime
				.delay @delayTime[name]
				.attrTween "d",@tweenFunc
	
	createCaption:(group,name,data,angle)->
		value = data[name]
		datum = @createDatum(name,@getAngle(data[name]))
		r = (datum.innerRadius + datum.outerRadius)/2
		if !angle?
			angle = (datum.startAngle + datum.endAngle)*1/4
		else
			angle = angle * Math.PI;

		if Math.PI/2 - 0.5 < angle < Math.PI/2 + 0.5
			angle = angle * 2;

		if angle > Math.PI
			angle = angle

		xy1 = @getXY(r,angle)
		xy2 = @getXY(r+@pointerLineLength[name],angle)
		xy3 = {x:xy2.x + @captionLineLength, y:xy2.y}

		@drawLine(group,xy1,xy2)
		@drawLine(group,xy2,xy3)

		group.append("text")
		.attr "class","captionNum"
		.attr "x",xy2.x
		.attr "y",xy2.y-3
		.text(d3.round(value*100,1)+"%")
		.attr "opacity",0
		.transition()
		.duration @transitionTime
		.delay @delayTime['caption']
		.attr "opacity",1


	drawLine:(group,xy1,xy2)->
		group.append("line")
		.attr "x1",xy1.x
		.attr "x2",xy2.x
		.attr "y1",xy1.y
		.attr "y2",xy2.y
		.attr "opacity",0
		.transition()
		.duration @transitionTime
		.delay @delayTime['caption']
		.attr "opacity",1

	getXY:(r,a)->
		a = a - Math.PI/2
		return {x:Math.cos(a)*r,y:Math.sin(a)*r}

	getAngle:(value)->value*2 * Math.PI
	tweenFunc:(d)->
		arc = d3.svg.arc()
		startData = {innerRadius:d.innerRadius,outerRadius:d.outerRadius,endAngle:0,startAngle:0}
		interpolate = d3.interpolate(startData,d);
		(t)->arc interpolate(t)	
