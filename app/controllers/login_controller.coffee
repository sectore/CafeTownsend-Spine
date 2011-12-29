
Spine = require 'spine'
$ = Spine.$

class LoginController extends Spine.Controller

	className: 'login'

	elements:
		'form': 'form'

	events:
		'submit form': 'login'



	constructor: ->
		super

		# handle global event using @proxy
		# to ensure executing in the correct context
		Spine.bind 'AppEvent:LOGOUT', @proxy( @logout )

		# bind active event to @render
		@active @render

	login: (event) ->
		event.preventDefault()

		@navigate '/employees'

	render: ->
		@html require 'views/login_view'

	logout: ->
		@navigate '/'

module.exports = LoginController