describe 'Period', ->
  Period = $.fn.daterangepicker.Period
  describe '##extendObservable()', ->
    it 'should work', () ->
      observable = Period.extendObservable(ko.observable('quarter'))
      assert.equal(observable.format(), Period.format('quarter'))
