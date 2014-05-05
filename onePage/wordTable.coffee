WordTable=
	maxKeywordAount:20;
	threeColumnWidths:[pol:350,his:550,food:350]
	twoColumnWidths:[pol:550,his:0,food:550]
	displayKeywordFunc:null

	init:->

	setColumns:(colNames)->
		colWidths = if(colNames.length == 3) then @threeColumnWidths else @twoColumnWidths

		row = d3.select ".keywordTable tr"
		row.selectAll "td"
			.remove()
		row.selectAll "td"
			.data colNames
			.enter()
			.append "td"
			.append "div"
			.append "p"
			.style "width",(d)->"#{colWidths[d]}px"
			.attr "id",(d)->"#{d}"
	clear:->
		d3.select ".keywordTable tr"
			.selectAll "td"
			.remove()
	clearKeywords:->
		row = d3.select ".keywordTable tr"
		row.selectAll "span"
			.remove()
	setKeywords:(setName,keywords)->
		

		row = d3.select ".keywordTable tr"
		targetP = row.select "##{setName}"
		targetP.selectAll ".keyword"
		.data keywords
		.enter()
		.append "span"
		.attr "class",(d)->d.class
		.text (d)->d.word

		htmlText =  targetP.html();
		res = htmlText.replace(/></g,"> <")
		targetP.html(res);
	
	displayOverlapKeywords:(name,set1,set2)->
		keywordsToShow = set1.concat(set2)
		keywordsToShow.sort (a,b)->
			if (a.class is name is b.class) or (!(a.class is name)and(name is b.class))
				b.freq-a.freq
			else 
				if a.class is name then 1 else -1
		console.log keywordsToShow
		keywordsToShow = keywordsToShow.slice(0,@maxKeywordAount)
		@setKeywords name,keywordsToShow

	displayKeywordsWithMedia: (name,yearData)->		
		docKeywords = yearData[name].kw.map (d)->{word:d.w,freq:d.f,class:name}
		mediaOverlapWords = yearData.news[name].kw.map (d)->{word:d.w,freq:d.f,class:"#{name} overlap"}
		@displayOverlapKeywords(name,docKeywords,mediaOverlapWords)

	displayKeywordsOnlyDocument: (name,yearData)->
		docKeywords = yearData[name].kw.map (d)->{word:d.w,freq:d.f,class:name}
		historyOverlapWords = yearData.his.over[name].kw.map (d)->{word:d,freq:1,class:"his"}
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


