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
```javascript
timeZone: String
```

Sets time zone. If you want to use user's computer time zone, pass `null`. By default, it's UTC. If you want to use other time zones you will need [moment.timezone](http://momentjs.com/timezone/) library.

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
```javascript
firstDayOfWeek: Number
```

Sets first day of the week. 0 is Sunday, 1 is Monday. In case you were wondering, 4 is Thursday.

__Important__: this setting will globally change moment.js locale


Default:
```javascript
firstDayOfWeek: 1 // Monday
```

### minDate
```javascript
minDate: [(moment.js-compatible object), ('inclusive' | 'exclusive' | 'expanded')]
```

Sets a minimum possible date a user can select. By default, that means you can select days (weeks, months, etc) that are the same as `minDate` or after `minDate` — this is what we call __inclusive__ mode. In __exclusive__ you can't select days (weeks, months, etc) that fall on `minDate`. When you select a month (week, quarter, etc) in __expanded__ mode and `minDate` falls on the middle of the month, the first day of the month will be selected.

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
```javascript
maxDate: [(moment.js-compatible object), ('inclusive' | 'exclusive' | 'expanded')]
```

Sets a minimum possible date a user can select. By default, that means you can select days (weeks, months, etc) that are the same as `maxDate` or after `maxDate` — this is what we call __inclusive__ mode. In __exclusive__ you can't select days (weeks, months, etc) that fall on `maxDate`. When you select a month (week, quarter, etc) in __expanded__ mode and `maxDate` falls on the middle of the month, the last day of the month will be selected.

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
```javascript
startDate: (moment.js-compatible object)
```

Sets the start date.

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
```javascript
endDate: (moment.js-compatible object)
```

Sets the end date.

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
```javascript
ranges: Object
```

Default:
```javascript
{
  'Last 30 days': [moment().subtract(29, 'days'), moment()]
  'Last 90 days': [moment().subtract(89, 'days'), moment()]
  'Last Year': [moment().subtract(1, 'year').add(1,'day'), moment()]
  'All Time': 'all-time' // [minDate, maxDate]
  'Custom Range': 'custom'
}
```

Examples:
```javascript
ranges: {
  'Last 245 Days': [moment().subtract(244, 'days'), moment()]
  'Last 3 Years': [moment().subtract(3, 'years').add(1, 'day'), moment()]
}
```

### period
```javascript
period: ('day' | 'week' | 'month' | 'quarter' | 'year')
```

Default:
```javascript
period: 'day'
```

### periods
```javascript
periods: String[]
```

Array of available periods



### single
```javascript
single: Boolean
```

Default:
```javascript
single: false
```

Examples:
```javascript
single: false
single: true
```


### opens
```javascript
opens: Boolean
```

Default:
```javascript
opens: false
```

Examples:
```javascript
opens: false
opens: true
```


### opened
```javascript
opened: Boolean
```

Default:
```javascript
opened: false
```

Examples:
```javascript
opened: false
opened: true
```


### expanded
```javascript
expanded: Boolean
```

Default:
```javascript
expanded: false
```

Examples:
```javascript
expanded: false
expanded: true
```


### standalone
```javascript
standalone: Boolean
```

Default:
```javascript
standalone: false
```

Examples:
```javascript
standalone: false
standalone: true
```



### anchorElement
```javascript
anchorElement: (jQuery-compatible object)
```


### parentElement
```javascript
parentElement: (jQuery-compatible object)
```

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




### callback

## API

### startDate
```javascript
daterangepicker.startDate(moment.js-compatible object)
```

Allows you to dynamically set startDate.

### endDate
```javascript
daterangepicker.endDate(moment.js-compatible object)
```

Allows you to dynamically set endDate.

### period
```javascript
daterangepicker.period('day' | 'week' | 'month' | 'quarter' | 'year')
```

Allows you to dynamically set period.

## Customizing


