Spine = require('spine')
$ = Spine.$

class HeaderController extends Spine.Controller

	className:
		'header'

	events:
		'click #bLogout': 'triggerLogout'

	constructor: ->
		super
		@render()

	render: ->
		@html require('views/header_view')()


	activate:->
		$('.header').show()

	deactivate:->
		$('.header').hide()


	triggerLogout: ->
		Spine.trigger 'AppEvent:LOGOUT'


    
module.exports = HeaderController