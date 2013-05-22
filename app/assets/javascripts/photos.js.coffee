# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	if navigator.geolocation
		button = $("#geo-magic")
		button.removeClass("hidden").on "click", ->
			navigator.geolocation.getCurrentPosition ({coords}) ->
				[lat, long] = [coords.latitude, coords.longitude]
				pos_string = "#{lat.toFixed 3}, #{long.toFixed 3}"
				button.html("You're tagged at #{pos_string}")
				button.attr 'disabled', true
				$("#photo_geo").val pos_string
			return false