Spine = require('spine')

class Employee extends Spine.Model
	@configure 'Employee', 'firstName', 'lastName', 'startDate', 'email'

module.exports = Employee