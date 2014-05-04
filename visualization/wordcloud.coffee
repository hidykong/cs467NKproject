WordCloud =
	targetSVG: null 
	totalWidth : 500
	totalHeight : 300
	margin : {top: 20, right:10, left:10, bottom:20}
	svgWidth : 0
	svgHeight : 0
	init:()->
		@svgWidth = @totalWidth - @margin.left - @margin.right
		@svgHeight = @totalHeight - @margin.top - @margin.bottom
		
		d3.selectAll ".wordCloudSVG"
			.attr "height",@totalHeight
			.attr "width", @totalWidth
			.append "g"
			.attr "transform","translate(#{@margin.left+@svgWidth/2},#{@margin.top+@svgHeight/2})"

		# keywords = ["Lorem","ipsum","dolor","sit","amet,","et","melius","animal","pri.","Usu","at","libris","debitis","signiferumque.","Duo","eu","persecuti","scribentur,","at","illum","recteque","vix.","His","ei","enim","rebum."]
		
		# wordsToDraw = keywords.map (d)->{text:d.w,size:10*d.f}
		# @drawWordCloud @targetSVG,wordsToDraw, svgWidth,svgHeight

	draw: (words)->
		WordCloud.targetSVG
			.selectAll "text"
			.data words
			.enter()
			.append "text"
			.attr "class","wordCloudText"
			.style "font-size",(d)->"#{d.size}px"
			.attr "transform",(d)->"translate(#{d.x},#{d.y})"
			.text (d)->d.text
		
	drawWordCloud: (group,keywords, width,height)->
		if group?
			@targetSVG = group
		else
			console.log "Error: group == null"
			return;

		@targetSVG.selectAll "text"
			.remove();

		if keywords.length > 0
			wordsToDraw = keywords.map (d)->{text:d.w,size:15 + 5*d.f}
		else
			wordsToDraw = [{text:"No keywords", size: 20}]

		d3.layout.cloud()
		.size [width,height]
		.words wordsToDraw
		.padding 5
		.rotate 0
		.font "PT Sans"
		.fontSize (d)->d.size
		.on "end", @draw
		.start()

	drawKeywords: (name,keywords)->
		target = d3.select("##{name}SVG")
			.select "g"
			.attr "class",name

		@drawWordCloud target,keywords,@svgWidth,@svgHeight

	
