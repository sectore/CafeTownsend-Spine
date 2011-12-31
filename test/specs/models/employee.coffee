describe 'Employee', ->
  Employee = null
  
  beforeEach ->
    class Employee extends Spine.Model
      @configure 'Employee'
  
  it 'can noop', ->
    