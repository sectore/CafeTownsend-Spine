require('lib/setup')

Spine = require 'spine'
List = require 'spine/lib/list'
Employee = require 'models/employee_model'



class EmployeesController extends Spine.Controller


	className:
		'employees'

	constructor: ->
		super

		@employeeViewStack = new EmployeesViewStack()

		@append @employeeViewStack

		###
			routes using by employeesViewStack
		###
		@routes
			'/employees/:id/add': (params) ->
				data = { id: params.id, add: true }
				@employeeViewStack.addEmployee.active( data )

			'/employees/:id/edit': (params) ->
				data = { id: params.id, edit: true }
				@employeeViewStack.editEmployee.active( data )


	###
		Override active method
		to bring overview back to front
		Because we can define one route handler for '/employee' only
		which is already in MainController defined before
	###
	active:(params) ->
		super params
		@employeeViewStack.overview.active()

module.exports = EmployeesController



class EmployeesOverview extends Spine.Controller

	className:
		'employees-overview'

	elements:
		'#employee-list': 'items'

	events:
		'click .bCancel': 'cancel'
		'click .bAdd': 'add'
		'click .item': 'edit'

	constructor: ->
		super

		@mockEmployees()

		@html require('views/employees_overview')()

		@list = new List
			el: @items,
			template: require('views/employee_item')

		@list.bind 'change', @change

		@active @render

		Employee.bind('refresh change', @render)

	change: (item) =>
		@item = item
		@navigate '/employees', @item.id, 'edit'


	render: (params) =>
		employees = Employee.all()
		@list.render(employees)

	cancel: (event) ->
		@navigate '/'

	edit: (event) ->
		@navigate '/employees', @item.id, 'edit'

	add: (event) ->
		item = Employee.create()
		item.save()
		@navigate '/employees', item.id, 'add'

	mockEmployees: ->
		Employee.create { firstName: 'Sue', lastName: 'Hove', email: 'shove@cafetownsend.com', startDate: '01/07/2006' }
		Employee.create { firstName: 'Matt', lastName: 'Boles', email: 'mboles@cafetownsend.com', startDate: '02/17/2006' }
		Employee.create { firstName: 'Mike', lastName: 'Kollen', email: 'mkollen@cafetownsend.com', startDate: '03/01/2006' }
		Employee.create { firstName: 'Jennifer', lastName: 'Jaegel', email: 'jjaegel@cafetownsend.com', startDate: '04/01/2006' }




class EditEmployee extends Spine.Controller

	className:
		'employee-edit'

	elements:
		'form': 'form'

	events:
		'submit form': 'save'
		'click .bCancel': 'cancel'
		'click .bDelete': 'confirmDelete'

	constructor: ->
		super
		@active @render


	render: (params) =>
		@item = Employee.find params.id
		data = { employee: @item, add: params.add, edit: params.edit }
		@html require('views/employee_edit_view')( data )

	confirmDelete: ->
		@delete() if confirm "Are you sure you want to delete #{ @item.firstName } #{ @item.lastName }?"

	delete: ->
		@item.destroy()
		@navigate '/employees'

	cancel: (event) ->
		@item.destroy()
		@navigate '/employees'

	save: (event) ->
		event.preventDefault()
		@item.fromForm(@form).save()
		@navigate '/employees'





class EmployeesViewStack extends Spine.Stack

	className:
		'stack'

	controllers:
		overview: EmployeesOverview
		editEmployee: EditEmployee
		addEmployee: EditEmployee

	default: 'overview'

