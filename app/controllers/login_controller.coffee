
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

		###
			defining routes
		###
		@routes
				'/logout': ->
					@logout()

		# bind active event to @render
		@active @render

	render: ->
		@html require 'views/login_view'


	login: (event) ->
		event.preventDefault()

		#create user
		item = User.create()
		# and save its login data
		item.fromForm(@form).save()
		# Note: For the sake of this demo we right jump into employees list
		# without any server side validation of user data
		@navigate '/employees'


	logout: ->
		# clear user data
		User.destroyAll()
		# navigate back to '/'
		@navigate '/'

module.exports = LoginController