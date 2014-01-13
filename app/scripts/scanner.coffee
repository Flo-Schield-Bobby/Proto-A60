class Scanner

	videoRootEl 				= null
	canvasRootEl 				= null
	context 					= null
	data 						= null

	constraints					= null
	successCallback				= null
	errorCallback				= null

	constructor: (config) ->
		config = $.extend {
			'constraints': {
				'audio': false
				'video': true
			}
			'successCallback': () ->
			'errorCallback': () ->
			'videoRootElId': ''
			'canvasRootElId': ''
		}, config
		@videoRootEl = document.getElementById config.videoRootElId
		@constraints = config.constraints
		@successCallback = config.successCallback
		@errorCallback = config.errorCallback

		@canvasRootEl = document.getElementById config.canvasRootElId
		@context = @canvasRootEl.getContext '2d'
		@context.clearRect 0, 0, @canvasRootEl.width, @canvasRootEl.height;
		@data = @context.getImageData 0, 0, @canvasRootEl.width, @canvasRootEl.height
		qrcode.callback = (data) =>
			@analyse(data)
			@

		@scan()
		return @

	scan: () =>
		#console.log Modernizr
		#if Modernizr.getusermedia
			#console.log Modernizr.prefixed('getUserMedia', navigator)
			navigator.getMedia @constraints, (mediaStream) =>
				@display(mediaStream)
				@successCallback.apply(@, [mediaStream])
				setTimeout () =>
					@decode()
				, 500
			, (e) =>
				@errorCallback.apply()
		#else
			#console.log 'getUserMedia() required. Please update your browser.'
		@

	display: (mediaStream) =>
		@videoRootEl.src = window.URL.createObjectURL(mediaStream)
		@

	decode: () =>
		@context.drawImage @videoRootEl, 0, 0
		try
			qrcode.decode()
		catch e    
			console.log e
			setTimeout () =>
				@decode()
			, 500
		@

	analyse: (data) =>
		@

navigator.getMedia = (navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia)
qrcode = qrcode || {decode: () ->}

$ ->
	__scanner__ = new Scanner {
		'videoRootElId': 'camera-screen'
		'canvasRootElId': 'qr-code-canvas'
		'constraints': {
			'video': true
			'audio': false
		}
	}