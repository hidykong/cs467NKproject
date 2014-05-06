svg = d3.select "svg"
.attr "height","1000"
.attr "width","1000"
.append "g"
.attr "transform","translate(200,200)"

data1 = 
	[{innerRadius:100,
	outerRadius:130,
	startAngle: 0,
	endAngle: 3}]

data2 = 
	[{innerRadius:100,
	outerRadius:130,
	startAngle: 0,
	endAngle: 5}]

# startData = 
# 	innerRadius:100,
# 	outerRadius:130,
# 	startAngle: 0,
# 	endAngle: 0.1

arc = d3.svg.arc()

# slice = svg.selectAll ".slice"
# 	.data data1,(d)->1

# slice 
# 	.enter()
# 	.append "path"
# 	.attr "class","slice"
# 	.attr "d",(d)->arc(d)




tweenFunc = (d)->
	startData = {innerRadius:d.innerRadius,outerRadius:d.outerRadius,endAngle:0,startAngle:0}
	interpolate = d3.interpolate(startData,d);
	(t)->arc interpolate(t)	

slice = svg.append "path"
	.datum(data2[0])
	.transition()
	.duration 1000
	.attrTween "d",tweenFunc

slice.style "fill","red"
# slice
# .transition()
# .duration 1000
# .attrTween "d",(d)->
# 	@_current = @_current || d;
# 	interpolate = d3.interpolate(@_current,d);
# 	@_current = interpolate(0)
# 	(t)->arc interpolate(t)


changeSlice= ()->
	slice
	.datum data2[0]
	.transition()
	.duration 1000
	.attrTween "d",(d)->
		@_current = @_current || d;
		interpolate = d3.interpolate(@_current,d);
		@_current = interpolate(0)
		(t)->arc interpolate(t)	














