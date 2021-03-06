totalWidth = 1000
totalHeight = 1400
margin = {top: 40, right:100, left:100, bottom:20}

svgWidth = totalWidth - margin.left - margin.right;
svgHeight = totalHeight - margin.top - margin.bottom;

barWidth = 20
circleRadius = 5
barWidthMargin = 1
Alignment = {LEFT:1,CENTER:2,RIGHT:3}
yearTicksPadding = 20

ColumnMargin = {LEFT:0.05 * svgWidth,BETWEEN:0.02 * svgWidth,RIGHT:0.05 * svgWidth}
ColumnWidthCommon = (svgWidth - ColumnMargin.BETWEEN * 2- ColumnMargin.LEFT - ColumnMargin.RIGHT)/3;
ColumnWidth = {pol: ColumnWidthCommon*0.7, his: ColumnWidthCommon*1.6, food: ColumnWidthCommon*0.7}
ColumnX = {pol: ColumnMargin.LEFT + ColumnWidth.pol , his: ColumnMargin.LEFT + ColumnWidth.pol+ColumnMargin.BETWEEN+ColumnWidth.his/2, food: ColumnMargin.LEFT + ColumnWidth.pol+ColumnWidth.his+2*ColumnMargin.BETWEEN  }
ColumnAlignment = {pol: Alignment.RIGHT , his: Alignment.CENTER, food:Alignment.LEFT}


max_keyword_amount = 272

axisTranstionTime = 1000
