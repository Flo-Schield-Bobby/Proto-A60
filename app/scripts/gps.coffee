class GPS

	rootEl 						= null

	map 						= null
	zoom						= null

	constructor: (config) ->
		config = $.extend {
			'rootElId': ''
			'zoom': 15
		}, config
		@rootEl = $ config.rootElId
		@zoom = config.zoom
		@init()
		return @

	init: () =>
		if window.L
			@map = L.mapbox.map @rootEl.attr('id'), 'floschieldbobby.go9bj0m8'
			@navigateToCoords 49.4165, 2.8215, @zoom
			@bind()
		@

	bind: () =>
		$(window).on {
			'map.setview': (e, params) =>
				if typeof params == 'object' && params.lat && params.lng
					params.zoom = params.zoom || @zoom
					@navigateToCoords params.lat, params.lng, params.zoom
		}
		@

	navigateToCoords: (lat, lng, zoom) =>
		zoom = zoom || @zoom
		@map.setView [lat, lng], zoom
		@

$ ->
	__gps__ = new GPS {
		'rootElId': '#gps'
		'zoom': 16
	}