class GPSSelector

	@listEl 						= null

	constructor: (config) ->
		config = $.extend {
			'listElId': '#'
		}, config
		@listEl = $ config.listElId
		@bind()
		return @

	bind: () =>
		console.log 'bind', @
		$('a', '#' + @listEl.attr('id')).on 'click', (e) ->
			$('.list-group-item.active').removeClass 'active'
			$(this).addClass 'active'
			e.preventDefault()
			$(window).trigger 'map.setview', {
				'lat': $(this).data 'coords-lat'
				'lng': $(this).data 'coords-lng'
				'address': $(this).data 'address'
			}
		@

$ ->
	__gps_selector__ = new GPSSelector {
		'listElId': '#addresses-selector'
	}