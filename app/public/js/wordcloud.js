
function create_cloud(data) {
		var fill = d3.scale.category20();

		d3.layout.cloud().size([700, 150])
		  .words(data.map(function(d) {
		    return {text: d[0], size: d[1]};
		  }))
		  .padding(5)
		  .rotate(function() { return ~~(Math.random() * 2) * 90; })
		  .font("Impact")
		  .fontSize(function(d) { return d.size; })
		  .on("end", draw)
		  .start();

	function draw(words) {
	  d3.select("#word-cloud").append("svg")
	    .attr("width", 700)
	    .attr("height", 150)
	  .append("g")
	    .attr("transform", "translate(250,85), scale(2.5, 2)")
	    .attr("width", 700)
	    .attr("height", 150)
	  .selectAll("text")
	    .data(words)
	  .enter().append("text")
	    .style("font-size", function(d) { return d.size + "px"; })
	    .style("font-family", "Impact")
	    .style("fill", function(d, i) { return fill(i); })
	    .attr("text-anchor", "middle")
	    .attr("transform", function(d) {

	      return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
	    })
	    .text(function(d) { return d.text; });
	}

	function drawUpdate(words){
	  d3.layout.cloud().size([700, 150])
	    .words(words)
	    .padding(5)
	    .rotate(function() { return ~~(Math.random() * 2) * 90; })
	    .font("Impact")
	    .fontSize(function(d) { return d.size; })
	    .start();

	  d3.select("svg")
	  .selectAll("g")
	    .attr("transform", "translate(250,85), scale(2.5, 2)")
	  .selectAll("text")
	    .data(words).enter().append("text")
	    .style("font-size", function(d) { return d.size + "px"; })
	    .style("font-family", "Impact")
	    .style("fill", function(d, i) { return fill(i); })

	    .attr("transform", function(d) {

	      return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
	    })
	    .text(function(d) { return d.text; });
	}
};
