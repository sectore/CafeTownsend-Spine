describe 'AppController', ->
  AppController = null
  
  beforeEach ->
    class AppController extends Spine.Controller
  
  it 'can noop', ->
    