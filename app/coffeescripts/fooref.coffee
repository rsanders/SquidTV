class FooChild extends squid.Foo
  baz: -> "this is baz result"
  
  constructor: ->
    @local = 1

  mybound: =>
    @zimmy = 12
    
  @ham: 12

window.bar = new FooChild
alert "BAR is #{window.bar.baz()}, ham is #{FooChild.ham}"


