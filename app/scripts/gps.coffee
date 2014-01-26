class GPS

	rootEl 						= null

	map 						= null
	layer						= null
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
			@navigateToCoords 49.4106139, 2.8172449, @zoom
			@layer = L.mapbox.markerLayer({
				type: 'Feature'
				geometry: {
					type: 'Point'
					coordinates: [2.8172449, 49.4106139]
				}
				properties: {
					title: 'Addresse'
					description: '32 bd des Etats-Unis'
					'marker-size': 'large'
					'marker-color': '#2c3e50'
				}
			}).addTo(@map)
			@bind()
		@

	bind: () =>
		$(window).on {
			'map.setview': (e, params) =>
				if typeof params == 'object' && params.lat && params.lng
					params.zoom = params.zoom || @zoom
					@navigateToCoords params.lat, params.lng, params.zoom

					if @layer
						@map.removeLayer @layer

					@layer = L.mapbox.markerLayer({
						type: 'Feature'
						geometry: {
							type: 'Point'
							coordinates: [params.lng, params.lat]
						}
						properties: {
							title: 'Addresse'
							description: params.address
							'marker-size': 'large'
							'marker-color': '#2c3e50'
						}
					}).addTo(@map)
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