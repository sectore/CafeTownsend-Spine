Spine = require('spine')

class User extends Spine.Model
	@configure 'User', 'username', 'password'
  
module.exports = User