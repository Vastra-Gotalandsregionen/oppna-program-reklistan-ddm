<script>
/*
    Swag v0.6.1 <http://elving.github.com/swag/>
    Copyright 2012 Elving Rodriguez <http://elving.me/>
    Available under MIT license <https://raw.github.com/elving/swag/master/LICENSE>
*/


(function() {
  var Dates, HTML, Swag, Utils,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  if (typeof window !== "undefined" && window !== null) {
    window.Swag = Swag = {};
  } else if (typeof module !== "undefined" && module !== null) {
    module.exports = Swag = {};
  }

  Swag.helpers = {};

  Swag.addHelper = function(name, helper, argTypes) {
    if (argTypes == null) {
      argTypes = [];
    }
    if (!(argTypes instanceof Array)) {
      argTypes = [argTypes];
    }
    return Swag.helpers[name] = function() {
      var arg, args, resultArgs, _i, _len;
      Utils.verify(name, arguments, argTypes);
      args = Array.prototype.slice.apply(arguments);
      resultArgs = [];
      for (_i = 0, _len = args.length; _i < _len; _i++) {
        arg = args[_i];
        if (!Utils.isHandlebarsSpecific(arg)) {
          arg = Utils.result(arg);
        }
        resultArgs.push(arg);
      }
      return helper.apply(this, resultArgs);
    };
  };

  Swag.registerHelpers = function(localHandlebars) {
    var helper, name, _ref, _results;
    if (localHandlebars) {
      Swag.Handlebars = localHandlebars;
    } else {
      if (typeof window !== "undefined" && window !== null) {
        if (window.Ember != null) {
          Swag.Handlebars = Ember.Handlebars;
        } else {
          Swag.Handlebars = window.Handlebars;
        }
      } else if (typeof module !== "undefined" && module !== null) {
        Swag.Handlebars = require('handlebars');
      }
    }
    Swag.registerHelper = function(name, helper) {
      if ((typeof window !== "undefined" && window !== null) && window.Ember) {
        return Swag.Handlebars.helper(name, helper);
      } else {
        return Swag.Handlebars.registerHelper(name, helper);
      }
    };
    _ref = Swag.helpers;
    _results = [];
    for (name in _ref) {
      helper = _ref[name];
      _results.push(Swag.registerHelper(name, helper));
    }
    return _results;
  };

  Swag.Config = {
    partialsPath: '',
    precompiledTemplates: true
  };

  Utils = {};

  Utils.isHandlebarsSpecific = function(value) {
    return (value && (value.fn != null)) || (value && (value.hash != null));
  };

  Utils.isUndefined = function(value) {
    return (value === void 0 || value === null) || Utils.isHandlebarsSpecific(value);
  };

  Utils.safeString = function(str) {
    return new Swag.Handlebars.SafeString(str);
  };

  Utils.trim = function(str) {
    var trim;
    trim = /\S/.test("\xA0") ? /^[\s\xA0]+|[\s\xA0]+$/g : /^\s+|\s+$/g;
    return str.toString().replace(trim, '');
  };

  Utils.isFunc = function(value) {
    return typeof value === 'function';
  };

  Utils.isString = function(value) {
    return typeof value === 'string';
  };

  Utils.result = function(value) {
    if (Utils.isFunc(value)) {
      return value();
    } else {
      return value;
    }
  };

  Utils.err = function(msg) {
    throw new Error(msg);
  };

  Utils.verify = function(name, fnArg, argTypes) {
    var arg, i, msg, _i, _len, _results;
    if (argTypes == null) {
      argTypes = [];
    }
    fnArg = Array.prototype.slice.apply(fnArg).slice(0, argTypes.length);
    _results = [];
    for (i = _i = 0, _len = fnArg.length; _i < _len; i = ++_i) {
      arg = fnArg[i];
      msg = '{{' + name + '}} requires ' + argTypes.length + ' arguments ' + argTypes.join(', ') + '.';
      if (argTypes[i].indexOf('safe:') > -1) {
        if (Utils.isHandlebarsSpecific(arg)) {
          _results.push(Utils.err(msg));
        } else {
          _results.push(void 0);
        }
      } else {
        if (Utils.isUndefined(arg)) {
          _results.push(Utils.err(msg));
        } else {
          _results.push(void 0);
        }
      }
    }
    return _results;
  };

  Swag.addHelper('lowercase', function(str) {
    return str.toLowerCase();
  }, 'string');

  Swag.addHelper('uppercase', function(str) {
    return str.toUpperCase();
  }, 'string');

  Swag.addHelper('capitalizeFirst', function(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
  }, 'string');

  Swag.addHelper('capitalizeEach', function(str) {
    return str.replace(/\w\S*/g, function(txt) {
      return txt.charAt(0).toUpperCase() + txt.substr(1);
    });
  }, 'string');

  Swag.addHelper('titleize', function(str) {
    var capitalize, title, word, words;
    title = str.replace(/[ \-_]+/g, ' ');
    words = title.match(/\w+/g) || [];
    capitalize = function(word) {
      return word.charAt(0).toUpperCase() + word.slice(1);
    };
    return ((function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = words.length; _i < _len; _i++) {
        word = words[_i];
        _results.push(capitalize(word));
      }
      return _results;
    })()).join(' ');
  }, 'string');

  Swag.addHelper('sentence', function(str) {
    return str.replace(/((?:\S[^\.\?\!]*)[\.\?\!]*)/g, function(txt) {
      return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
    });
  }, 'string');

  Swag.addHelper('reverse', function(str) {
    return str.split('').reverse().join('');
  }, 'string');

  Swag.addHelper('truncate', function(str, length, omission) {
    if (Utils.isUndefined(omission)) {
      omission = '';
    }
    if (str.length > length) {
      return str.substring(0, length - omission.length) + omission;
    } else {
      return str;
    }
  }, ['string', 'number']);

  Swag.addHelper('center', function(str, spaces) {
    var i, space;
    spaces = Utils.result(spaces);
    space = '';
    i = 0;
    while (i < spaces) {
      space += '&nbsp;';
      i++;
    }
    return "" + space + str + space;
  }, 'string');

  Swag.addHelper('newLineToBr', function(str) {
    return str.replace(/\r?\n|\r/g, '<br>');
  }, 'string');

  Swag.addHelper('sanitize', function(str, replaceWith) {
    if (Utils.isUndefined(replaceWith)) {
      replaceWith = '-';
    }
    return str.replace(/[^a-z0-9]/gi, replaceWith);
  }, 'string');

  Swag.addHelper('first', function(array, count) {
    if (!Utils.isUndefined(count)) {
      count = parseFloat(count);
    }
    if (Utils.isUndefined(count)) {
      return array[0];
    } else {
      return array.slice(0, count);
    }
  }, 'array');

  Swag.addHelper('withFirst', function(array, count, options) {
    var item, result;
    if (!Utils.isUndefined(count)) {
      count = parseFloat(count);
    }
    if (Utils.isUndefined(count)) {
      options = count;
      return options.fn(array[0]);
    } else {
      array = array.slice(0, count);
      result = '';
      for (item in array) {
        result += options.fn(array[item]);
      }
      return result;
    }
  }, 'array');

  Swag.addHelper('last', function(array, count) {
    if (!Utils.isUndefined(count)) {
      count = parseFloat(count);
    }
    if (Utils.isUndefined(count)) {
      return array[array.length - 1];
    } else {
      return array.slice(-count);
    }
  }, 'array');

  Swag.addHelper('withLast', function(array, count, options) {
    var item, result;
    if (!Utils.isUndefined(count)) {
      count = parseFloat(count);
    }
    if (Utils.isUndefined(count)) {
      options = count;
      return options.fn(array[array.length - 1]);
    } else {
      array = array.slice(-count);
      result = '';
      for (item in array) {
        result += options.fn(array[item]);
      }
      return result;
    }
  }, 'array');

  Swag.addHelper('after', function(array, count) {
    if (!Utils.isUndefined(count)) {
      count = parseFloat(count);
    }
    return array.slice(count);
  }, ['array', 'number']);

  Swag.addHelper('withAfter', function(array, count, options) {
    var item, result;
    if (!Utils.isUndefined(count)) {
      count = parseFloat(count);
    }
    array = array.slice(count);
    result = '';
    for (item in array) {
      result += options.fn(array[item]);
    }
    return result;
  }, ['array', 'number']);

  Swag.addHelper('before', function(array, count) {
    if (!Utils.isUndefined(count)) {
      count = parseFloat(count);
    }
    return array.slice(0, -count);
  }, ['array', 'number']);

  Swag.addHelper('withBefore', function(array, count, options) {
    var item, result;
    if (!Utils.isUndefined(count)) {
      count = parseFloat(count);
    }
    array = array.slice(0, -count);
    result = '';
    for (item in array) {
      result += options.fn(array[item]);
    }
    return result;
  }, ['array', 'number']);

  Swag.addHelper('join', function(array, separator) {
    return array.join(Utils.isUndefined(separator) ? ' ' : separator);
  }, 'array');

  Swag.addHelper('sort', function(array, field) {
    if (Utils.isUndefined(field)) {
      return array.sort();
    } else {
      return array.sort(function(a, b) {
        return a[field] > b[field];
      });
    }
  }, 'array');

  Swag.addHelper('withSort', function(array, field, options) {
    var item, result, _i, _len;
    result = '';
    if (Utils.isUndefined(field)) {
      options = field;
      array = array.sort();
      for (_i = 0, _len = array.length; _i < _len; _i++) {
        item = array[_i];
        result += options.fn(item);
      }
    } else {
      array = array.sort(function(a, b) {
        return a[field] > b[field];
      });
      for (item in array) {
        result += options.fn(array[item]);
      }
    }
    return result;
  }, 'array');

  Swag.addHelper('length', function(array) {
    return array.length;
  }, 'array');

  Swag.addHelper('lengthEqual', function(array, length, options) {
    if (!Utils.isUndefined(length)) {
      length = parseFloat(length);
    }
    if (array.length === length) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  }, ['array', 'number']);

  Swag.addHelper('empty', function(array, options) {
    if (!array || array.length <= 0) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  }, 'safe:array');

  Swag.addHelper('any', function(array, options) {
    if (array && array.length > 0) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  }, 'safe:array');

  Swag.addHelper('inArray', function(array, value, options) {
    if (__indexOf.call(array, value) >= 0) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  }, ['array', 'string|number']);

  Swag.addHelper('eachIndex', function(array, options) {
    var index, result, value, _i, _len;
    result = '';
    for (index = _i = 0, _len = array.length; _i < _len; index = ++_i) {
      value = array[index];
      result += options.fn({
        item: value,
        index: index
      });
    }
    return result;
  }, 'array');

  Swag.addHelper('eachProperty', function(obj, options) {
    var key, result, value;
    result = '';
    for (key in obj) {
      value = obj[key];
      result += options.fn({
        key: key,
        value: value
      });
    }
    return result;
  }, 'object');

  Swag.addHelper('add', function(value, addition) {
    value = parseFloat(value);
    addition = parseFloat(addition);
    return value + addition;
  }, ['number', 'number']);

  Swag.addHelper('subtract', function(value, substraction) {
    value = parseFloat(value);
    substraction = parseFloat(substraction);
    return value - substraction;
  }, ['number', 'number']);

  Swag.addHelper('divide', function(value, divisor) {
    value = parseFloat(value);
    divisor = parseFloat(divisor);
    return value / divisor;
  }, ['number', 'number']);

  Swag.addHelper('multiply', function(value, multiplier) {
    value = parseFloat(value);
    multiplier = parseFloat(multiplier);
    return value * multiplier;
  }, ['number', 'number']);

  Swag.addHelper('floor', function(value) {
    value = parseFloat(value);
    return Math.floor(value);
  }, 'number');

  Swag.addHelper('ceil', function(value) {
    value = parseFloat(value);
    return Math.ceil(value);
  }, 'number');

  Swag.addHelper('round', function(value) {
    value = parseFloat(value);
    return Math.round(value);
  }, 'number');

  Swag.addHelper('toFixed', function(number, digits) {
    number = parseFloat(number);
    digits = Utils.isUndefined(digits) ? 0 : digits;
    return number.toFixed(digits);
  }, 'number');

  Swag.addHelper('toPrecision', function(number, precision) {
    number = parseFloat(number);
    precision = Utils.isUndefined(precision) ? 1 : precision;
    return number.toPrecision(precision);
  }, 'number');

  Swag.addHelper('toExponential', function(number, fractions) {
    number = parseFloat(number);
    fractions = Utils.isUndefined(fractions) ? 0 : fractions;
    return number.toExponential(fractions);
  }, 'number');

  Swag.addHelper('toInt', function(number) {
    return parseInt(number, 10);
  }, 'number');

  Swag.addHelper('toFloat', function(number) {
    return parseFloat(number);
  }, 'number');

  Swag.addHelper('digitGrouping', function(number, separator) {
    number = parseFloat(number);
    separator = Utils.isUndefined(separator) ? ',' : separator;
    return number.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1" + separator);
  }, 'number');

  Swag.addHelper('is', function(value, test, options) {
    if (value && value === test) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  }, ['safe:string|number', 'safe:string|number']);

  Swag.addHelper('isnt', function(value, test, options) {
    if (!value || value !== test) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  }, ['safe:string|number', 'safe:string|number']);

  Swag.addHelper('gt', function(value, test, options) {
    if (value > test) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  }, ['safe:string|number', 'safe:string|number']);

  Swag.addHelper('gte', function(value, test, options) {
    if (value >= test) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  }, ['safe:string|number', 'safe:string|number']);

  Swag.addHelper('lt', function(value, test, options) {
    if (value < test) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  }, ['safe:string|number', 'safe:string|number']);

  Swag.addHelper('lte', function(value, test, options) {
    if (value <= test) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  }, ['safe:string|number', 'safe:string|number']);

  Swag.addHelper('or', function(testA, testB, options) {
    if (testA || testB) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  }, ['safe:string|number', 'safe:string|number']);

  Swag.addHelper('and', function(testA, testB, options) {
    if (testA && testB) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  }, ['safe:string|number', 'safe:string|number']);

  Dates = {};

  Dates.padNumber = function(num, count, padCharacter) {
    var lenDiff, padding;
    if (typeof padCharacter === 'undefined') {
      padCharacter = '0';
    }
    lenDiff = count - String(num).length;
    padding = '';
    if (lenDiff > 0) {
      while (lenDiff--) {
        padding += padCharacter;
      }
    }
    return padding + num;
  };

  Dates.dayOfYear = function(date) {
    var oneJan;
    oneJan = new Date(date.getFullYear(), 0, 1);
    return Math.ceil((date - oneJan) / 86400000);
  };

  Dates.weekOfYear = function(date) {
    var oneJan;
    oneJan = new Date(date.getFullYear(), 0, 1);
    return Math.ceil((((date - oneJan) / 86400000) + oneJan.getDay() + 1) / 7);
  };

  Dates.isoWeekOfYear = function(date) {
    var dayDiff, dayNr, jan4, target;
    target = new Date(date.valueOf());
    dayNr = (date.getDay() + 6) % 7;
    target.setDate(target.getDate() - dayNr + 3);
    jan4 = new Date(target.getFullYear(), 0, 4);
    dayDiff = (target - jan4) / 86400000;
    return 1 + Math.ceil(dayDiff / 7);
  };

  Dates.tweleveHour = function(date) {
    if (date.getHours() > 12) {
      return date.getHours() - 12;
    } else {
      return date.getHours();
    }
  };

  Dates.timeZoneOffset = function(date) {
    var hoursDiff, result;
    hoursDiff = -date.getTimezoneOffset() / 60;
    result = Dates.padNumber(Math.abs(hoursDiff), 4);
    return (hoursDiff > 0 ? '+' : '-') + result;
  };

  Dates.format = function(date, format) {
    return format.replace(Dates.formats, function(m, p) {
      switch (p) {
        case 'a':
          return Dates.abbreviatedWeekdays[date.getDay()];
        case 'A':
          return Dates.fullWeekdays[date.getDay()];
        case 'b':
          return Dates.abbreviatedMonths[date.getMonth()];
        case 'B':
          return Dates.fullMonths[date.getMonth()];
        case 'c':
          return date.toLocaleString();
        case 'C':
          return Math.round(date.getFullYear() / 100);
        case 'd':
          return Dates.padNumber(date.getDate(), 2);
        case 'D':
          return Dates.format(date, '%m/%d/%y');
        case 'e':
          return Dates.padNumber(date.getDate(), 2, ' ');
        case 'F':
          return Dates.format(date, '%Y-%m-%d');
        case 'h':
          return Dates.format(date, '%b');
        case 'H':
          return Dates.padNumber(date.getHours(), 2);
        case 'I':
          return Dates.padNumber(Dates.tweleveHour(date), 2);
        case 'j':
          return Dates.padNumber(Dates.dayOfYear(date), 3);
        case 'k':
          return Dates.padNumber(date.getHours(), 2, ' ');
        case 'l':
          return Dates.padNumber(Dates.tweleveHour(date), 2, ' ');
        case 'L':
          return Dates.padNumber(date.getMilliseconds(), 3);
        case 'm':
          return Dates.padNumber(date.getMonth() + 1, 2);
        case 'M':
          return Dates.padNumber(date.getMinutes(), 2);
        case 'n':
          return '\n';
        case 'p':
          if (date.getHours() > 11) {
            return 'PM';
          } else {
            return 'AM';
          }
        case 'P':
          return Dates.format(date, '%p').toLowerCase();
        case 'r':
          return Dates.format(date, '%I:%M:%S %p');
        case 'R':
          return Dates.format(date, '%H:%M');
        case 's':
          return date.getTime() / 1000;
        case 'S':
          return Dates.padNumber(date.getSeconds(), 2);
        case 't':
          return '\t';
        case 'T':
          return Dates.format(date, '%H:%M:%S');
        case 'u':
          if (date.getDay() === 0) {
            return 7;
          } else {
            return date.getDay();
          }
        case 'U':
          return Dates.padNumber(Dates.weekOfYear(date), 2);
        case 'v':
          return Dates.format(date, '%e-%b-%Y');
        case 'V':
          return Dates.padNumber(Dates.isoWeekOfYear(date), 2);
        case 'W':
          return Dates.padNumber(Dates.weekOfYear(date), 2);
        case 'w':
          return Dates.padNumber(date.getDay(), 2);
        case 'x':
          return date.toLocaleDateString();
        case 'X':
          return date.toLocaleTimeString();
        case 'y':
          return String(date.getFullYear()).substring(2);
        case 'Y':
          return date.getFullYear();
        case 'z':
          return Dates.timeZoneOffset(date);
        default:
          return match;
      }
    });
  };

  Dates.formats = /%(a|A|b|B|c|C|d|D|e|F|h|H|I|j|k|l|L|m|M|n|p|P|r|R|s|S|t|T|u|U|v|V|W|w|x|X|y|Y|z)/g;

  Dates.abbreviatedWeekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'];

  Dates.fullWeekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  Dates.abbreviatedMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  Dates.fullMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  Swag.addHelper('formatDate', function(date, format) {
    date = new Date(date);
    return Dates.format(date, format);
  }, ['string|number|date', 'string']);

  Swag.addHelper('now', function(format) {
    var date;
    date = new Date();
    if (Utils.isUndefined(format)) {
      return date;
    } else {
      return Dates.format(date, format);
    }
  });

  Swag.addHelper('timeago', function(date) {
    var interval, seconds;
    date = new Date(date);
    seconds = Math.floor((new Date() - date) / 1000);
    interval = Math.floor(seconds / 31536000);
    if (interval > 1) {
      return "" + interval + " years ago";
    }
    interval = Math.floor(seconds / 2592000);
    if (interval > 1) {
      return "" + interval + " months ago";
    }
    interval = Math.floor(seconds / 86400);
    if (interval > 1) {
      return "" + interval + " days ago";
    }
    interval = Math.floor(seconds / 3600);
    if (interval > 1) {
      return "" + interval + " hours ago";
    }
    interval = Math.floor(seconds / 60);
    if (interval > 1) {
      return "" + interval + " minutes ago";
    }
    if (Math.floor(seconds) === 0) {
      return 'Just now';
    } else {
      return Math.floor(seconds) + ' seconds ago';
    }
  }, 'string|number|date');

  Swag.addHelper('inflect', function(count, singular, plural, include) {
    var word;
    count = parseFloat(count);
    word = count > 1 || count === 0 ? plural : singular;
    if (Utils.isUndefined(include) || include === false) {
      return word;
    } else {
      return "" + count + " " + word;
    }
  }, ['number', 'string', 'string']);

  Swag.addHelper('ordinalize', function(value) {
    var normal, _ref;
    value = parseFloat(value);
    normal = Math.abs(Math.round(value));
    if (_ref = normal % 100, __indexOf.call([11, 12, 13], _ref) >= 0) {
      return "" + value + "th";
    } else {
      switch (normal % 10) {
        case 1:
          return "" + value + "st";
        case 2:
          return "" + value + "nd";
        case 3:
          return "" + value + "rd";
        default:
          return "" + value + "th";
      }
    }
  }, 'number');

  HTML = {};

  HTML.parseAttributes = function(hash) {
    return Object.keys(hash).map(function(key) {
      return "" + key + "=\"" + hash[key] + "\"";
    }).join(' ');
  };

  Swag.addHelper('ul', function(context, options) {
    return ("<ul " + (HTML.parseAttributes(options.hash)) + ">") + context.map(function(item) {
      return "<li>" + (options.fn(Utils.result(item))) + "</li>";
    }).join('\n') + "</ul>";
  });

  Swag.addHelper('ol', function(context, options) {
    return ("<ol " + (HTML.parseAttributes(options.hash)) + ">") + context.map(function(item) {
      return "<li>" + (options.fn(Utils.result(item))) + "</li>";
    }).join('\n') + "</ol>";
  });

  Swag.addHelper('br', function(count, options) {
    var br, i;
    br = '<br>';
    if (!Utils.isUndefined(count)) {
      i = 0;
      while (i < (parseFloat(count)) - 1) {
        br += '<br>';
        i++;
      }
    }
    return Utils.safeString(br);
  });

  Swag.addHelper('log', function(value) {
    return console.log(value);
  }, 'string|number|boolean|array|object');

  Swag.addHelper('debug', function(value) {
    console.log('Context: ', this);
    if (!Utils.isUndefined(value)) {
      console.log('Value: ', value);
    }
    return console.log('-----------------------------------------------');
  });

  Swag.addHelper('default', function(value, defaultValue) {
    return value || defaultValue;
  }, 'safe:string|number', 'string|number');

  if (typeof Ember === "undefined" || Ember === null) {
    Swag.addHelper('partial', function(name, data, template) {
      var path;
      path = Swag.Config.partialsPath + name;
      if (Swag.Handlebars.partials[name] == null) {
        if (!Utils.isUndefined(template)) {
          if (Utils.isString(template)) {
            template = Swag.Handlebars.compile(template);
          }
          Swag.Handlebars.registerPartial(name, template);
        } else if ((typeof define !== "undefined" && define !== null) && (Utils.isFunc(define)) && define.amd) {
          if (!Swag.Config.precompiledTemplates) {
            path = "!text" + path;
          }
          require([path], function(template) {
            if (Utils.isString(template)) {
              template = Swag.Handlebars.compile(template);
            }
            return Swag.Handlebars.registerPartial(name, template);
          });
        } else if (typeof require !== "undefined" && require !== null) {
          template = require(path);
          if (Utils.isString(template)) {
            template = Swag.Handlebars.compile(template);
          }
          Swag.Handlebars.registerPartial(name, template);
        } else {
          Utils.err('{{partial}} no amd or commonjs module support found.');
        }
      }
      return Utils.safeString(Swag.Handlebars.partials[name](data));
    }, 'string');
  }

}).call(this);
</script>

<#--
Article ID: ${.vars['reserved-article-id'].data}<br>
Article Group Id: ${articleGroupId}<br>
Locale: ${locale}
-->

<link href="/reklistan-theme/css/custom.css?browserId=other&themeId=reklistantheme_WAR_reklistantheme&languageId=en_US&b=6210&t=${.now?datetime?iso_local}" rel="stylesheet" type="text/css">
<div class="preview-wrapper">

  <div id="title-target"></div>

  <div class="preview-settings">
    <a href="#" class="open-self-new-window" target="_blank">Öppna i nytt eget fönster (för utskrift)</a>
    <label><input type="checkbox" class="chekbox-show-preview checkbox-show-preview-published-draft" name="preview-settings" value="show-draft-published" checked>Visa utkast/publicerad</label>
    <label><input type="checkbox" class="chekbox-show-preview checkbox-show-preview-diff" name="preview-settings" value="show-diff" checked>Visa diff</label>
  </div>

  <div class="preview-box preview-box-draft">
    <div class="preview-box-heading">Utkast<span class="no-print"> (<a href="#" class="toggle-show-published">visa publicerad</a>)</span></div>
    <div id="draft-target"></div>
  </div>
  <div class="preview-box preview-box-published hide-me">
    <div class="preview-box-heading">Publicerad<span class="no-print"> (<a href="#" class="toggle-show-draft">visa utkast</a>)</span></div>
    <div id="published-target"></div>
  </div>    
  <div class="preview-box preview-box-diff">
    <div class="preview-box-heading">Diff</div>
    <div id="diff-target"></div>
  </div>
</div>


<script>






AUI().ready('aui-base', function(A) {
    'use strict';

    var urlJquery = '/reklistan-theme/custom-lib/jquery/jquery-1.11.2.min.js';
    var urlHandlebars = '/reklistan-theme/lib/handlebars/handlebars.min.js'
    var urlArticlePublished = "/api/jsonws/skinny-web.skinny/get-skinny-journal-article/group-id/${articleGroupId}/article-id/${.vars['reserved-article-id'].data}/status/0/locale/${locale}";
    var urlArticleDraft = "/api/jsonws/skinny-web.skinny/get-skinny-journal-article/group-id/${articleGroupId}/article-id/${.vars['reserved-article-id'].data}/status/-1/locale/${locale}";    

    // Load jQuery
    A.Get.js(urlJquery, function (err) {
        if (err) {
            alert('Could not load jQuery, URL: ' + urlJquery);
            return;
        }

        // jQuery is loaded
        $(function() {
            // Load Handlebars
            $.getScript(urlHandlebars)
                .done(function() {
                // Load published article
                $.ajax(urlArticlePublished)
                    .done(function(articlePublished) {
                        // Load draft article
                        $.ajax(urlArticleDraft)
                            .done(function(articleDraft) {
                                init(articlePublished, articleDraft);
                            })
                            .fail(function() {
                                alert('Could not load Draft Article, URL: ' + urlArticleDraft);
                            });
                    })
                    .fail(function() {
                        alert('Could not load Publised Article Article, URL: ' + urlArticlePublished);
                    });
                })
                .fail(function( jqxhr, settings, exception ) {
                    alert('Could not load Handlebars, URL: ' + urlHandlebars);
                });
        });
    });
});



function init(articlePublished, articleDraft) {

    $('.open-self-new-window').attr('href', window.location.href);

    registerHandlebarHelpers();
    Swag.registerHelpers(Handlebars);

    printTemplate(articleDraft, '#title-template', '#title-target');
    printTemplate(articleDraft, '#details-drugs-template', '#draft-target');
    printTemplate(articlePublished, '#details-drugs-template', '#published-target');

    var articleDiff = htmldiff($('#published-target').html(), $('#draft-target').html());
    $('#diff-target').html(articleDiff);

    // Show and hide the previews
    $('.toggle-show-published').click(function (event) {
      event.preventDefault();
      $('.preview-box-draft').addClass('hide-me');
      $('.preview-box-published').removeClass('hide-me');
    });

    $('.toggle-show-draft').click(function (event) {
        event.preventDefault();
        $('.preview-box-published').addClass('hide-me');
        $('.preview-box-draft').removeClass('hide-me');
    });

    $('.checkbox-show-preview-published-draft').change(function () {
        if (this.checked) {
            $('.preview-box-published').addClass('hide-me');
            $('.preview-box-draft').removeClass('hide-me');
        } else {
            $('.preview-box-published').addClass('hide-me');
            $('.preview-box-draft').addClass('hide-me');
        }
        setSinglePreviewClass();
    });

    $('.checkbox-show-preview-diff').change(function () {
        if (this.checked) {
            $('.preview-box-diff').removeClass('hide-me');
        } else {
            $('.preview-box-diff').addClass('hide-me');
        }
        setSinglePreviewClass();
    });

    function setSinglePreviewClass() {
      var numberOfChecks = $('.chekbox-show-preview:checked').length;
      if (numberOfChecks === 2 || numberOfChecks === 0) {
        $('.single-preview-box').removeClass('single-preview-box');
      } else if (numberOfChecks === 1) {
        $('.preview-box').addClass('single-preview-box');
      }
    }





    
}



function registerHandlebarHelpers() {
  /**
   * Make URL safe URL
   * 
   * Usage:
   * {{urlencode variable}} 
   *
   */
  Handlebars.registerHelper('urlencode', function(context) {
      var ret = context || '';
      ret = ret.replace(/ /g, '_');
      ret = removeDiacritics(ret);
      ret = encodeURIComponent(ret);

      return new Handlebars.SafeString(ret);
  });


  /**
   * If variabale is equal to value-helper
   *
   * Usage:
   * {{#eq variable eq='hello'}}Print this{{/#if}}
   */
  Handlebars.registerHelper('eq', function(context, options) {

      // console.log('---------');
      // console.log('context');
      // console.dir(context);
      // console.log('options');
      // console.dir(options);

      if (context === options.hash.eq) {
          return options.fn(context);
      } else {
          return '';
      }
  });


  /**
   * Parse the text and do some replacing
   *
   * Usage:
   * {{markdownify variable}}
   */
  Handlebars.registerHelper('markdownify', function(context) {
      var text = context || '';

      // Convert markdown links to html links
      text = text.replace(/\[(.*?)\]\((.*?)\)/g, '<a href="\$2">\$1</a>');

      // Convert {{replaceable}} with icon
      text = text.replace(/\{\{replaceable\}\}/g, '<span class="replaceable">&#8860;</span>');
      text = text.replace(/\{\{child\}\}/g, '<img src="/reklistan-theme/images/theme/child.png" class="child-icon">');

      return new Handlebars.SafeString(text);
  });


  Handlebars.registerHelper('debug', function (context) {
    return new Handlebars.SafeString(
      '<div class="debug">' + JSON.stringify(context) + '</div>'
    );
  });

}


 /**
 * Mangle data + template and create output
 *
 * @param {Object} data JSON-data
 * @param {string} templateSelector Selector for the element holding the template
 * @param {string} targetSelector Selector for the element where finished DOM should be placed.
 */
function printTemplate(data, templateSelector, targetSelector) {
    var templateHTML = $(templateSelector).html();
    var target = $(targetSelector);
    var template = Handlebars.compile(templateHTML);
    target.html(template(data));
}


</script>




<script id="title-template" type="text/x-handlebars-template">
  <h1 class="preview-article-title">{{title}}</h1>
</script>

<script id="details-drugs-template" type="text/x-handlebars-template">
  {{#each fields}}
    <h3>{{value}}</h3>
    {{#each children}}
      {{#is name 'subheading1'}}
        {{#if value}}<div class="item-{{@index}} subheading">{{markdownify ../value}}</div>{{/if}}
        {{#each children}}
          {{#if value}}<div class="item-{{@index}} subheading-2">{{markdownify ../value}}</div>{{/if}}
          {{#each children}}
            {{#if value}}<div class="item-{{@index}} area">{{markdownify ../value}}</div>{{/if}}
            {{#each children}}
              {{#if value}}<div class="item-{{@index}} recommended-for">{{markdownify ../value}}</div>{{/if}}
              {{#each children}}
                {{#if value}}
                  <div class="item-{{@index}} substance">
                    {{../value}}
                    {{#is ../children.0.value 'true'}}
                      <span class="replaceable">&#8860;</span>
                    {{/is}}
                  </div>
                {{/if}}
                {{#each children}}
                  {{#is name 'drug'}}
                    {{#if ../value}}
                      <div class="item-{{@index}} drug">
                        {{../../value}}
                        {{#is ../../children.0.value 'true'}}
                          <span class="replaceable">&#8860;</span>
                        {{/is}}
                      </div>
                    {{/if}}
                  {{/is}}
                  {{#each children}}
                    {{#is name 'infoboxDrug'}}
                      {{#if ../value}}
                        <div class="infobox infobox-drug">
                          {{markdownify ../value}}
                        </div>                      
                      {{/if}}
                    {{/is}}
                  {{/each}}
                {{/each}}
              {{/each}}
            {{/each}}
          {{/each}}
        {{/each}}
      {{/is}}
      {{#is name 'infoboxHeading'}}
        {{#if ../value}}
          <div class="infobox infobox-heading">
            {{#if ../children.0.value}}
              <h3>{{../../children.0.value}}</h3>
            {{/if}}
            {{markdownify ../../value}}
          </div>        
        {{/if}}
      {{/is}}
    {{/each}}
  {{/each}}
</script>

<script id="details-drugs-template123" type="text/x-handlebars-template">
  {{title}}
  <div class="section-details section-details-drugs">
  {{#each this}}
    {{#each subheading1}}
      {{#if fieldValue}}<div class="item-{{@index}} subheading">{{markdownify fieldValue}}</div>{{/if}}
      {{#each subheading2}}
        {{#if fieldValue}}<div class="item-{{@index}} subheading-2">{{markdownify fieldValue}}</div>{{/if}}
        {{#each area}}
          {{#if fieldValue}}<div class="item-{{@index}} area">{{markdownify fieldValue}}</div>{{/if}}
          {{#each recommendedFor}}
            {{#if fieldValue}}<div class="item-{{@index}} recommended-for">{{markdownify fieldValue}}</div>{{/if}}
            {{#each substance}}
              {{#if fieldValue}}
                <div class="item-{{@index}} substance">
                  {{markdownify fieldValue}}
                  {{#if replaceableSubstance.0.fieldValue}}
                    <span class="replaceable">&#8860;</span>
                  {{/if}}
                </div>
              {{/if}}
              {{#each drug}}
                {{#if fieldValue}}
                  <div class="item-{{@index}} drug">
                    {{markdownify fieldValue}}
                    {{#if replaceableDrug.0.fieldValue}}
                      <span class="replaceable">&#8860;</span>
                    {{/if}}
                  </div>
                {{/if}}
                {{#each infoboxDrug}}
                  {{#if fieldValue}}
                    <div class="item-{{@index}} infobox infobox-drug">
                      {{markdownify fieldValue}}
                    </div>
                  {{/if}}
                {{/each}}
              {{/each}}         
            {{/each}}

          {{/each}}
        {{/each}}       
      {{/each}}
    {{/each}}
    {{#each infoboxHeading}}
      {{#if fieldValue}}
        <div class="item-{{@index}} infobox infobox-heading">
          {{#if infoboxHeadingHeading.0.fieldValue}}
            <h3>{{infoboxHeadingHeading.0.fieldValue}}</h3>
          {{/if}}
          {{markdownify fieldValue}}
        </div>
      {{/if}}
    {{/each}}
  {{/each}}
  </div>
</script>





<script>

  var Match, calculate_operations, consecutive_where, create_index, diff, find_match, find_matching_blocks, html_to_tokens, is_end_of_tag, is_start_of_tag, is_tag, is_whitespace, isnt_tag, op_map, recursively_find_matching_blocks, render_operations, wrap;

  is_end_of_tag = function(char) {
    return char === '>';
  };

  is_start_of_tag = function(char) {
    return char === '<';
  };

  is_whitespace = function(char) {
    return /^\s+$/.test(char);
  };

  is_tag = function(token) {
    return /^\s*<[^>]+>\s*$/.test(token);
  };

  isnt_tag = function(token) {
    return !is_tag(token);
  };

  Match = (function() {
    function Match(start_in_before1, start_in_after1, length1) {
      this.start_in_before = start_in_before1;
      this.start_in_after = start_in_after1;
      this.length = length1;
      this.end_in_before = (this.start_in_before + this.length) - 1;
      this.end_in_after = (this.start_in_after + this.length) - 1;
    }

    return Match;

  })();

  html_to_tokens = function(html) {
    var char, current_word, i, len, mode, words;
    mode = 'char';
    current_word = '';
    words = [];
    for (i = 0, len = html.length; i < len; i++) {
      char = html[i];
      switch (mode) {
        case 'tag':
          if (is_end_of_tag(char)) {
            current_word += '>';
            words.push(current_word);
            current_word = '';
            if (is_whitespace(char)) {
              mode = 'whitespace';
            } else {
              mode = 'char';
            }
          } else {
            current_word += char;
          }
          break;
        case 'char':
          if (is_start_of_tag(char)) {
            if (current_word) {
              words.push(current_word);
            }
            current_word = '<';
            mode = 'tag';
          } else if (/\s/.test(char)) {
            if (current_word) {
              words.push(current_word);
            }
            current_word = char;
            mode = 'whitespace';
          } else if (/[\w\#@]+/i.test(char)) {
            current_word += char;
          } else {
            if (current_word) {
              words.push(current_word);
            }
            current_word = char;
          }
          break;
        case 'whitespace':
          if (is_start_of_tag(char)) {
            if (current_word) {
              words.push(current_word);
            }
            current_word = '<';
            mode = 'tag';
          } else if (is_whitespace(char)) {
            current_word += char;
          } else {
            if (current_word) {
              words.push(current_word);
            }
            current_word = char;
            mode = 'char';
          }
          break;
        default:
          throw new Error("Unknown mode " + mode);
      }
    }
    if (current_word) {
      words.push(current_word);
    }
    return words;
  };

  find_match = function(before_tokens, after_tokens, index_of_before_locations_in_after_tokens, start_in_before, end_in_before, start_in_after, end_in_after) {
    var best_match_in_after, best_match_in_before, best_match_length, i, index_in_after, index_in_before, j, len, locations_in_after, looking_for, match, match_length_at, new_match_length, new_match_length_at, ref, ref1;
    best_match_in_before = start_in_before;
    best_match_in_after = start_in_after;
    best_match_length = 0;
    match_length_at = {};
    for (index_in_before = i = ref = start_in_before, ref1 = end_in_before; ref <= ref1 ? i < ref1 : i > ref1; index_in_before = ref <= ref1 ? ++i : --i) {
      new_match_length_at = {};
      looking_for = before_tokens[index_in_before];
      locations_in_after = index_of_before_locations_in_after_tokens[looking_for];
      for (j = 0, len = locations_in_after.length; j < len; j++) {
        index_in_after = locations_in_after[j];
        if (index_in_after < start_in_after) {
          continue;
        }
        if (index_in_after >= end_in_after) {
          break;
        }
        if (match_length_at[index_in_after - 1] == null) {
          match_length_at[index_in_after - 1] = 0;
        }
        new_match_length = match_length_at[index_in_after - 1] + 1;
        new_match_length_at[index_in_after] = new_match_length;
        if (new_match_length > best_match_length) {
          best_match_in_before = index_in_before - new_match_length + 1;
          best_match_in_after = index_in_after - new_match_length + 1;
          best_match_length = new_match_length;
        }
      }
      match_length_at = new_match_length_at;
    }
    if (best_match_length !== 0) {
      match = new Match(best_match_in_before, best_match_in_after, best_match_length);
    }
    return match;
  };

  recursively_find_matching_blocks = function(before_tokens, after_tokens, index_of_before_locations_in_after_tokens, start_in_before, end_in_before, start_in_after, end_in_after, matching_blocks) {
    var match;
    match = find_match(before_tokens, after_tokens, index_of_before_locations_in_after_tokens, start_in_before, end_in_before, start_in_after, end_in_after);
    if (match != null) {
      if (start_in_before < match.start_in_before && start_in_after < match.start_in_after) {
        recursively_find_matching_blocks(before_tokens, after_tokens, index_of_before_locations_in_after_tokens, start_in_before, match.start_in_before, start_in_after, match.start_in_after, matching_blocks);
      }
      matching_blocks.push(match);
      if (match.end_in_before <= end_in_before && match.end_in_after <= end_in_after) {
        recursively_find_matching_blocks(before_tokens, after_tokens, index_of_before_locations_in_after_tokens, match.end_in_before + 1, end_in_before, match.end_in_after + 1, end_in_after, matching_blocks);
      }
    }
    return matching_blocks;
  };

  create_index = function(p) {
    var i, idx, index, len, ref, token;
    if (p.find_these == null) {
      throw new Error('params must have find_these key');
    }
    if (p.in_these == null) {
      throw new Error('params must have in_these key');
    }
    index = {};
    ref = p.find_these;
    for (i = 0, len = ref.length; i < len; i++) {
      token = ref[i];
      index[token] = [];
      idx = p.in_these.indexOf(token);
      while (idx !== -1) {
        index[token].push(idx);
        idx = p.in_these.indexOf(token, idx + 1);
      }
    }
    return index;
  };

  find_matching_blocks = function(before_tokens, after_tokens) {
    var index_of_before_locations_in_after_tokens, matching_blocks;
    matching_blocks = [];
    index_of_before_locations_in_after_tokens = create_index({
      find_these: before_tokens,
      in_these: after_tokens
    });
    return recursively_find_matching_blocks(before_tokens, after_tokens, index_of_before_locations_in_after_tokens, 0, before_tokens.length, 0, after_tokens.length, matching_blocks);
  };

  calculate_operations = function(before_tokens, after_tokens) {
    var action_map, action_up_to_match_positions, i, index, is_single_whitespace, j, last_op, len, len1, match, match_starts_at_current_position_in_after, match_starts_at_current_position_in_before, matches, op, operations, position_in_after, position_in_before, post_processed;
    if (before_tokens == null) {
      throw new Error('before_tokens?');
    }
    if (after_tokens == null) {
      throw new Error('after_tokens?');
    }
    position_in_before = position_in_after = 0;
    operations = [];
    action_map = {
      'false,false': 'replace',
      'true,false': 'insert',
      'false,true': 'delete',
      'true,true': 'none'
    };
    matches = find_matching_blocks(before_tokens, after_tokens);
    matches.push(new Match(before_tokens.length, after_tokens.length, 0));
    for (index = i = 0, len = matches.length; i < len; index = ++i) {
      match = matches[index];
      match_starts_at_current_position_in_before = position_in_before === match.start_in_before;
      match_starts_at_current_position_in_after = position_in_after === match.start_in_after;
      action_up_to_match_positions = action_map[[match_starts_at_current_position_in_before, match_starts_at_current_position_in_after].toString()];
      if (action_up_to_match_positions !== 'none') {
        operations.push({
          action: action_up_to_match_positions,
          start_in_before: position_in_before,
          end_in_before: (action_up_to_match_positions !== 'insert' ? match.start_in_before - 1 : void 0),
          start_in_after: position_in_after,
          end_in_after: (action_up_to_match_positions !== 'delete' ? match.start_in_after - 1 : void 0)
        });
      }
      if (match.length !== 0) {
        operations.push({
          action: 'equal',
          start_in_before: match.start_in_before,
          end_in_before: match.end_in_before,
          start_in_after: match.start_in_after,
          end_in_after: match.end_in_after
        });
      }
      position_in_before = match.end_in_before + 1;
      position_in_after = match.end_in_after + 1;
    }
    post_processed = [];
    last_op = {
      action: 'none'
    };
    is_single_whitespace = function(op) {
      if (op.action !== 'equal') {
        return false;
      }
      if (op.end_in_before - op.start_in_before !== 0) {
        return false;
      }
      return /^\s$/.test(before_tokens.slice(op.start_in_before, +op.end_in_before + 1 || 9e9));
    };
    for (j = 0, len1 = operations.length; j < len1; j++) {
      op = operations[j];
      if (((is_single_whitespace(op)) && last_op.action === 'replace') || (op.action === 'replace' && last_op.action === 'replace')) {
        last_op.end_in_before = op.end_in_before;
        last_op.end_in_after = op.end_in_after;
      } else {
        post_processed.push(op);
        last_op = op;
      }
    }
    return post_processed;
  };

  consecutive_where = function(start, content, predicate) {
    var answer, i, index, last_matching_index, len, token;
    content = content.slice(start, +content.length + 1 || 9e9);
    last_matching_index = void 0;
    for (index = i = 0, len = content.length; i < len; index = ++i) {
      token = content[index];
      answer = predicate(token);
      if (answer === true) {
        last_matching_index = index;
      }
      if (answer === false) {
        break;
      }
    }
    if (last_matching_index != null) {
      return content.slice(0, +last_matching_index + 1 || 9e9);
    }
    return [];
  };

  wrap = function(tag, content) {
    var length, non_tags, position, rendering, tags;
    rendering = '';
    position = 0;
    length = content.length;
    while (true) {
      if (position >= length) {
        break;
      }
      non_tags = consecutive_where(position, content, isnt_tag);
      position += non_tags.length;
      if (non_tags.length !== 0) {
        rendering += "<" + tag + ">" + (non_tags.join('')) + "</" + tag + ">";
      }
      if (position >= length) {
        break;
      }
      tags = consecutive_where(position, content, is_tag);
      position += tags.length;
      rendering += tags.join('');
    }
    return rendering;
  };

  op_map = {
    equal: function(op, before_tokens, after_tokens) {
      return before_tokens.slice(op.start_in_before, +op.end_in_before + 1 || 9e9).join('');
    },
    insert: function(op, before_tokens, after_tokens) {
      var val;
      val = after_tokens.slice(op.start_in_after, +op.end_in_after + 1 || 9e9);
      return wrap('ins', val);
    },
    "delete": function(op, before_tokens, after_tokens) {
      var val;
      val = before_tokens.slice(op.start_in_before, +op.end_in_before + 1 || 9e9);
      return wrap('del', val);
    }
  };

  op_map.replace = function(op, before_tokens, after_tokens) {
    return (op_map["delete"](op, before_tokens, after_tokens)) + (op_map.insert(op, before_tokens, after_tokens));
  };

  render_operations = function(before_tokens, after_tokens, operations) {
    var i, len, op, rendering;
    rendering = '';
    for (i = 0, len = operations.length; i < len; i++) {
      op = operations[i];
      rendering += op_map[op.action](op, before_tokens, after_tokens);
    }
    return rendering;
  };

  diff = function(before, after) {
    var ops;
    if (before === after) {
      return before;
    }
    before = html_to_tokens(before);
    after = html_to_tokens(after);
    ops = calculate_operations(before, after);
    return render_operations(before, after, ops);
  };

  diff.html_to_tokens = html_to_tokens;

  diff.find_matching_blocks = find_matching_blocks;

  find_matching_blocks.find_match = find_match;

  find_matching_blocks.create_index = create_index;

  diff.calculate_operations = calculate_operations;

  diff.render_operations = render_operations;

  if (typeof define === 'function') {
    define([], function() {
      return diff;
    });
  } else if (typeof module !== "undefined" && module !== null) {
    module.exports = diff;
  } else {
    this.htmldiff = diff;
  }


</script>


<#--
<script>

AUI().ready('aui-base', function(A) {
  	var urls = [
  		'/reklistan-theme/custom-lib/jquery/jquery-1.11.2.min.js',
  		'/reklistan-theme/custom-lib/jsPDF/dist/jspdf.min.js'];
	A.Get.js(urls, function (err) {
	    if (err) {
	        console.log('One or more files failed to load!');
	    } else {
	        $(function() {

    			$('.menu-link').click(function(event) {
    				event.preventDefault();
    				var curHeading = $(this).attr('data-heading');
  					
  					$('.preview-single-entry').each(function () {
  						if ($(this).attr('data-heading') === curHeading) {
  							$(this).show();
  						} else {
  							$(this).hide();
  						}
  					});
				});


				$('#download-pdf').click(function(event) {

					var doc = new jsPDF();
					doc.text(20, 20, 'Hello world!');
					doc.text(20, 30, 'This is client-side Javascript, pumping out a PDF.');
					doc.setTextColor(255, 0, 0);
					doc.text(20, 40, 'Do you like that?');

					doc.save('Test.pdf');



					// /* WORKING FROM HTML */
					// var doc = new jsPDF();
					// var specialElementHandlers = {
					//     '#editor': function (element, renderer) {
					//         return true;
					//     }
					// };

				 //    doc.fromHTML($('#print-content').html(), 15, 15, {
				 //        'width': 170,
				 //            'elementHandlers': specialElementHandlers
				 //    });
				 //    doc.save('sample-file.pdf');
				 //    /* WORKING FROM HTML */





				});
			});
	    }
	});
});
</script>

<div id="editor"></div>

<link href="/reklistan-theme/css/custom.css?browserId=other&themeId=reklistantheme_WAR_reklistantheme&languageId=en_US&b=6210&t=${.now?datetime}" rel="stylesheet" type="text/css">

<div class="preview-menu">
	<button class="btn" id="download-pdf">Laddad ner PDF</button>
	<ul>
	<#list heading.getSiblings() as cur_heading>
		<li><a class="menu-link" data-heading="${cur_heading.getData()}" href="#">${cur_heading.getData()}</a></li>
	</#list>
	</ul>
</div>

<div id="print-content" class="section-details section-details-drugs">
	<#list heading.getSiblings() as cur_heading>
		<div class="preview-single-entry" data-heading="${cur_heading.getData()}">
			<h1>${cur_heading.getData()}</h1>
			<#list cur_heading.subheading1.getSiblings() as cur_subheading_one>
				<#if (cur_subheading_one.getData()?length > 0)>
					<div class="subheading item-${cur_subheading_one_index}">${cur_subheading_one.getData()}</div>
				</#if>
				<#list cur_subheading_one.subheading2.getSiblings() as cur_subheading_two>
					<#if (cur_subheading_two.getData()?length > 0)>
						<div class="subheading-2 item-${cur_subheading_two_index}">${cur_subheading_two.getData()}</div>
					</#if>
					<#list cur_subheading_two.area.getSiblings() as cur_area>
						<#if (cur_area.getData()?length > 0)>
							<div class="area item-${cur_area_index}">${cur_area.getData()}</div>
						</#if>
						<#list cur_area.recommendedFor.getSiblings() as cur_recommended_for>
							<#if (cur_recommended_for.getData()?length > 0)>
								<div class="recommended-for item-${cur_recommended_for_index}">${cur_recommended_for.getData()}</div>
							</#if>
							<#list cur_recommended_for.substance.getSiblings() as cur_substance>
								<#if (cur_substance.getData()?length > 0)>
									<div class="substance item-${cur_substance_index}">
										${cur_substance.getData()}
										<#if cur_substance.replaceableSubstance.getData() == 'true'>
											<span class="replaceable">&#8860;</span>
										</#if>
									</div>
								</#if>
								<#list cur_substance.drug.getSiblings() as cur_x>
									<#if cur_x.getName() == 'drug'>
										<#if (cur_x.getData()?length > 0)>
											<div class="drug item-${cur_x_index}">
												${cur_x.getData()}
												<#if cur_x.replaceableDrug.getData() == 'true'>
													<span class="replaceable">&#8860;</span>
												</#if>											
											</div>
										</#if>
										<#list cur_x.infoboxDrug.getSiblings() as cur_y>
											<#if (cur_y.getData()?length > 0)>
												<div class="infobox infobox-drug item-${cur_y_index}">${cur_y.getData()}</div>
											</#if>
										</#list>
									</#if>
								</#list>
							</#list>
						</#list>
					</#list>
				</#list>
			</#list>
			<#list cur_heading.infoboxHeading.getSiblings() as cur_infobox_heading>
				<#if (cur_infobox_heading.getData()?length > 0)>
					<div class="infobox infobox-heading item-${cur_infobox_heading_index}">
						<#if (cur_infobox_heading.infoboxHeadingHeading.getData()?length > 0)>
							<h3>${cur_infobox_heading.infoboxHeadingHeading.getData()}</h3>
						</#if>
						${cur_infobox_heading.getData()}
					</div>
				</#if>
			</#list>
		</div>
	</#list>
</div>
-->


