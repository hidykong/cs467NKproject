PieGraph =
	centerR:{in:0,out:80}
	objR:{in:80,out:85}
	overlapR:{in:85,out:100}
	mediaR:{in:100,out:115}
	hisR:null
	polR:null
	foodR:null
	
	PieX:{pol:ColumnX.pol - ColumnWidth.pol * 2 / 3, his:ColumnX.his, food: ColumnX.food + ColumnWidth.food* 2 / 3}
	init:->
		@hisR = @polR = @foodR = @overlapR 

		
	draw:->
		WordTable.clear()
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
			.attr "transform","translate(#{@PieX[name]},100)"
			.attr "class",name+' pie'

		data = overall[name]

		@createSection(graph,"obj",data)

		sectionName = switch name 
			when 'his' then 'pol' 
			else 'his'
		@createSection(graph,sectionName,data)
		
		if name is 'his'
			startAngle = @getAngle data['pol']
			endAngle = @getAngle data['pol']
			graph.append "path"
				.datum @createDatum('food',startAngle+endAngle,startAngle)
				.attr "d",d3.svg.arc()
				.attr "class","food fore"
		
		@createSection(graph,"media",data)
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

		group.append "path"
			.datum @createDatum(name,2 * Math.PI)
			.attr "d",arc
			.attr "class","#{name} back"

		if data?
			group.append "path"
				.datum @createDatum(name,@getAngle(data[name]))
				.attr "d",arc		
				.attr "class","#{name} fore"
	getAngle:(value)->value*2 * Math.PI
