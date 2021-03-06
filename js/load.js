// Generated by CoffeeScript 1.7.1
(function() {
  'use strict';
  var Loader, loadAll;

  Loader = (function() {
    function Loader() {
      this.queued = 0;
      this.waiting = [];
    }

    Loader.prototype.queue = function(loadable) {
      this.queued++;
      return loadable.load((function(_this) {
        return function() {
          var callback, _i, _len, _ref;
          _this.queued--;
          if (_this.queued === 0) {
            _ref = _this.waiting;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              callback = _ref[_i];
              callback();
            }
            return _this.waiting = [];
          }
        };
      })(this));
    };

    Loader.prototype.image = function(url) {
      var img;
      img = new Image();
      this.queue($(img));
      img.src = url;
      return img;
    };

    Loader.prototype.afterLoad = function(callback) {
      if (this.queued === 0) {
        return setTimeout(callback, 0);
      } else {
        return this.waiting.push(callback);
      }
    };

    return Loader;

  })();

  loadAll = function(loadables, callback) {
    var loader, x, _i, _len;
    loader = new Loader;
    for (_i = 0, _len = loadables.length; _i < _len; _i++) {
      x = loadables[_i];
      loader.queue(x);
    }
    return loader.afterLoad(callback);
  };

  window.Loader = Loader;

  window.loadAll = loadAll;

}).call(this);
