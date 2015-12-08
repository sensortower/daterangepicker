## daterangepicker attached to an input

```html
<input data-bind="daterangepicker: dateRange" />
```


## daterangepicker attached to a button

```html
<button data-bind="daterangepicker: dateRange2"></button>
```


## Single mode

```html
<input data-bind="
  daterangepicker: dateRange3,
  daterangepickerOptions: {
    single: true
  }
"/>
```


## Month picker

```html
<input data-bind="
  daterangepicker: dateRange4,
  daterangepickerFormat: 'MMMM YYYY',
  daterangepickerOptions: {
    single: true,
    periods: ['month']
  }
"/>
```


## Standalone & Single

```html
<div data-bind="
  daterangepicker: dateRange5,
  daterangepickerFormat: 'MMMM YYYY',
  daterangepickerOptions: {
    single: true,
    standalone: true
  }
"/>
```


## jQuery example

```html
<input class="daterangepicker-field"></input>
```

```javascript
$(".daterangepicker-field").daterangepicker({
  forceUpdate: true,
  callback: function(startDate, endDate, period){
    var title = startDate.format('L') + ' – ' + endDate.format('L');
    $(this).val(title)
  }
});
```
