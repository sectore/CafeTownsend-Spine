Spine = require('spine')
$ = Spine.$

User = require 'models/user_model'

###
	Controller for the header view
###
class HeaderController extends Spine.Controller

	# overridden
	tag:
		'header'

	events:
		'click p.main-button': 'triggerLogout'

	constructor: ->
		super
		@render()

	render: ->
		@html require('views/header_view')()


	activate:()->
		# we do only have one user object after login
		# grab it and show its username
		user = User.first()
		$('#greetings').text('Hello ' + user.username + "!")
		# animate header to show
		$('header div').animate({top: '0'})

	deactivate:->
		# empty greetings text
		$('#greetings').text('')
		# animate header to hide
		$('header div').animate({top: '50'})

	triggerLogout: ->
		@navigate '/logout'

    
module.exports = HeaderController