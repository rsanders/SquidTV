(function() {
  var FooChild;
  var __extends = function(child, parent) {
    var ctor = function(){};
    ctor.prototype = parent.prototype;
    child.prototype = new ctor();
    child.prototype.constructor = child;
    if (typeof parent.extended === "function") parent.extended(child);
    child.__super__ = parent.prototype;
  };
  FooChild = function() {
    var _a;
    _a = this;
    this.mybound = function(){ return FooChild.prototype.mybound.apply(_a, arguments); };
    this.local = 1;
    return this;
  };
  __extends(FooChild, squid.Foo);
  FooChild.prototype.baz = function() {
    return "this is baz result";
  };
  FooChild.prototype.mybound = function() {
    return (this.zimmy = 12);
  };
  FooChild.ham = 12;
  window.bar = new FooChild();
  alert("BAR is " + (window.bar.baz()) + ", ham is " + (FooChild.ham));
})();
