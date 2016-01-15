describe 'DateRangePickerView', ->
  $('.secondary-section').after($("<div id='daterangepickerview-test-container' style='display: none'></div>"))
  parentSelector = '#daterangepickerview-test-container'

  DateRangePickerView = (options = {}) ->
    new $.fn.daterangepicker.DateRangePickerView($.extend(options, {
      parentElement: parentSelector
    }))

  describe '#calendars', ->
    it 'defaults to two', ->
      d = new DateRangePickerView()
      assert.equal(d.calendars().length, 2)

    it 'has single calendar when single is set', ->
      d = new DateRangePickerView({
        single: true
      })
      assert.equal(d.calendars().length, 1)

  describe 'forceUpdate', ->
    it 'does not invoke callback on creation when undefined', ->
      called = false
      cb = -> called = true
      d = new DateRangePickerView({
        callback: cb
      })
      assert.isFalse(called)
    it 'invokes callback on creation when true', ->
      called = false
      cb = -> called = true
      d = new DateRangePickerView({
        callback: cb,
        forceUpdate: true
      })
      assert.isTrue(called)

  describe '#isActivePeriod', ->
    it 'defaults to day when no custom periods defined', ->
      d = new DateRangePickerView({})
      assert.isTrue(d.isActivePeriod('day'))
    it 'defaults to first period when custom periods defined', ->
      d = new DateRangePickerView({
        periods: ['month', 'week', 'day']
      })
      assert.isTrue(d.isActivePeriod('month'))

  describe '#setPeriod', ->
    it 'works with valid period', ->
      d = new DateRangePickerView({})
      d.setPeriod('week')
      assert.equal(d.isActivePeriod('week'), true)

  describe '#setDateRange #isActiveDateRange', ->
    it 'works with default ranges', ->
      d = new DateRangePickerView({})
      range = d.ranges[0]
      assert.instanceOf(range, $.fn.daterangepicker.DateRange)
      d.setDateRange(range)
      assert.isTrue(d.isActiveDateRange(range))
    it 'works with custom ranges', ->
      d = new DateRangePickerView({
        ranges: {
          'May 2015': [moment.utc('2015-05-01'), moment.utc('2015-05-31')]
        }
      })
      range = d.ranges[0]
      assert.instanceOf(range, $.fn.daterangepicker.DateRange)
      d.setDateRange(range)
      assert.isTrue(d.isActiveDateRange(range))

  describe 'open and closed states', ->
    it 'is not open by default', ->
      d = new DateRangePickerView({})
      assert.isFalse(d.opened())
    it 'works with opened flag', ->
      $(parentSelector).append($("<div id='open-test-anchor-one'></div>"))
      d = new DateRangePickerView({
        opened: true,
        anchorElement: '#open-test-anchor-one'
      })
      assert.isTrue(d.opened())
    describe 'interaction methods', ->
      d = new DateRangePickerView({})

      it 'works with #open', ->
        assert.isFalse(d.opened())
        d.open()
        assert.isTrue(d.opened())
      it 'works with #close', ->
        d.close()
        assert.isFalse(d.opened())
      it 'works with #toggle', ->
        d.toggle()
        assert.isTrue(d.opened())
        d.toggle()
        assert.isFalse(d.opened())
