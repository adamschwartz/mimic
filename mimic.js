(function() {
  var Mimic, MutationObserver, defaults, insertAfter, insertBefore, outerHTML;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
  insertBefore = function(referenceNode, newNode) {
    return referenceNode.parentNode.insertBefore(newNode, referenceNode);
  };
  insertAfter = function(referenceNode, newNode) {
    return referenceNode.parentNode.insertBefore(newNode, referenceNode.nextSibling);
  };
  outerHTML = function(node) {
    var outer;
    outer = document.createElement('div');
    outer.appendChild(node);
    return outer.innerHTML;
  };
  if (MutationObserver == null) {
    return;
  }
  defaults = {
    placement: 'after',
    className: 'mimic-outer'
  };
  Mimic = (function() {
    function Mimic(options) {
      var k, v;
      this.options = options;
      this.el = this.options.el;
      if (this.el.mimic != null) {
        return this.el.mimic;
      }
      this.el.mimic = this;
      for (k in defaults) {
        v = defaults[k];
        if (!(this.options[k] != null)) {
          this.options[k] = v;
        }
      }
      this.insert();
      this.render();
      this.mimic();
      this;
    }
    Mimic.prototype.insert = function() {
      this.mimicEl = document.createElement('div');
      this.mimicEl.className = this.options.className;
      if (this.options.placement === 'after') {
        return insertAfter(this.el, this.mimicEl);
      } else if (this.options.placement === 'before') {
        return insertBefore(this.el, this.mimicEl);
      } else {
        return document.querySelector(this.options.placement).appendChild(this.mimicEl);
      }
    };
    Mimic.prototype.render = function() {
      return this.mimicEl.innerHTML = outerHTML(this.el.cloneNode(true));
    };
    Mimic.prototype.mimic = function() {
      var _ref;
      try {
        if ((_ref = this.observer) == null) {
          this.observer = new MutationObserver(__bind(function(mutations) {
            return this.render();
          }, this));
        }
        return this.observer.observe(this.el, {
          childList: true,
          attributes: true,
          characterData: true,
          subtree: true
        });
      } catch (e) {

      }
    };
    Mimic.prototype.stop = function() {
      var _ref;
      return (_ref = this.observer) != null ? _ref.disconnect() : void 0;
    };
    return Mimic;
  })();
  window.Mimic = Mimic;
}).call(this);
