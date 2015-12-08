# daterangepicker

[![Demo screenshot](https://sensortower.github.io/daterangepicker/images/demo.gif)](https://sensortower.github.io/daterangepicker/)

[Demo available here](https://sensortower.github.io/daterangepicker/)

## Notable Features

* Day / Week / Month / Quarter / Year calendar modes
* Single calendar mode
* Customazible & extendable
* Integration with jQuery & Knockout

## Dependencies

* jquery
* moment
* knockout

## Download

[Latest Release](https://github.com/sensortower/daterangepicker/releases)

## Install
```bash
bower install daterangepicker --save
```
## Usage
### With jQuery
```javascript
$("input").daterangepicker({
  minDate: moment().subtract(2, 'years'),
  callback: function (startDate, endDate, period) {
    console.log(startDate.format('L'), endDate.format('L'), period);
  }
});
```
### With Knockout.js
```html
<input type="text" data-bind="daterangepicker: dateRange, daterangepickerOptions: { maxDate: moment() }"/>
```

```javascript
ko.applyBindings({
  dateRange: ko.observable([moment().subtract(1, 'month'), moment(), 'day'])
});
```

## Development

```bash
git clone git@github.com:sensortower/daterangepicker.git && cd daterangepicker
npm install && bower install
gulp serve
```


## Copyright

Copyright © 2015 SensorTower Inc. See LICENSE for further details.
