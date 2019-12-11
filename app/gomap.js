// When locator icon in datatable is clicked, go to that spot on the map
$(document).on("click", ".go-map", function(e) {
		e.preventDefault();
		$el = $(this);
		var lat = $el.data("lat");
		var lon = $el.data("lon");
		var address = $el.data("address");
		$($("#nav a")[0]).tab("show");
		Shiny.onInputChange("goto", {
				lat: lat,
				lon: lon,
				address: address
		});
});
