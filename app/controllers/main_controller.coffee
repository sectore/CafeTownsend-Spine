Spine = require 'spine'

HeaderController = require 'controllers/header_controller'
LoginController = require 'controllers/login_controller'
EmployeesController = require 'controllers/employees_controller'


class MainController extends Spine.Controller

	className: 'main'

	constructor: ->
		super

		@mainViewStack = new MainViewStack()
		@header = new HeaderController()

		###
			defining routes
		###
		@routes
			'/': ->
				@mainViewStack.login.active()
				@header.deactivate()
			'/employees': ->
				@mainViewStack.employees.active()
				@header.activate()


		@append @header, @mainViewStack


module.exports = MainController


class MainViewStack extends Spine.Stack

	className: 'stack'

	controllers:
		login: LoginController
		employees: EmployeesController

	default: 'login'