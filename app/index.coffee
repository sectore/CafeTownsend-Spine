require('lib/setup')

Spine = require('spine')

MainController = require 'controllers/main_controller'

class App extends Spine.Controller

	constructor: ->
		super

		# initialize and append controller of MainView
		main = new MainController()
		@append main

		# setup routes
		Spine.Route.setup()
		# let's start routing to show login
		@navigate('/')

module.exports = App
    