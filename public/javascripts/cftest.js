(function() {
  var Foo;
  Ext.ns('squid');
  Foo = function() {};
  Foo.prototype.bar = function(x) {
    return x + 2;
  };
  squid.Foo = Foo;
})();
