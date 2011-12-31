describe 'NavigationController', ->
  NavigationController = null
  
  beforeEach ->
    class NavigationController extends Spine.Controller
  
  it 'can noop', ->
    