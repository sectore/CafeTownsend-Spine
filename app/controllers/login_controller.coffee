
Spine = require 'spine'
$ = Spine.$

User = require 'models/user_model'

###
	Controller to login / logout an user
###
class LoginController extends Spine.Controller

	className: 'login'

	elements:
		'form': 'form'

	events:
		'submit form': 'login'


	constructor: ->
		super

		# handle global event using @proxy
		# to ensure executing the event handler in the correct context
		Spine.bind 'AppEvent:LOGOUT', @proxy( @logout )

		# bind active event to @render
		@active @render

	login: (event) ->
		event.preventDefault()

		#create user
		item = User.create()
		# and save its login data
		item.fromForm(@form).save()
		# Note: For the sake of this demo we right jump into employees list
		# without any server side validation of user data
		@navigate '/employees'

	render: ->
		@html require 'views/login_view'

	logout: ->
		@navigate '/'

module.exports = LoginController