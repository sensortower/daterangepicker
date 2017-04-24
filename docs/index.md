# Documentation

## Installation

You can download daterangepicker using bower:

```bash
bower install daterangepicker --save
```

Or you can always download the latest release [from Github](https://github.com/sensortower/daterangepicker/releases).

## Integration

### jQuery

jQuery integration includes `daterangepicker` function that takes 2 parameters: configuration & callback.

```javascript
$("input").daterangepicker({
  minDate: moment().subtract(2, 'years')
}, function (startDate, endDate, period) {
  $(this).val(startDate.format('L') + ' – ' + endDate.format('L'))
});
```

### Knockout

If you're using Knockout, there's a custom binding you can use:

```html
<input type="text" data-bind="daterangepicker: dateRange, daterangepickerOptions: { maxDate: moment() }"/>
```

```javascript
ko.applyBindings({
  dateRange: ko.observable([moment().subtract(1, 'month'), moment(), 'day'])
});
```

## Configuration

### timeZone

Sets time zone. If you want to use user's computer time zone, pass `null`. By default, it's UTC. If you want to use other time zones you will need [moment.timezone](http://momentjs.com/timezone/) library.

```javascript
timeZone: String
```

Default:
```javascript
timeZone: 'utc'
```

Examples:
```javascript
timeZone: 'Australia/Sydney'
timeZone: null // user's computer time zone
```


### firstDayOfWeek

Sets first day of the week. 0 is Sunday, 1 is Monday. In case you were wondering, 4 is Thursday.

```javascript
firstDayOfWeek: Number
```

__Important__: this setting will globally change moment.js locale


Default:
```javascript
firstDayOfWeek: 1 // Monday
```

### minDate

Sets a minimum possible date a user can select.

```javascript
minDate: [(moment.js-compatible object), ('inclusive' | 'exclusive' | 'expanded')]
```

By default, that means you can select days (weeks, months, etc) that are the same as `minDate` or after `minDate` — this is what we call __inclusive__ mode. In __exclusive__ you can't select days (weeks, months, etc) that fall on `minDate`. When you select a month (week, quarter, etc) in __expanded__ mode and `minDate` falls on the middle of the month, the first day of the month will be selected.

For example, if `minDate` is 14th of February, `period` is set to `month` and you click on February, the new `startDate` is:

* __inclusive__ mode: 14th of February;
* __exclusive__ mode: You won't be able to select February, minimum available date will be March 1st;
* __expanded__ mode: 1st of February.


Default:
```javascript
minDate: [moment().subtract(30, 'years'), 'inclusive']
```

Examples:
```javascript
minDate: '2015-11-10' // mode defaults to inclusive
minDate: moment().subtract(2, 'years')
minDate: ['2015-11-10', 'expanded']
minDate: ['2015-11-10', 'exclusive']
minDate: [null, 'exclusive'] // date defaults to moment().subtract(2, 'years')
```


### maxDate

Sets a maximum possible date a user can select.

```javascript
maxDate: [(moment.js-compatible object), ('inclusive' | 'exclusive' | 'expanded')]
```

By default, that means you can select days (weeks, months, etc) that are the same as `maxDate` or after `maxDate` — this is what we call __inclusive__ mode. In __exclusive__ you can't select days (weeks, months, etc) that fall on `maxDate`. When you select a month (week, quarter, etc) in __expanded__ mode and `maxDate` falls on the middle of the month, the last day of the month will be selected.

For example, if `maxDate` is 14th of February, `period` is set to `month` and you click on February, the new `startDate` is:

* __inclusive__ mode: 14th of February;
* __exclusive__ mode: You won't be able to select February, maximum available date will be January 31st;
* __expanded__ mode: 28th of February.


Default:
```javascript
maxDate: [moment(), 'inclusive']
```

Examples:
```javascript
maxDate: '2015-11-10' // mode defaults to inclusive
maxDate: moment().add(2, 'years')
maxDate: ['2015-11-10', 'expanded']
maxDate: ['2015-11-10', 'exclusive']
maxDate: [null, 'exclusive'] // date defaults to moment().subtract(2, 'years')
```

### startDate

This parameter sets the initial value for start date.

```javascript
startDate: (moment.js-compatible object)
```

Default:
```javascript
startDate: moment().subtract(29, 'days')
```

Examples:
```javascript
startDate: new Date()
startDate: '2015-11-10'
startDate: [2015, 11, 10]
startDate: 1449159600
startDate: moment().subtract(1, 'week')
```

### endDate

This parameter sets the initial value for end date.

```javascript
endDate: (moment.js-compatible object)
```

Default:
```javascript
endDate: moment()
```

Examples:
```javascript
endDate: new Date()
endDate: '2015-11-10'
endDate: [2015, 11, 10]
endDate: 1449159600
endDate: moment().add(1, 'week')
```


### ranges

Sets predefined date ranges a user can select from.

```javascript
ranges: Object
```

Default:
```javascript
{
  'Last 30 days': [moment().subtract(29, 'days'), moment()],
  'Last 90 days': [moment().subtract(89, 'days'), moment()],
  'Last Year': [moment().subtract(1, 'year').add(1,'day'), moment()],
  'All Time': 'all-time' // [minDate, maxDate],
  'Custom Range': 'custom'
}
```

Examples:
```javascript
ranges: {
  'Last 245 Days': [moment().subtract(244, 'days'), moment()],
  'Last 3 Years': [moment().subtract(3, 'years').add(1, 'day'), moment()]
}
```


### period

This parameter sets the initial value for period.

```javascript
period: ('day' | 'week' | 'month' | 'quarter' | 'year')
```

Default:
```javascript
period: @periods[0]
```


### periods

Array of available _periods_. Period selector disappears if only one period specified.


```javascript
periods: String[]
```

### customPeriodRanges

Similar to ranges except they are appended to the period row across the top of the picker.

```javascript
ranges: Object
```

Examples:
```javascript
customPeriodRanges: {
  'Last Year': [moment().subtract(1, 'year').add(1,'day'), moment()],
  'All Time': 'all-time' // [minDate, maxDate]
}
```

### single
```javascript
single: Boolean
```

Default:
```javascript
single: false
```


### orientation

```javascript
orientation: ('left' | 'right')
```

Sets the side to which daterangepicker opens.

Default:
```javascript
orientation: 'left'
```


### opened

```javascript
opened: Boolean
```

By default, daterangepicker is hidden and you need to click the anchorElement to open it. This option allows you to make it opened on initialization.

Default:
```javascript
opened: false
```


### expanded

```javascript
expanded: Boolean
```

By default, when you open daterangepicker you only see predefined ranges. This option allows you to make it expanded on initialization.

Default:
```javascript
expanded: false
```


### standalone

```javascript
standalone: Boolean
```

Set `standalone` to true to append daterangepicker to anchorElement.

Default:
```javascript
standalone: false
```


### hideWeekdays

```javascript
hideWeekdays: Boolean
```

Set `hideWeekdays` to true to hide week days in day & week modes.

Default:
```javascript
hideWeekdays: false
```


### anchorElement

```javascript
anchorElement: (jQuery-compatible object)
```

Allows you to set anchor element for daterangepicker.

Examples:
```javascript
anchorElement: '.daterange-field'
anchorElement: $('.daterange-field')
anchorElement: document.querySelector('.daterange-field')
```


### parentElement

```javascript
parentElement: (jQuery-compatible object)
```

Allows you to set parent element for daterangepicker.

Default:
```javascript
parentElement: document.body
```

Examples:
```javascript
parentElement: '.daterangepicker-container'
parentElement: $('.daterangepicker-container')
parentElement: document.querySelector('.daterangepicker-container')
```


### forceUpdate

```javascript
forceUpdate: Boolean
```

Immediately invokes `callback` after constructing daterangepicker.

Default:
```javascript
forceUpdate: false
```


## Customization

Source code is available on [GitHub](https://github.com/sensortower/daterangepicker) for you to fork or monkey-patch. Here are some starting points:
* [Main view](https://github.com/sensortower/daterangepicker/blob/master/src/scripts/daterangepicker/date-range-picker-view.coffee);
* [$.fn.daterangepicker implementation](https://github.com/sensortower/daterangepicker/blob/master/src/scripts/daterangepicker/util/jquery.coffee);
* [Integration with Knockout](https://github.com/sensortower/daterangepicker/blob/master/src/scripts/daterangepicker/util/knockout.coffee);
* [The template](https://github.com/sensortower/daterangepicker/blob/master/src/templates/daterangepicker.html).

All classes used in daterangepicker are accessable through `$.fn.daterangepicker`:

* `$.fn.daterangepicker.ArrayUtils`
* `$.fn.daterangepicker.MomentIterator`
* `$.fn.daterangepicker.MomentUtil`
* `$.fn.daterangepicker.Period`
* `$.fn.daterangepicker.Config`
* `$.fn.daterangepicker.DateRange`
* `$.fn.daterangepicker.AllTimeDateRange`
* `$.fn.daterangepicker.CustomDateRange`
* `$.fn.daterangepicker.DateRangePickerView`
* `$.fn.daterangepicker.CalendarView`
* `$.fn.daterangepicker.CalendarHeaderView`

