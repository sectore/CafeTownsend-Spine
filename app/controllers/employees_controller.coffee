require('lib/setup')

Spine = require 'spine'
List = require 'spine/lib/list'
Employee = require 'models/employee_model'


###
	MainController for employees
	It handles routes and shows its view stacks
	It handles EmployeeEvent's which are tiggered from other Controllers

###
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

		# handle global event using @proxy
		# to ensure executing the event handler in the correct context
		Spine.bind 'EmployeeEvent:DELETE', @proxy( @confirmDelete )


	###
		Override active method
		to bring overview back to front
		Because we can define one route handler for '/employee' only
		which is already in MainController defined before
	###
	active:(params) ->
		super params
		@employeeViewStack.overview.active()

	confirmDelete: (item) ->
		@delete(item) if confirm "Are you sure you want to delete #{ item.firstName } #{ item.lastName }?"

	delete:(item) ->
		item.destroy()
		@navigate '/employees'

module.exports = EmployeesController



###
	Controller to show a list of all employees.
	Selected employee can be deleted or changed.
	New employees can be added
###
class EmployeesOverview extends Spine.Controller

	className:
		'employees-overview'

	elements:
		'#employee-list': 'items'

	events:
		'click #bAdd': 'add'
		'click #bEdit': 'edit'
		'click #bDelete': 'delete'
		'dblclick .item': 'edit'

	constructor: ->
		super

		@mockEmployees()

		@html require('views/employees_overview')()

		@list = new List
			el: @items,
			template: require('views/employee_item')
			selectFirst: true

		@list.bind 'change', @change

		@active @render

		Employee.bind('refresh change', @render)

	change: (item) =>
		@item = item

	render: (params) =>
		employees = Employee.all()

		if employees.length <= 0
			delete @item
			@item = null

		@list.render(employees)

	edit: (event) ->
		if @item?
			@navigate '/employees', @item.id, 'edit'

	add: (event) ->
		item = Employee.create()
		item.save()
		@navigate '/employees', item.id, 'add'

	delete: ->
		if @item?
			Spine.trigger 'EmployeeEvent:DELETE', @item

	# mock data for initial employees
	mockEmployees: ->
		Employee.create { firstName: 'Sue', lastName: 'Hove', email: 'shove@cafetownsend.com', startDate: '01/07/2006' }
		Employee.create { firstName: 'Matt', lastName: 'Boles', email: 'mboles@cafetownsend.com', startDate: '02/17/2006' }
		Employee.create { firstName: 'Mike', lastName: 'Kollen', email: 'mkollen@cafetownsend.com', startDate: '03/01/2006' }
		Employee.create { firstName: 'Jennifer', lastName: 'Jaegel', email: 'jjaegel@cafetownsend.com', startDate: '04/01/2006' }


###
	Controller to add or edit (or delete) an employee
###
class EditEmployee extends Spine.Controller

	className:
		'employee-edit'

	elements:
		'form': 'form'

	events:
		'submit form': 'save'
		'click .bCancel': 'cancel'
		'click .bBack': 'back'
		'click .bDelete': 'delete'

	constructor: ->
		super
		@active @render


	render: (params) =>
		@item = Employee.find params.id
		data = { employee: @item, add: params.add, edit: params.edit }
		@html require('views/employee_edit_view')( data )

	delete: ->
		Spine.trigger 'EmployeeEvent:DELETE', @item

	cancel: (event) ->
		@item.destroy()
		@back()

	back: ->
		@navigate '/employees'

	save: (event) ->
		event.preventDefault()
		@item.fromForm(@form).save()
		@navigate '/employees'




###
	ViewStack of all employees-views (overview/edit/add)
###
class EmployeesViewStack extends Spine.Stack

	className:
		'stack'

	controllers:
		overview: EmployeesOverview
		editEmployee: EditEmployee
		addEmployee: EditEmployee

	default: 'overview'

