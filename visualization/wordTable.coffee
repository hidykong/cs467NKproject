WordTable=
	maxKeywordAount:20;
	init:->

		row = d3.select ".keywordTable tr"

		row.selectAll "td"
			.remove()

		colNames = ['pol','his','food']
		row.selectAll "td"
			.data colNames
			.enter()
			.append "td"
			.append "div"
			.append "p"
			.attr "id",(d)->"#{d}"

		name = 'pol'
		keywords = [
			{word:"Lorem",class:"his"},
			{word:"ipsum",class:"his"},
			{word:"dolor",class:"his overlap"},
			{word:"sit",class:"his"},
			{word:"amet",class:"pol"},
			{word:"insolens",class:"his"},
			{word:"mediocrem",class:"his"},
			{word:"aliquando",class:"his"},
			{word:"has",class:"pol"},
			{word:"ea",class:"his"},
			{word:"mel",class:"pol"},
			{word:"ad",class:"his"},
			{word:"dolore",class:"his"},
			{word:"i",class:"his"}
		]
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
		keywordsToShow.sort (a,b)->b.freq-a.freq
		keywordsToShow = keywordsToShow.slice(0,@maxKeywordAount)
		@setKeywords name,keywordsToShow

	displayKeywordsWithMedia: (name,yearData)->
		
		docKeywords = yearData[name].kw.map (d)->{word:d.w,freq:d.f,class:name}
		mediaOverlapWords = yearData.news[name].kw.map (d)->{word:d.w,freq:d.f,class:"#{name} overlap"}
		@displayOverlapKeywords(name,docKeywords,mediaOverlapWords)

