class Loader

	progressBarEl 					= null

	constructor: (config) ->
		config = $.extend {
			'progressBarElId': ''
		}, config
		@progressBarEl = $ config.progressBarElId
		@init()
		return @

	init: () =>
		@launch()
		@

	launch: () =>
		@progressBarEl.addClass('complete').on 'transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd', (e) ->
			window.location.href = $(@).data('load')
		@

$ ->
	__loader__ = new Loader {
		'progressBarElId': '#progress-bar'
	}