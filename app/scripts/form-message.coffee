class Message

    date                                = null
    author                              = null
    message                             = null

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

    formEl                          = null
    listEl                          = null

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

                # Message
                messageEl = $ '<div>', {
                    'class': 'message col-lg-6 col-lg-push-5 col-md-6 col-md-push-5 col-md-push-5 col-sm-6 col-sm-push-5'
                }

                # Header
                headerEl = $ '<div>', {
                    'class': 'row'
                }
                # Figure
                figureEl = $ '<figure>', {
                    'class': 'col-lg-3 col-md-2 col-sm-2 col-xs-3'
                }
                imgEl = $ '<img>', {
                    'class': 'avatar img-rounded'
                }
                figureEl.append imgEl
                headerEl.append figureEl

                # Header infos
                headerInfosEl = $ '<div>', {
                    'class': 'col-lg-9 col-md-10 col-sm-10 col-xs-9'
                }

                # Titre
                titleEl = $ '<h4>', {
                    'class': 'message-title'
                }
                titleEl.html message.author
                # Date
                dateEl = $ '<p>', {
                    'class': 'message-date'
                }
                mins = parseInt((date.getTime() - message.date.getTime()) / 60000)
                dateEl.html 'Il y a ' + mins + ' min'

                # Template...
                headerInfosEl.append titleEl
                headerInfosEl.append dateEl
                headerEl.append headerInfosEl
                messageEl.append headerEl

                # Text
                messageEl.append $('<hr>')
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