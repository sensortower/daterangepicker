/*!
 * knockout-daterangepicker
 * version: 0.1.2
 * authors: Sensor Tower team
 * license: MIT
 * https://sensortower.github.io/daterangepicker
 */
(function() {
  var AllTimeDateRange, ArrayUtils, CalendarHeaderView, CalendarView, Config, CustomDateRange, DateRange, DateRangePickerView, MomentIterator, MomentUtil, Period,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  MomentUtil = (function() {
    function MomentUtil() {}

    MomentUtil.patchCurrentLocale = function(obj) {
      return moment.locale(moment.locale(), obj);
    };

    MomentUtil.setFirstDayOfTheWeek = function(dow) {
      var offset;
      dow = (dow % 7 + 7) % 7;
      if (moment.localeData().firstDayOfWeek() !== dow) {
        offset = dow - moment.localeData().firstDayOfWeek();
        return this.patchCurrentLocale({
          week: {
            dow: dow,
            doy: moment.localeData().firstDayOfYear()
          }
        });
      }
    };

    MomentUtil.tz = function(input) {
      var args, timeZone;
      args = Array.prototype.slice.call(arguments, 0, -1);
      timeZone = arguments[arguments.length - 1];
      if (moment.tz) {
        return moment.tz.apply(null, args.concat([timeZone]));
      } else if (timeZone && timeZone.toLowerCase() === 'utc') {
        return moment.utc.apply(null, args);
      } else {
        return moment.apply(null, args);
      }
    };

    return MomentUtil;

  })();

  MomentIterator = (function() {
    MomentIterator.array = function(date, amount, period) {
      var i, iterator, j, ref, results;
      iterator = new this(date, period);
      results = [];
      for (i = j = 0, ref = amount - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
        results.push(iterator.next());
      }
      return results;
    };

    function MomentIterator(date, period) {
      this.date = date.clone();
      this.period = period;
    }

    MomentIterator.prototype.next = function() {
      var nextDate;
      nextDate = this.date;
      this.date = nextDate.clone().add(1, this.period);
      return nextDate.clone();
    };

    return MomentIterator;

  })();

  ArrayUtils = (function() {
    function ArrayUtils() {}

    ArrayUtils.rotateArray = function(array, offset) {
      offset = offset % array.length;
      return array.slice(offset).concat(array.slice(0, offset));
    };

    ArrayUtils.uniqArray = function(array) {
      var i, j, len, newArray;
      newArray = [];
      for (j = 0, len = array.length; j < len; j++) {
        i = array[j];
        if (newArray.indexOf(i) === -1) {
          newArray.push(i);
        }
      }
      return newArray;
    };

    return ArrayUtils;

  })();

  $.fn.daterangepicker = function(options, callback) {
    if (options == null) {
      options = {};
    }
    this.each(function() {
      var $element;
      $element = $(this);
      if (!$element.data('daterangepicker')) {
        options.anchorElement = $element;
        if (callback) {
          options.callback = callback;
        }
        options.callback = $.proxy(options.callback, this);
        return $element.data('daterangepicker', new DateRangePickerView(options));
      }
    });
    return this;
  };

  ko.bindingHandlers.stopBinding = {
    init: function() {
      return {
        controlsDescendantBindings: true
      };
    }
  };

  ko.virtualElements.allowedBindings.stopBinding = true;

  ko.bindingHandlers.daterangepicker = (function() {
    return $.extend(this, {
      _optionsKey: 'daterangepickerOptions',
      _formatKey: 'daterangepickerFormat',
      init: function(element, valueAccessor, allBindings) {
        var observable, options;
        observable = valueAccessor();
        options = ko.unwrap(allBindings.get(this._optionsKey)) || {};
        return $(element).daterangepicker(options, function(startDate, endDate, period) {
          return observable([startDate, endDate]);
        });
      },
      update: function(element, valueAccessor, allBindings) {
        var $element, dateFormat, endDate, endDateText, ref, startDate, startDateText;
        $element = $(element);
        ref = valueAccessor()(), startDate = ref[0], endDate = ref[1];
        dateFormat = ko.unwrap(allBindings.get(this._formatKey)) || 'MMM D, YYYY';
        startDateText = moment(startDate).format(dateFormat);
        endDateText = moment(endDate).format(dateFormat);
        return ko.ignoreDependencies(function() {
          var text;
          if (!$element.data('daterangepicker').standalone()) {
            text = $element.data('daterangepicker').single() ? startDateText : startDateText + " – " + endDateText;
            $element.val(text).text(text);
          }
          $element.data('daterangepicker').startDate(startDate);
          return $element.data('daterangepicker').endDate(endDate);
        });
      }
    });
  })();

  DateRange = (function() {
    function DateRange(title, startDate, endDate) {
      this.title = title;
      this.startDate = startDate;
      this.endDate = endDate;
    }

    return DateRange;

  })();

  AllTimeDateRange = (function(superClass) {
    extend(AllTimeDateRange, superClass);

    function AllTimeDateRange() {
      return AllTimeDateRange.__super__.constructor.apply(this, arguments);
    }

    return AllTimeDateRange;

  })(DateRange);

  CustomDateRange = (function(superClass) {
    extend(CustomDateRange, superClass);

    function CustomDateRange() {
      return CustomDateRange.__super__.constructor.apply(this, arguments);
    }

    return CustomDateRange;

  })(DateRange);

  Period = (function() {
    function Period() {}

    Period.allPeriods = ['day', 'week', 'month', 'quarter', 'year'];

    Period.scale = function(period) {
      if (period === 'day' || period === 'week') {
        return 'month';
      } else {
        return 'year';
      }
    };

    Period.showWeekDayNames = function(period) {
      if (period === 'day' || period === 'week') {
        return true;
      } else {
        return false;
      }
    };

    Period.nextPageArguments = function(period) {
      var amount, scale;
      amount = period === 'year' ? 9 : 1;
      scale = this.scale(period);
      return [amount, scale];
    };

    Period.format = function(period) {
      switch (period) {
        case 'day':
        case 'week':
          return 'D';
        case 'month':
          return 'MMM';
        case 'quarter':
          return '\\QQ';
        case 'year':
          return 'YYYY';
      }
    };

    Period.title = function(period) {
      switch (period) {
        case 'day':
          return 'Day';
        case 'week':
          return 'Week';
        case 'month':
          return 'Month';
        case 'quarter':
          return 'Quarter';
        case 'year':
          return 'Year';
      }
    };

    Period.dimentions = function(period) {
      switch (period) {
        case 'day':
          return [7, 6];
        case 'week':
          return [1, 6];
        case 'month':
          return [3, 4];
        case 'quarter':
          return [2, 2];
        case 'year':
          return [3, 3];
      }
    };

    Period.methods = ['scale', 'showWeekDayNames', 'nextPageArguments', 'format', 'title', 'dimentions'];

    Period.extendObservable = function(observable) {
      this.methods.forEach(function(method) {
        return observable[method] = function() {
          return Period[method](observable());
        };
      });
      return observable;
    };

    return Period;

  })();

  Config = (function() {
    function Config(options) {
      if (options == null) {
        options = {};
      }
      this.firstDayOfWeek = this._firstDayOfWeek(options.firstDayOfWeek);
      this.timeZone = this._timeZone(options.timeZone);
      this.periods = this._periods(options.periods);
      this.customPeriodRanges = this._customPeriodRanges(options.customPeriodRanges);
      this.period = this._period(options.period);
      this.single = this._single(options.single);
      this.opened = this._opened(options.opened);
      this.expanded = this._expanded(options.expanded);
      this.standalone = this._standalone(options.standalone);
      this.hideWeekdays = this._hideWeekdays(options.hideWeekdays);
      this.locale = this._locale(options.locale);
      this.orientation = this._orientation(options.orientation);
      this.forceUpdate = options.forceUpdate;
      this.minDate = this._minDate(options.minDate);
      this.maxDate = this._maxDate(options.maxDate);
      this.startDate = this._startDate(options.startDate);
      this.endDate = this._endDate(options.endDate);
      this.ranges = this._ranges(options.ranges);
      this.isCustomPeriodRangeActive = ko.observable(false);
      this.anchorElement = this._anchorElement(options.anchorElement);
      this.parentElement = this._parentElement(options.parentElement);
      this.callback = this._callback(options.callback);
      this.firstDayOfWeek.subscribe(function(newValue) {
        return MomentUtil.setFirstDayOfTheWeek(newValue);
      });
      MomentUtil.setFirstDayOfTheWeek(this.firstDayOfWeek());
    }

    Config.prototype.extend = function(obj) {
      var k, ref, results, v;
      ref = this;
      results = [];
      for (k in ref) {
        v = ref[k];
        if (this.hasOwnProperty(k) && k[0] !== '_') {
          results.push(obj[k] = v);
        }
      }
      return results;
    };

    Config.prototype._firstDayOfWeek = function(val) {
      return ko.observable(val ? val : 0);
    };

    Config.prototype._timeZone = function(val) {
      return ko.observable(val || 'UTC');
    };

    Config.prototype._periods = function(val) {
      return ko.observableArray(val || Period.allPeriods);
    };

    Config.prototype._customPeriodRanges = function(obj) {
      var results, title, value;
      obj || (obj = {});
      results = [];
      for (title in obj) {
        value = obj[title];
        results.push(this.parseRange(value, title));
      }
      return results;
    };

    Config.prototype._period = function(val) {
      val || (val = this.periods()[0]);
      if (val !== 'day' && val !== 'week' && val !== 'month' && val !== 'quarter' && val !== 'year') {
        throw new Error('Invalid period');
      }
      return Period.extendObservable(ko.observable(val));
    };

    Config.prototype._single = function(val) {
      return ko.observable(val || false);
    };

    Config.prototype._opened = function(val) {
      return ko.observable(val || false);
    };

    Config.prototype._expanded = function(val) {
      return ko.observable(val || false);
    };

    Config.prototype._standalone = function(val) {
      return ko.observable(val || false);
    };

    Config.prototype._hideWeekdays = function(val) {
      return ko.observable(val || false);
    };

    Config.prototype._minDate = function(val) {
      var mode, ref;
      if (val instanceof Array) {
        ref = val, val = ref[0], mode = ref[1];
      }
      val || (val = moment().subtract(30, 'years'));
      return this._dateObservable(val, mode);
    };

    Config.prototype._maxDate = function(val) {
      var mode, ref;
      if (val instanceof Array) {
        ref = val, val = ref[0], mode = ref[1];
      }
      val || (val = moment());
      return this._dateObservable(val, mode, this.minDate);
    };

    Config.prototype._startDate = function(val) {
      val || (val = moment().subtract(29, 'days'));
      return this._dateObservable(val, null, this.minDate, this.maxDate);
    };

    Config.prototype._endDate = function(val) {
      val || (val = moment());
      return this._dateObservable(val, null, this.startDate, this.maxDate);
    };

    Config.prototype._ranges = function(obj) {
      var results, title, value;
      obj || (obj = this._defaultRanges());
      if (!$.isPlainObject(obj)) {
        throw new Error('Invalid ranges parameter (should be a plain object)');
      }
      results = [];
      for (title in obj) {
        value = obj[title];
        switch (value) {
          case 'all-time':
            results.push(new AllTimeDateRange(title, this.minDate().clone(), this.maxDate().clone()));
            break;
          case 'custom':
            results.push(new CustomDateRange(title));
            break;
          default:
            results.push(this.parseRange(value, title));
        }
      }
      return results;
    };

    Config.prototype.parseRange = function(value, title) {
      var endDate, from, startDate, to;
      if (!$.isArray(value)) {
        throw new Error('Value should be an array');
      }
      startDate = value[0], endDate = value[1];
      if (!startDate) {
        throw new Error('Missing start date');
      }
      if (!endDate) {
        throw new Error('Missing end date');
      }
      from = MomentUtil.tz(startDate, this.timeZone());
      to = MomentUtil.tz(endDate, this.timeZone());
      if (!from.isValid()) {
        throw new Error('Invalid start date');
      }
      if (!to.isValid()) {
        throw new Error('Invalid end date');
      }
      return new DateRange(title, from, to);
    };

    Config.prototype._locale = function(val) {
      return $.extend({
        applyButtonTitle: 'Apply',
        cancelButtonTitle: 'Cancel',
        inputFormat: 'L',
        startLabel: 'Start',
        endLabel: 'End'
      }, val || {});
    };

    Config.prototype._orientation = function(val) {
      val || (val = 'right');
      if (val !== 'right' && val !== 'left') {
        throw new Error('Invalid orientation');
      }
      return ko.observable(val);
    };

    Config.prototype._dateObservable = function(val, mode, minBoundary, maxBoundary) {
      var computed, fitMax, fitMin, observable;
      observable = ko.observable();
      computed = ko.computed({
        read: function() {
          return observable();
        },
        write: (function(_this) {
          return function(newValue) {
            var oldValue;
            newValue = computed.fit(newValue);
            oldValue = observable();
            if (!(oldValue && newValue.isSame(oldValue))) {
              return observable(newValue);
            }
          };
        })(this)
      });
      computed.mode = mode || 'inclusive';
      fitMin = (function(_this) {
        return function(val) {
          var min;
          if (minBoundary) {
            min = minBoundary();
            switch (minBoundary.mode) {
              case 'extended':
                min = min.clone().startOf(_this.period());
                break;
              case 'exclusive':
                min = min.clone().endOf(_this.period()).add(1, 'millisecond');
            }
            val = moment.max(min, val);
          }
          return val;
        };
      })(this);
      fitMax = (function(_this) {
        return function(val) {
          var max;
          if (maxBoundary) {
            max = maxBoundary();
            switch (maxBoundary.mode) {
              case 'extended':
                max = max.clone().endOf(_this.period());
                break;
              case 'exclusive':
                max = max.clone().startOf(_this.period()).subtract(1, 'millisecond');
            }
            val = moment.min(max, val);
          }
          return val;
        };
      })(this);
      computed.fit = (function(_this) {
        return function(val) {
          val = MomentUtil.tz(val, _this.timeZone());
          return fitMax(fitMin(val));
        };
      })(this);
      computed(val);
      computed.clone = (function(_this) {
        return function() {
          return _this._dateObservable(observable(), computed.mode, minBoundary, maxBoundary);
        };
      })(this);
      computed.isWithinBoundaries = (function(_this) {
        return function(date) {
          var between, max, maxExclusive, min, minExclusive, sameMax, sameMin;
          date = MomentUtil.tz(date, _this.timeZone());
          min = minBoundary();
          max = maxBoundary();
          between = date.isBetween(min, max, _this.period());
          sameMin = date.isSame(min, _this.period());
          sameMax = date.isSame(max, _this.period());
          minExclusive = minBoundary.mode === 'exclusive';
          maxExclusive = maxBoundary.mode === 'exclusive';
          return between || (!minExclusive && sameMin && !(maxExclusive && sameMax)) || (!maxExclusive && sameMax && !(minExclusive && sameMin));
        };
      })(this);
      if (minBoundary) {
        computed.minBoundary = minBoundary;
        minBoundary.subscribe(function() {
          return computed(observable());
        });
      }
      if (maxBoundary) {
        computed.maxBoundary = maxBoundary;
        maxBoundary.subscribe(function() {
          return computed(observable());
        });
      }
      return computed;
    };

    Config.prototype._defaultRanges = function() {
      return {
        'Last 30 days': [moment().subtract(29, 'days'), moment()],
        'Last 90 days': [moment().subtract(89, 'days'), moment()],
        'Last Year': [moment().subtract(1, 'year').add(1, 'day'), moment()],
        'All Time': 'all-time',
        'Custom Range': 'custom'
      };
    };

    Config.prototype._anchorElement = function(val) {
      return $(val);
    };

    Config.prototype._parentElement = function(val) {
      return $(val || (this.standalone() ? this.anchorElement : 'body'));
    };

    Config.prototype._callback = function(val) {
      if (val && !$.isFunction(val)) {
        throw new Error('Invalid callback (not a function)');
      }
      return val;
    };

    return Config;

  })();

  CalendarHeaderView = (function() {
    function CalendarHeaderView(calendarView) {
      this.clickNextButton = bind(this.clickNextButton, this);
      this.clickPrevButton = bind(this.clickPrevButton, this);
      this.currentDate = calendarView.currentDate;
      this.period = calendarView.period;
      this.timeZone = calendarView.timeZone;
      this.firstDate = calendarView.firstDate;
      this.firstYearOfDecade = calendarView.firstYearOfDecade;
      this.prevDate = ko.pureComputed((function(_this) {
        return function() {
          var amount, period, ref;
          ref = _this.period.nextPageArguments(), amount = ref[0], period = ref[1];
          return _this.currentDate().clone().subtract(amount, period);
        };
      })(this));
      this.nextDate = ko.pureComputed((function(_this) {
        return function() {
          var amount, period, ref;
          ref = _this.period.nextPageArguments(), amount = ref[0], period = ref[1];
          return _this.currentDate().clone().add(amount, period);
        };
      })(this));
      this.selectedMonth = ko.computed({
        read: (function(_this) {
          return function() {
            return _this.currentDate().month();
          };
        })(this),
        write: (function(_this) {
          return function(newValue) {
            var newDate;
            newDate = _this.currentDate().clone().month(newValue);
            if (!newDate.isSame(_this.currentDate(), 'month')) {
              return _this.currentDate(newDate);
            }
          };
        })(this),
        pure: true
      });
      this.selectedYear = ko.computed({
        read: (function(_this) {
          return function() {
            return _this.currentDate().year();
          };
        })(this),
        write: (function(_this) {
          return function(newValue) {
            var newDate;
            newDate = _this.currentDate().clone().year(newValue);
            if (!newDate.isSame(_this.currentDate(), 'year')) {
              return _this.currentDate(newDate);
            }
          };
        })(this),
        pure: true
      });
      this.selectedDecade = ko.computed({
        read: (function(_this) {
          return function() {
            return _this.firstYearOfDecade(_this.currentDate()).year();
          };
        })(this),
        write: (function(_this) {
          return function(newValue) {
            var newDate, newYear, offset;
            offset = (_this.currentDate().year() - _this.selectedDecade()) % 9;
            newYear = newValue + offset;
            newDate = _this.currentDate().clone().year(newYear);
            if (!newDate.isSame(_this.currentDate(), 'year')) {
              return _this.currentDate(newDate);
            }
          };
        })(this),
        pure: true
      });
    }

    CalendarHeaderView.prototype.clickPrevButton = function() {
      return this.currentDate(this.prevDate());
    };

    CalendarHeaderView.prototype.clickNextButton = function() {
      return this.currentDate(this.nextDate());
    };

    CalendarHeaderView.prototype.prevArrowCss = function() {
      var date, ref;
      date = this.firstDate().clone().subtract(1, 'millisecond');
      if ((ref = this.period()) === 'day' || ref === 'week') {
        date = date.endOf('month');
      }
      return {
        'arrow-hidden': !this.currentDate.isWithinBoundaries(date)
      };
    };

    CalendarHeaderView.prototype.nextArrowCss = function() {
      var cols, date, ref, ref1, rows;
      ref = this.period.dimentions(), cols = ref[0], rows = ref[1];
      date = this.firstDate().clone().add(cols * rows, this.period());
      if ((ref1 = this.period()) === 'day' || ref1 === 'week') {
        date = date.startOf('month');
      }
      return {
        'arrow-hidden': !this.currentDate.isWithinBoundaries(date)
      };
    };

    CalendarHeaderView.prototype.monthOptions = function() {
      var j, maxMonth, minMonth, results;
      minMonth = this.currentDate.minBoundary().isSame(this.currentDate(), 'year') ? this.currentDate.minBoundary().month() : 0;
      maxMonth = this.currentDate.maxBoundary().isSame(this.currentDate(), 'year') ? this.currentDate.maxBoundary().month() : 11;
      return (function() {
        results = [];
        for (var j = minMonth; minMonth <= maxMonth ? j <= maxMonth : j >= maxMonth; minMonth <= maxMonth ? j++ : j--){ results.push(j); }
        return results;
      }).apply(this);
    };

    CalendarHeaderView.prototype.yearOptions = function() {
      var j, ref, ref1, results;
      return (function() {
        results = [];
        for (var j = ref = this.currentDate.minBoundary().year(), ref1 = this.currentDate.maxBoundary().year(); ref <= ref1 ? j <= ref1 : j >= ref1; ref <= ref1 ? j++ : j--){ results.push(j); }
        return results;
      }).apply(this);
    };

    CalendarHeaderView.prototype.decadeOptions = function() {
      return ArrayUtils.uniqArray(this.yearOptions().map((function(_this) {
        return function(year) {
          var momentObj;
          momentObj = MomentUtil.tz([year], _this.timeZone());
          return _this.firstYearOfDecade(momentObj).year();
        };
      })(this)));
    };

    CalendarHeaderView.prototype.monthSelectorAvailable = function() {
      var ref;
      return (ref = this.period()) === 'day' || ref === 'week';
    };

    CalendarHeaderView.prototype.yearSelectorAvailable = function() {
      return this.period() !== 'year';
    };

    CalendarHeaderView.prototype.decadeSelectorAvailable = function() {
      return this.period() === 'year';
    };

    CalendarHeaderView.prototype.monthFormatter = function(x) {
      return moment.utc([2015, x]).format('MMM');
    };

    CalendarHeaderView.prototype.yearFormatter = function(x) {
      return moment.utc([x]).format('YYYY');
    };

    CalendarHeaderView.prototype.decadeFormatter = function(from) {
      var cols, ref, rows, to;
      ref = Period.dimentions('year'), cols = ref[0], rows = ref[1];
      to = from + cols * rows - 1;
      return from + " – " + to;
    };

    return CalendarHeaderView;

  })();

  CalendarView = (function() {
    function CalendarView(mainView, dateSubscribable, type) {
      this.cssForDate = bind(this.cssForDate, this);
      this.eventsForDate = bind(this.eventsForDate, this);
      this.formatDateTemplate = bind(this.formatDateTemplate, this);
      this.tableValues = bind(this.tableValues, this);
      this.inRange = bind(this.inRange, this);
      this.period = mainView.period;
      this.single = mainView.single;
      this.timeZone = mainView.timeZone;
      this.locale = mainView.locale;
      this.startDate = mainView.startDate;
      this.endDate = mainView.endDate;
      this.isCustomPeriodRangeActive = mainView.isCustomPeriodRangeActive;
      this.type = type;
      this.label = mainView.locale[type + "Label"] || '';
      this.hoverDate = ko.observable(null);
      this.activeDate = dateSubscribable;
      this.currentDate = dateSubscribable.clone();
      this.inputDate = ko.computed({
        read: (function(_this) {
          return function() {
            return (_this.hoverDate() || _this.activeDate()).format(_this.locale.inputFormat);
          };
        })(this),
        write: (function(_this) {
          return function(newValue) {
            var newDate;
            newDate = MomentUtil.tz(newValue, _this.locale.inputFormat, _this.timeZone());
            if (newDate.isValid()) {
              return _this.activeDate(newDate);
            }
          };
        })(this),
        pure: true
      });
      this.firstDate = ko.pureComputed((function(_this) {
        return function() {
          var date, firstDayOfMonth;
          date = _this.currentDate().clone().startOf(_this.period.scale());
          switch (_this.period()) {
            case 'day':
            case 'week':
              firstDayOfMonth = date.clone();
              date.weekday(0);
              if (date.isAfter(firstDayOfMonth) || date.isSame(firstDayOfMonth, 'day')) {
                date.subtract(1, 'week');
              }
              break;
            case 'year':
              date = _this.firstYearOfDecade(date);
          }
          return date;
        };
      })(this));
      this.activeDate.subscribe((function(_this) {
        return function(newValue) {
          return _this.currentDate(newValue);
        };
      })(this));
      this.headerView = new CalendarHeaderView(this);
    }

    CalendarView.prototype.calendar = function() {
      var col, cols, date, iterator, j, ref, ref1, results, row, rows;
      ref = this.period.dimentions(), cols = ref[0], rows = ref[1];
      iterator = new MomentIterator(this.firstDate(), this.period());
      results = [];
      for (row = j = 1, ref1 = rows; 1 <= ref1 ? j <= ref1 : j >= ref1; row = 1 <= ref1 ? ++j : --j) {
        results.push((function() {
          var l, ref2, results1;
          results1 = [];
          for (col = l = 1, ref2 = cols; 1 <= ref2 ? l <= ref2 : l >= ref2; col = 1 <= ref2 ? ++l : --l) {
            date = iterator.next();
            if (this.type === 'end') {
              results1.push(date.endOf(this.period()));
            } else {
              results1.push(date.startOf(this.period()));
            }
          }
          return results1;
        }).call(this));
      }
      return results;
    };

    CalendarView.prototype.weekDayNames = function() {
      return ArrayUtils.rotateArray(moment.weekdaysMin(), moment.localeData().firstDayOfWeek());
    };

    CalendarView.prototype.inRange = function(date) {
      return date.isAfter(this.startDate(), this.period()) && date.isBefore(this.endDate(), this.period()) || (date.isSame(this.startDate(), this.period()) || date.isSame(this.endDate(), this.period()));
    };

    CalendarView.prototype.tableValues = function(date) {
      var format, months, quarter;
      format = this.period.format();
      switch (this.period()) {
        case 'day':
        case 'month':
        case 'year':
          return [
            {
              html: date.format(format)
            }
          ];
        case 'week':
          date = date.clone().startOf(this.period());
          return MomentIterator.array(date, 7, 'day').map((function(_this) {
            return function(date) {
              return {
                html: date.format(format),
                css: {
                  'week-day': true,
                  unavailable: _this.cssForDate(date, true).unavailable
                }
              };
            };
          })(this));
        case 'quarter':
          quarter = date.format(format);
          date = date.clone().startOf('quarter');
          months = MomentIterator.array(date, 3, 'month').map(function(date) {
            return date.format('MMM');
          });
          return [
            {
              html: quarter + "<br><span class='months'>" + (months.join(", ")) + "</span>"
            }
          ];
      }
    };

    CalendarView.prototype.formatDateTemplate = function(date) {
      return {
        nodes: $("<div>" + (this.formatDate(date)) + "</div>").children()
      };
    };

    CalendarView.prototype.eventsForDate = function(date) {
      return {
        click: (function(_this) {
          return function() {
            if (_this.activeDate.isWithinBoundaries(date)) {
              return _this.activeDate(date);
            }
          };
        })(this),
        mouseenter: (function(_this) {
          return function() {
            if (_this.activeDate.isWithinBoundaries(date)) {
              return _this.hoverDate(_this.activeDate.fit(date));
            }
          };
        })(this),
        mouseleave: (function(_this) {
          return function() {
            return _this.hoverDate(null);
          };
        })(this)
      };
    };

    CalendarView.prototype.cssForDate = function(date, periodIsDay) {
      var differentMonth, inRange, obj1, onRangeEnd, withinBoundaries;
      onRangeEnd = date.isSame(this.activeDate(), this.period());
      withinBoundaries = this.activeDate.isWithinBoundaries(date);
      periodIsDay || (periodIsDay = this.period() === 'day');
      differentMonth = !date.isSame(this.currentDate(), 'month');
      inRange = this.inRange(date);
      return (
        obj1 = {
          "in-range": !this.single() && (inRange || onRangeEnd)
        },
        obj1[this.type + "-date"] = onRangeEnd,
        obj1["clickable"] = withinBoundaries && !this.isCustomPeriodRangeActive(),
        obj1["out-of-boundaries"] = !withinBoundaries || this.isCustomPeriodRangeActive(),
        obj1["unavailable"] = periodIsDay && differentMonth,
        obj1
      );
    };

    CalendarView.prototype.firstYearOfDecade = function(date) {
      var currentYear, firstYear, offset, year;
      currentYear = MomentUtil.tz(moment(), this.timeZone()).year();
      firstYear = currentYear - 4;
      offset = Math.floor((date.year() - firstYear) / 9);
      year = firstYear + offset * 9;
      return MomentUtil.tz([year], this.timeZone());
    };

    return CalendarView;

  })();

  DateRangePickerView = (function() {
    function DateRangePickerView(options) {
      var endDate, ref, startDate, wrapper;
      if (options == null) {
        options = {};
      }
      this.outsideClick = bind(this.outsideClick, this);
      this.setCustomPeriodRange = bind(this.setCustomPeriodRange, this);
      this.setDateRange = bind(this.setDateRange, this);
      new Config(options).extend(this);
      this.startCalendar = new CalendarView(this, this.startDate, 'start');
      this.endCalendar = new CalendarView(this, this.endDate, 'end');
      this.startDateInput = this.startCalendar.inputDate;
      this.endDateInput = this.endCalendar.inputDate;
      this.dateRange = ko.observable([this.startDate(), this.endDate()]);
      this.startDate.subscribe((function(_this) {
        return function(newValue) {
          if (_this.single()) {
            _this.endDate(newValue.clone().endOf(_this.period()));
            _this.updateDateRange();
            return _this.close();
          } else {
            if (_this.endDate().isSame(newValue)) {
              _this.endDate(_this.endDate().clone().endOf(_this.period()));
            }
            if (_this.standalone()) {
              return _this.updateDateRange();
            }
          }
        };
      })(this));
      this.endDate.subscribe((function(_this) {
        return function(newValue) {
          if (!_this.single() && _this.standalone()) {
            return _this.updateDateRange();
          }
        };
      })(this));
      this.style = ko.observable({});
      if (this.callback) {
        this.dateRange.subscribe((function(_this) {
          return function(newValue) {
            var endDate, startDate;
            startDate = newValue[0], endDate = newValue[1];
            return _this.callback(startDate.clone(), endDate.clone(), _this.period());
          };
        })(this));
        if (this.forceUpdate) {
          ref = this.dateRange(), startDate = ref[0], endDate = ref[1];
          this.callback(startDate.clone(), endDate.clone(), this.period());
        }
      }
      if (this.anchorElement) {
        wrapper = $("<div data-bind=\"stopBinding: true\"></div>").appendTo(this.parentElement);
        this.containerElement = $(this.constructor.template).appendTo(wrapper);
        ko.applyBindings(this, this.containerElement.get(0));
        this.anchorElement.click((function(_this) {
          return function() {
            _this.updatePosition();
            return _this.toggle();
          };
        })(this));
        if (!this.standalone()) {
          $(document).on('mousedown.daterangepicker', this.outsideClick).on('touchend.daterangepicker', this.outsideClick).on('click.daterangepicker', '[data-toggle=dropdown]', this.outsideClick).on('focusin.daterangepicker', this.outsideClick);
        }
      }
      if (this.opened()) {
        this.updatePosition();
      }
    }

    DateRangePickerView.prototype.periodProxy = Period;

    DateRangePickerView.prototype.calendars = function() {
      if (this.single()) {
        return [this.startCalendar];
      } else {
        return [this.startCalendar, this.endCalendar];
      }
    };

    DateRangePickerView.prototype.updateDateRange = function() {
      return this.dateRange([this.startDate(), this.endDate()]);
    };

    DateRangePickerView.prototype.cssClasses = function() {
      var j, len, obj, period, ref;
      obj = {
        single: this.single(),
        opened: this.standalone() || this.opened(),
        expanded: this.standalone() || this.single() || this.expanded(),
        standalone: this.standalone(),
        'hide-weekdays': this.hideWeekdays(),
        'hide-periods': (this.periods().length + this.customPeriodRanges.length) === 1,
        'orientation-left': this.orientation() === 'left',
        'orientation-right': this.orientation() === 'right'
      };
      ref = Period.allPeriods;
      for (j = 0, len = ref.length; j < len; j++) {
        period = ref[j];
        obj[period + "-period"] = period === this.period();
      }
      return obj;
    };

    DateRangePickerView.prototype.isActivePeriod = function(period) {
      return this.period() === period;
    };

    DateRangePickerView.prototype.isActiveDateRange = function(dateRange) {
      var dr, j, len, ref;
      if (dateRange.constructor === CustomDateRange) {
        ref = this.ranges;
        for (j = 0, len = ref.length; j < len; j++) {
          dr = ref[j];
          if (dr.constructor !== CustomDateRange && this.isActiveDateRange(dr)) {
            return false;
          }
        }
        return true;
      } else {
        return this.startDate().isSame(dateRange.startDate, 'day') && this.endDate().isSame(dateRange.endDate, 'day');
      }
    };

    DateRangePickerView.prototype.isActiveCustomPeriodRange = function(customPeriodRange) {
      return this.isActiveDateRange(customPeriodRange) && this.isCustomPeriodRangeActive();
    };

    DateRangePickerView.prototype.inputFocus = function() {
      return this.expanded(true);
    };

    DateRangePickerView.prototype.setPeriod = function(period) {
      this.isCustomPeriodRangeActive(false);
      this.period(period);
      return this.expanded(true);
    };

    DateRangePickerView.prototype.setDateRange = function(dateRange) {
      if (dateRange.constructor === CustomDateRange) {
        return this.expanded(true);
      } else {
        this.expanded(false);
        this.close();
        this.period('day');
        this.startDate(dateRange.startDate);
        this.endDate(dateRange.endDate);
        return this.updateDateRange();
      }
    };

    DateRangePickerView.prototype.setCustomPeriodRange = function(customPeriodRange) {
      this.isCustomPeriodRangeActive(true);
      return this.setDateRange(customPeriodRange);
    };

    DateRangePickerView.prototype.applyChanges = function() {
      this.close();
      return this.updateDateRange();
    };

    DateRangePickerView.prototype.cancelChanges = function() {
      return this.close();
    };

    DateRangePickerView.prototype.open = function() {
      return this.opened(true);
    };

    DateRangePickerView.prototype.close = function() {
      if (!this.standalone()) {
        return this.opened(false);
      }
    };

    DateRangePickerView.prototype.toggle = function() {
      if (this.opened()) {
        return this.close();
      } else {
        return this.open();
      }
    };

    DateRangePickerView.prototype.updatePosition = function() {
      var parentOffset, parentRightEdge, style;
      if (this.standalone()) {
        return;
      }
      parentOffset = {
        top: 0,
        left: 0
      };
      parentRightEdge = $(window).width();
      if (!this.parentElement.is('body')) {
        parentOffset = {
          top: this.parentElement.offset().top - this.parentElement.scrollTop(),
          left: this.parentElement.offset().left - this.parentElement.scrollLeft()
        };
        parentRightEdge = this.parentElement.get(0).clientWidth + this.parentElement.offset().left;
      }
      style = {
        top: (this.anchorElement.offset().top + this.anchorElement.outerHeight() - parentOffset.top) + 'px',
        left: 'auto',
        right: 'auto'
      };
      switch (this.orientation()) {
        case 'left':
          if (this.containerElement.offset().left < 0) {
            style.left = '9px';
          } else {
            style.right = (parentRightEdge - (this.anchorElement.offset().left) - this.anchorElement.outerWidth()) + 'px';
          }
          break;
        default:
          if (this.containerElement.offset().left + this.containerElement.outerWidth() > $(window).width()) {
            style.right = '0';
          } else {
            style.left = (this.anchorElement.offset().left - parentOffset.left) + 'px';
          }
      }
      return this.style(style);
    };

    DateRangePickerView.prototype.outsideClick = function(event) {
      var target;
      target = $(event.target);
      if (!(event.type === 'focusin' || target.closest(this.anchorElement).length || target.closest(this.containerElement).length || target.closest('.calendar').length)) {
        return this.close();
      }
    };

    return DateRangePickerView;

  })();

  DateRangePickerView.template = '<div class="daterangepicker" data-bind="css: $data.cssClasses(), style: $data.style()"> <div class="controls"> <ul class="periods"> <!-- ko foreach: $data.periods --> <li class="period" data-bind="css: {active: $parent.isActivePeriod($data) && !$parent.isCustomPeriodRangeActive()}, text: $parent.periodProxy.title($data), click: function(){ $parent.setPeriod($data); }"></li> <!-- /ko --> <!-- ko foreach: $data.customPeriodRanges --> <li class="period" data-bind="css: {active: $parent.isActiveCustomPeriodRange($data)}, text: $data.title, click: function(){ $parent.setCustomPeriodRange($data); }"></li> <!-- /ko --> </ul> <ul class="ranges" data-bind="foreach: $data.ranges"> <li class="range" data-bind="css: {active: $parent.isActiveDateRange($data)}, text: $data.title, click: function(){ $parent.setDateRange($data); }"></li> </ul> <form data-bind="submit: $data.applyChanges"> <div class="custom-range-inputs"> <input type="text" data-bind="value: $data.startDateInput, event: {focus: $data.inputFocus}" /> <input type="text" data-bind="value: $data.endDateInput, event: {focus: $data.inputFocus}" /> </div> <div class="custom-range-buttons"> <button class="apply-btn" type="submit" data-bind="text: $data.locale.applyButtonTitle, click: $data.applyChanges"></button> <button class="cancel-btn" data-bind="text: $data.locale.cancelButtonTitle, click: $data.cancelChanges"></button> </div> </form> </div> <!-- ko foreach: $data.calendars() --> <div class="calendar"> <div class="calendar-title" data-bind="text: $data.label"></div> <div class="calendar-header" data-bind="with: $data.headerView"> <div class="arrow" data-bind="css: $data.prevArrowCss()"> <button data-bind="click: $data.clickPrevButton"><span class="arrow-left"></span></button> </div> <div class="calendar-selects"> <select class="month-select" data-bind="options: $data.monthOptions(), optionsText: $data.monthFormatter, valueAllowUnset: true, value: $data.selectedMonth, css: {hidden: !$data.monthSelectorAvailable()}"></select> <select class="year-select" data-bind="options: $data.yearOptions(), optionsText: $data.yearFormatter, valueAllowUnset: true, value: $data.selectedYear, css: {hidden: !$data.yearSelectorAvailable()}"></select> <select class="decade-select" data-bind="options: $data.decadeOptions(), optionsText: $data.decadeFormatter, valueAllowUnset: true, value: $data.selectedDecade, css: {hidden: !$data.decadeSelectorAvailable()}"></select> </div> <div class="arrow" data-bind="css: $data.nextArrowCss()"> <button data-bind="click: $data.clickNextButton"><span class="arrow-right"></span></button> </div> </div> <div class="calendar-table"> <!-- ko if: $parent.periodProxy.showWeekDayNames($data.period()) --> <div class="table-row weekdays" data-bind="foreach: $data.weekDayNames()"> <div class="table-col"> <div class="table-value-wrapper"> <div class="table-value" data-bind="text: $data"></div> </div> </div> </div> <!-- /ko --> <!-- ko foreach: $data.calendar() --> <div class="table-row" data-bind="foreach: $data"> <div class="table-col" data-bind="event: $parents[1].eventsForDate($data), css: $parents[1].cssForDate($data)"> <div class="table-value-wrapper" data-bind="foreach: $parents[1].tableValues($data)"> <div class="table-value" data-bind="html: $data.html, css: $data.css"></div> </div> </div> </div> <!-- /ko --> </div> </div> <!-- /ko --> </div>';

  $.extend($.fn.daterangepicker, {
    ArrayUtils: ArrayUtils,
    MomentIterator: MomentIterator,
    MomentUtil: MomentUtil,
    Period: Period,
    Config: Config,
    DateRange: DateRange,
    AllTimeDateRange: AllTimeDateRange,
    CustomDateRange: CustomDateRange,
    DateRangePickerView: DateRangePickerView,
    CalendarView: CalendarView,
    CalendarHeaderView: CalendarHeaderView
  });

}).call(this);
