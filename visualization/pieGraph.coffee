PieGraph =
	centerR:{in:0,out:90}
	objectiveR:{in:90,out:100}
	historyR:{in:100,out:120}
	mediaR:{in:120,out:140}
	init:->
		pieGraph = d3.select ".pieGraph"
			.append "g"
			.attr "transform","translate(500,1600)"

		data = {
		"subjective": 0.57,
		"objective": 0.43,
		"history": 0.7,
		"media": 0.752
		}


		

		@createSection(pieGraph,"objective",data)
		@createSection(pieGraph,"history",data)
		@createSection(pieGraph,"media",data)
		@createSection(pieGraph,"center")

	createDatum:(name,endAngle)->
		{
			innerRadius:PieGraph["#{name}R"].in
			outerRadius:PieGraph["#{name}R"].out
			startAngle: 0
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
				.datum @createDatum(name,data[name]*2 * Math.PI)
				.attr "d",arc		
				.attr "class","#{name} fore"
