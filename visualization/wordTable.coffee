WordTable=
	maxKeywordAount:20;
	threeColumnWidths:null
	twoColumnWidths:null
	tableHeight: 200

	displayKeywordFunc:null

	init:->
		tableWidth = 1000;
		@threeColumnWidths = {width: tableWidth, pol:282,his:381,food:277}
		@twoColumnWidths = {width: tableWidth, pol:483,his:0,food:477}
		d3.select ".keywordTable"
			.style({height: "#{@tableHeight}px";})

	setColumns:(colNames)->
		colWidths = if colNames.length is 3 then @threeColumnWidths else @twoColumnWidths

		d3.select ".keywordTable"
			.style('width', "#{colWidths.width}px")

		row = d3.select ".keywordTable tr"
		row.selectAll "td"
			.remove()
		divs = row.selectAll "td"
			.data colNames
			.enter()
			.append "td"
			# .style 'width',(d)->"#{colWidths[d]}px"
			.append "div"
			.attr "id",(d)->"#{d}"
			.style 'width',(d)->"#{colWidths[d]}px"
			.style 'height',(d)->"#{WordTable.tableHeight}px"
			.append "p"
			.text("Click on a bar for its keywords")
			
			# .attr "id",(d)->"#{d}"
	clear:->
		d3.select ".keywordTable tr"
			.selectAll "td"
			.remove()
		d3.select ".keywordTable"
			.style({width: "0px",height: "0px";})

	clearKeywords:->
		row = d3.select ".keywordTable tr"
		row.selectAll "span"
			.remove()
	setKeywords:(setName,keywords)->
		

		row = d3.select ".keywordTable tr"
		targetP = row.select "##{setName} p"

		if keywords.length == 0
			targetP.text("No keywords")
			return;
		targetP
			.text("")
			

		keywordSpans = targetP.selectAll ".keyword"
		.data keywords
		.enter()
		.append "span"
		.attr "onclick",(d)->"showKeywordText('#{d.name}',#{d.year},'#{d.word}')"
		.attr "class",(d)->"#{d.class} keyword"
		.text (d)->d.word



		htmlText =  targetP.html();
		res = htmlText.replace(/></g,">\n<")
		targetP.html(res)					#after this the d3.on function won't work
		# targetP.selectAll "span.keyword"
		# .on "click",(d)->console.log(d3.select(this))
		# $('span.keyword').click (d)->console.log(d)
	# keywordMouseClicked:(e)->
	# 	console.log e
		targetP.selectAll ".keyword"
		.style "opacity",0
		.transition()
		.duration(500)
		.delay (d)->500*Math.random()
		.style "opacity",1

	displayOverlapKeywords:(name,set1,set2)->
		keywordsToShow = set1.concat(set2)
		keywordsToShow.sort (a,b)->
			if (a.class is name is b.class) or (!(a.class is name)and(name is b.class))
				b.freq-a.freq
			else 
				if a.class is name then 1 else -1
		keywordsToShow = keywordsToShow.slice(0,@maxKeywordAount)
		@setKeywords name,keywordsToShow

	displayKeywordsWithMedia: (name,yearData)->		
		docKeywords = yearData[name].kw.map (d)->{word:d.w,freq:d.f,class:name,year:yearData.no,name:name}
		mediaOverlapWords = yearData.news[name].kw.map (d)->{word:d.w,freq:d.f,class:"#{name} overlap",year:yearData.no,name:name}
		@displayOverlapKeywords(name,docKeywords,mediaOverlapWords)

	displayKeywordsOnlyDocument: (name,yearData)->
		docKeywords = yearData[name].kw.map (d)->{word:d.w,freq:d.f,class:name,year:yearData.no,name:name}
		historyOverlapWords = yearData.his.over[name].kw.map (d)->{word:d,freq:1,class:"his",year:yearData.no,name:name}
		@displayOverlapKeywords(name,docKeywords,historyOverlapWords)

	displayForMediaView:(yearno)->
		WordTable.setColumns(['pol','his','food'])
		WordTable.clearKeywords()
		WordTable.displayKeywordsWithMedia "pol",years[yearno]
		WordTable.displayKeywordsWithMedia "his",years[yearno]
		WordTable.displayKeywordsWithMedia "food",years[yearno]
	
	displayForDocView:(yearno)->
		WordTable.setColumns(['pol','food'])
		WordTable.clearKeywords()
		WordTable.displayKeywordsOnlyDocument "pol",years[yearno]
		WordTable.displayKeywordsOnlyDocument "food",years[yearno]


