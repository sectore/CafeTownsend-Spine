describe 'EmployeeController', ->
  EmployeeController = null
  
  beforeEach ->
    class EmployeeController extends Spine.Controller
  
  it 'can noop', ->
    