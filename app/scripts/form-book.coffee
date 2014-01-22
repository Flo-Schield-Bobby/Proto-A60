class BookLine

	date 								= null
	name 								= null
	link 								= null
	hasWokenUp							= null
	hasBeenGroomed						= null
	isShoppingDone						= null
	hasHadBreakfast						= null
	comments							= null

	constructor: (config) ->
		config = $.extend {
			'name': ''
			'link': ''
			'hasWokenUp': false
			'hasBeenGroomed': false
			'isShoppingDone': false
			'hasHadBreakfast': false
			'comments': ''
		}, config
		@date = new Date()
		@name = config.name
		@link = config.link
		@hasWokenUp = config.hasWokenUp
		@hasBeenGroomed = config.hasBeenGroomed
		@isShoppingDone = config.isShoppingDone
		@hasHadBreakfast = config.hasHadBreakfast
		@comments = config.comments
		return @

	save: (key) =>
		localStorage.setObject key, @
		@

	load: (key) =>
		data = localStorage.getObject key
		@date = data.date
		@name = data.name
		@link = data.link
		@hasWokenUp = data.hasWokenUp
		@hasBeenGroomed = data.hasBeenGroomed
		@isShoppingDone = data.isShoppingDone
		@hasHadBreakfast = data.hasHadBreakfast
		@comments = data.comments
		@

class FormBook

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
				console.log 'form new line submit'
				event.preventDefault()
				data = {
					'hasWokenUp': false
					'hasBeenGroomed': false
					'isShoppingDone': false
					'hasHadBreakfast': false
					'comments': ''
				}
				@formEl.find('input:checkbox').each () ->
					data[$(@).data('field-name')] = $(@).is ':checked'
				@formEl.find('input:text, textarea, select').each () ->
					data[$(@).data('field-name')] = $(@).val()
				bookLine = new BookLine {
					'name': 'Moi'
					'link': 'AD'
					'hasWokenUp': data.hasWokenUp
					'hasBeenGroomed': data.hasBeenGroomed
					'isShoppingDone': data.isShoppingDone
					'hasHadBreakfast': data.hasHadBreakfast
					'comments': data.comments
				}
				date = new Date()
				bookLine.save 'info-' + date.getTime()
				newLineEl = $ '<tr>', {
					'class': 'success'
				}
				col1 = $ '<a>', {
					'href': '#modal-info'
					'data-toggle': 'modal'
				}
				col1.html($('<p>').html($('<i>', {
					'class': 'glyphicon glyphicon-plus-sign'
				})))
				col2 = $ '<a>', {
					'href': '#modal-info'
					'data-toggle': 'modal'
				}
				col2.html($('<p>').html(bookLine.date.getDate() + '/' + bookLine.date.getMonth() + 1))
				col3 = $ '<a>', {
					'href': '#modal-info'
					'data-toggle': 'modal'
				}
				col3.html($('<p>').html(bookLine.name))
				col4 = $ '<a>', {
					'href': '#modal-info'
					'data-toggle': 'modal'
				}
				col4.html($('<p>').html(bookLine.link))
				newLineEl.append $('<td>').html(col1), $('<td>').html(col2), $('<td>').html(col3), $('<td>').html(col4)
				@listEl.append newLineEl
				$('#modal-new').modal 'hide'
				@
		}
		@

$ ->
	__form_book__ = new FormBook {
		'formElId': '#form-new-line'
		'listElId': '#history-list'
	}