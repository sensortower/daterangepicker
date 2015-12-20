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

## Documentation

[Documentation](https://sensortower.github.io/daterangepicker/docs) & [Examples](https://sensortower.github.io/daterangepicker/examples) are available on our website.

## Download

[Latest Release](https://github.com/sensortower/daterangepicker/releases)

## Install

```bash
bower install knockout-daterangepicker --save
```

## Usage

### With jQuery
```javascript
$("input").daterangepicker({
  minDate: moment().subtract(2, 'years'),
  callback: function (startDate, endDate, period) {
    $(this).val(startDate.format('L') + ' – ' + endDate.format('L'));
  }
});
```

### With Knockout.js
```html
<input type="text" data-bind="daterangepicker: dateRange"/>
```

```javascript
ko.applyBindings({
  dateRange: ko.observable([moment().subtract(1, 'month'), moment()])
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

[![Analytics](https://ga-beacon.appspot.com/UA-71619034-2/daterangepicker/README)](https://github.com/igrigorik/ga-beacon)
