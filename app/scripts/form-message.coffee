class Message

	date 								= null
	author 								= null
	message 							= null

	constructor: (config) ->
		config = $.extend {
			'author': ''
			'message': ''
		}, config
		@date = new Date()
		@author = config.author
		@message = config.message
		return @

	save: (key) =>
		localStorage.setObject key, @
		@

	load: (key) =>
		data = localStorage.getObject key
		@date = data.date
		@author = data.author
		@message = data.message
		@

class FormMessage

	formEl 							= null
	listEl 							= null

	constructor: (config) ->
		config = $.extend {
			'formElId': ''
			'listElId': ''
		}, config
		@formEl = $ config.formElId
		@listEl = $ config.listElId
		@bind()
		return @

	bind: () =>
		@formEl.on {
			'submit': (event) =>
				event.preventDefault()
				data = {
					'message': ''
				}
				@formEl.find('input:checkbox').each () ->
					data[$(@).data('field-name')] = $(@).is ':checked'
				@formEl.find('input:text, textarea, select').each () ->
					data[$(@).data('field-name')] = $(@).val()
				message = new Message {
					'author': 'Vous'
					'message': data.message
				}
				date = new Date()
				message.save 'message-' + date.getTime()
				containerEl = $ '<div>', {
					'class': 'row'
				}
				messageEl = $ '<div>', {
					'class': 'message row col-lg-6 col-lg-push-5 col-md-6 col-md-push-5 col-md-push-5 col-sm-6 col-sm-push-5'
				}
				figureEl = $ '<figure>', {
					'class': 'col-lg-4 col-md-4 col-sm-4 col-xs-4'
				}
				messageEl.append figureEl
				imgEl = $ '<img>', {
					'class': 'avatar img-rounded'
				}
				figureEl.append imgEl
				titleEl = $ '<h4>', {
					'class': 'message-title'
				}
				titleEl.html message.author
				messageEl.append titleEl
				dateEl = $ '<p>', {
					'class': 'message-date'
				}
				mins = parseInt((date.getTime() - message.date.getTime()) / 60000)
				dateEl.html 'Il y a ' + mins + ' min'
				messageEl.append dateEl
				textEl = $ '<p>', {
					'class': 'message-text'
				}
				textEl.html message.message
				messageEl.append textEl
				containerEl.append messageEl
				@listEl.append containerEl
				@
		}
		@

$ ->
	__form_message__ = new FormMessage {
		'formElId': '#form-message'
		'listElId': '#app-content'
	}