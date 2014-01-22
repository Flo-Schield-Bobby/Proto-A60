class Timer

	$timerLabel = null
	timerId 	= null
	timer 		= 0

	# Callbacks
	callbacks 	= null

	constructor: (config) ->
		config = $.extend {
			'value': 0
			'timerLabelId': 'timer'
			'callbacks': {}
		}, config
		@timer = config.value
		@timerId = null
		@$timerLabel = $('#' + config.timerLabelId).first()
		@callbacks = config.callbacks
		@display()
		@launch()
		return @

	count: () =>
		@timer++
		@display()
		if @callbacks[@timer]
			if typeof @callbacks[@timer] == 'function'
				@callbacks[@timer].apply @
			if (typeof @callbacks[@timer] == 'object') && @callbacks[@timer].hasOwnProperty 'execute'
				@callbacks[@timer].execute.apply @, @callbacks[@timer].params
		@

	display: () =>
		mins = 1 + parseInt @timer / 60
		if mins < 10
			mins = '0' + mins
		hours = parseInt @timer / 3600
		if hours < 10
			hours = '0' + hours
		@$timerLabel.text hours + ':' + mins
		@

	launch: () =>
		@timerId = setInterval =>
			@count()
		, 1000
		@

	cancel: () =>
		clearInterval @timerId
		@timerId = null
		localStorage.setItem 'timer', 0
		@

	save: () =>
		localStorage.setItem 'timer', @timer
		@


$ ->
	__sounds__ = {
		'alert': new buzz.sound '/sounds/tic-tac', {
			formats: ['mp3', 'ogg', 'wav']
		}
	}
	__timer__ = new Timer {
		timerLabelId: 'app-timer',
		value: localStorage.getItem('timer') || 0
		callbacks: {
			60: {
				'params': [__sounds__],
				'execute': (sounds) ->
					sounds.alert.play()
			}
		}
	}
	$('a').on {
		'click': (e) ->
			if $(@).data('stop') == 'timer'
				__timer__.cancel()
			else
				__timer__.save()
	}