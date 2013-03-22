(function() {
  var DEFAULT_TAB_SIZE, TOKEN_PATTERN, T_DEINDENT, T_INDENT, T_ITEM, calculateIndentLevel, i, istr, itemToString, maybeGetJSON, parse, tokenize;

  istr = ((function() {
    var _i, _results;

    _results = [];
    for (i = _i = 0; _i < 10; i = ++_i) {
      _results.push('          ');
    }
    return _results;
  })()).join('          ');

  itemToString = function(item, level) {
    var c, value;

    if (level == null) {
      level = 0;
    }
    value = item.value != null ? JSON.stringify(item.value) : '';
    return "" + (istr.substring(0, level * 2)) + item.name + " " + value + "\n" + (((function() {
      var _i, _len, _ref, _results;

      _ref = item.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        _results.push(itemToString(c, level + 1));
      }
      return _results;
    })()).join(''));
  };

  maybeGetJSON = function(v, opts) {
    var error;

    if (v != null) {
      try {
        return eval("(" + v + ")");
      } catch (_error) {
        error = _error;
        return console.log("Invalid value: " + v);
      }
    }
  };

  calculateIndentLevel = function(indent, tabSize) {
    var res;

    res = 0;
    indent.replace(/( )|(\t)/g, function(all, s, t) {
      if (s != null) {
        return res++;
      } else if (t != null) {
        return res += tabSize;
      }
    });
    return res;
  };

  DEFAULT_TAB_SIZE = 4;

  TOKEN_PATTERN = /(?:(?:^|(?:\r|\n)+)([ \t]*))(\w+)(?:[ \t]+([^\r\n]*))?/g;

  T_INDENT = 1;

  T_DEINDENT = 2;

  T_ITEM = 3;

  tokenize = function(str, tabSize) {
    var level, levels, m, n, result;

    result = [];
    levels = [];
    level = 0;
    while ((m = TOKEN_PATTERN.exec(str)) != null) {
      n = calculateIndentLevel(m[1], tabSize);
      if (n > level) {
        levels.push(level);
        level = n;
        result.push({
          type: T_INDENT
        });
      } else if (n < level) {
        while (n < level) {
          result.push({
            type: T_DEINDENT
          });
          level = levels.pop();
        }
      }
      result.push({
        type: T_ITEM,
        name: m[2],
        value: maybeGetJSON(m[3])
      });
    }
    while (levels.length > 0) {
      levels.pop();
      result.push({
        type: T_DEINDENT
      });
    }
    return result;
  };

  parse = function(str, opts) {
    var item, parent, parents, s, _i, _len, _ref;

    if (opts == null) {
      opts = {};
    }
    parents = [];
    parent = {
      name: 'ROOT',
      value: '',
      children: []
    };
    _ref = tokenize(String(str), opts.tabSize || DEFAULT_TAB_SIZE);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      s = _ref[_i];
      switch (s.type) {
        case T_INDENT:
          parents.push(parent);
          parent = item;
          break;
        case T_DEINDENT:
          parent = parents.pop();
          break;
        case T_ITEM:
          item = {
            name: s.name,
            value: typeof s.value === 'function' ? s.value(opts) : s.value,
            children: []
          };
          parent.children.push(item);
          break;
        default:
          throw new Error('Invalid item type: ' + s.type);
      }
    }
    return parent.children;
  };

  module.exports = {
    parse: parse,
    tokenize: tokenize,
    itemToString: itemToString
  };

}).call(this);
