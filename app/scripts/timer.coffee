class Timer

	$timerLabel = null
	timerId 	= null
	timer 		= 0

	# Callbacks
	callbacks 	= null

	constructor: (config) ->
		config = $.extend {
			'timerLabelId': 'timer',
			'callbacks': {}
		}, config
		@timer = 0
		@timerId = null
		@$timerLabel = $('#' + config.timerLabelId).first()
		@callbacks = config.callbacks
		@launch()
		return @

	count: () =>
		@timer++;
		@display()
		if @callbacks[@timer]
			if typeof @callbacks[@timer] == 'function'
				@callbacks[@timer].apply(@)
			if (typeof @callbacks[@timer] == 'object') && @callbacks[@timer].hasOwnProperty 'execute'
				@callbacks[@timer].execute.apply(@, @callbacks[@timer].params)
		@

	display: () =>
		secs = @timer % 60
		if secs < 10
			secs = '0' + secs
		mins = parseInt @timer / 60
		if mins < 10
			mins = '0' + mins
		@$timerLabel.text mins + ':' + secs
		@

	launch: () =>
		@timerId = setInterval =>
			@count()
		, 1000
		@

	cancel: () =>
		clearInterval @timerId
		@timerId = null
		@


$ ->
	__sounds__ = {
		'alert': new buzz.sound '/sounds/tic-tac', {
			formats: ['mp3', 'ogg', 'wav']
		}
	}
	__timer__ = new Timer {
		timerLabelId: 'app-timer',
		callbacks: {
			15: {
				'params': [__sounds__],
				'execute': (sounds) ->
					sounds.alert.play()
			}
		}
	}