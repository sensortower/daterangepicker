describe 'Config', ->
  Config = $.fn.daterangepicker.Config
  fmt = 'YYYY-MM-DD'

  describe 'orientation', ->
    it 'defaults to right', () ->
      c = new Config({})
      assert.equal(c.orientation(), 'right')

    it 'works with a valid value (left)', () ->
      c = new Config({ orientation: 'left' })
      assert.equal(c.orientation(), 'left')

    it 'throws an exception with an invalid value', () ->
      assert.throw( ->
        c = new Config({ orientation: 'invalid' })
      , /Invalid orientation/)

  describe 'period', ->
    it 'defaults to day', () ->
      c = new Config({})
      assert.equal(c.period(), 'day')

    it 'works with a valid value (week)', () ->
      c = new Config({ period: 'week' })
      assert.equal(c.period(), 'week')

    it 'throws an exception with an invalid value', () ->
      assert.throw( ->
        c = new Config({ period: 'invalid' })
      , /Invalid period/)

  describe 'callback', ->
    it 'defaults to undefined', () ->
      c = new Config({})
      assert.equal(c.callback, undefined)

    it 'works with a valid value', () ->
      cb = -> console.log('test')
      c = new Config({
        callback: cb
      })
      assert.equal(c.callback, cb)

    it 'throws an exception with an invalid value', () ->
      assert.throw( ->
        c = new Config({ callback: 'invalid' })
      , /Invalid callback/)

  describe 'forceUpdate', ->
    it 'defaults to undefined', () ->
      c = new Config({})
      assert.equal(c.forceUpdate, undefined)

  describe 'ranges', ->
    it 'works with a valid object', () ->
      new Config({
        ranges: {
          "Test Range": ['2015-05-14', moment()]
        }
      })

    it 'fails with a parameter that is not an object', () ->
      assert.throw( ->
        new Config({
          ranges: "invalid parameter"
        })
      , /Invalid ranges/)

    it 'fails with a "complex" object', () ->
      TestClass = ->
        this["Test Range"] = ['2015-05-14', moment()]

      assert.throw( ->
        new Config({
          ranges: new TestClass()
        })
      , /Invalid ranges/)

    it 'fails with a object value that is not an array', () ->
      assert.throw( ->
        new Config({
          ranges: {
            'Test Range': '2015-05-14' # potential typo
          }
        })
      , /Value should be an array/)

    it 'fails with a missing start date', () ->
      assert.throw( ->
        new Config({
          ranges: {
            'Test Range': [undefined, '2015-05-14']
          }
        })
      , /Missing start date/)

    it 'fails with a missing end date', () ->
      assert.throw( ->
        new Config({
          ranges: {
            'Test Range': ['2015-05-14']
          }
        })
      , /Missing end date/)

  describe 'customPeriodRanges', ->
    it 'works with a valid object', () ->
      new Config({
        customPeriodRanges: {
          "Test Range": ['2015-05-14', moment()]
        }
      })

    it 'fails with a object value that is not an array', () ->
      assert.throw( ->
        new Config({
          ranges: {
            'Test Range': '2015-05-14'
          }
        })
      , /Value should be an array/)

  describe '_dateObservable', ->
    describe '#fit()', ->
      describe 'minDate = 2015-05-14, period = month', ->
        describe 'inclusive mode', ->
          c = new Config({
            period: 'month'
            minDate: [moment.utc('2015-05-14'), 'inclusive']
            maxDate: [moment.utc('2016-01-01'), 'inclusive']
          })

          it 'converts 2015-04-15 into 2015-05-14', () ->
            assert.equal(c.startDate.fit('2015-04-15').format(fmt), '2015-05-14')

          it 'converts 2015-05-05 into 2015-05-14', () ->
            assert.equal(c.startDate.fit('2015-05-05').format(fmt), '2015-05-14')

          it 'converts 2015-05-14 into 2015-05-14', () ->
            assert.equal(c.startDate.fit('2015-05-14').format(fmt), '2015-05-14')

          it 'converts 2015-05-25 into 2015-05-25', () ->
            assert.equal(c.startDate.fit('2015-05-25').format(fmt), '2015-05-25')

          it 'converts 2015-06-15 into 2015-06-15', () ->
            assert.equal(c.startDate.fit('2015-06-15').format(fmt), '2015-06-15')

        describe 'exclusive mode', ->
          c = new Config({
            period: 'month'
            minDate: [moment.utc('2015-05-14'), 'exclusive']
            maxDate: [moment.utc('2016-01-01'), 'inclusive']
          })

          it 'converts 2015-04-15 into 2015-06-01', () ->
            assert.equal(c.startDate.fit('2015-04-15').format(fmt), '2015-06-01')

          it 'converts 2015-05-05 into 2015-06-01', () ->
            assert.equal(c.startDate.fit('2015-05-05').format(fmt), '2015-06-01')

          it 'converts 2015-05-14 into 2015-06-01', () ->
            assert.equal(c.startDate.fit('2015-05-14').format(fmt), '2015-06-01')

          it 'converts 2015-05-25 into 2015-06-01', () ->
            assert.equal(c.startDate.fit('2015-05-25').format(fmt), '2015-06-01')

          it 'converts 2015-06-15 into 2015-06-15', () ->
            assert.equal(c.startDate.fit('2015-06-15').format(fmt), '2015-06-15')

        describe 'extended mode', ->
          c = new Config({
            period: 'month'
            minDate: [moment.utc('2015-05-14'), 'extended']
            maxDate: [moment.utc('2016-01-01'), 'inclusive']
          })

          it 'converts 2015-04-15 into 2015-05-01', () ->
            assert.equal(c.startDate.fit('2015-04-15').format(fmt), '2015-05-01')

          it 'converts 2015-05-05 into 2015-05-05', () ->
            assert.equal(c.startDate.fit('2015-05-05').format(fmt), '2015-05-05')

          it 'converts 2015-05-14 into 2015-05-14', () ->
            assert.equal(c.startDate.fit('2015-05-14').format(fmt), '2015-05-14')

          it 'converts 2015-05-25 into 2015-05-25', () ->
            assert.equal(c.startDate.fit('2015-05-25').format(fmt), '2015-05-25')

          it 'converts 2015-06-15 into 2015-06-15', () ->
            assert.equal(c.startDate.fit('2015-06-15').format(fmt), '2015-06-15')

      describe 'maxDate = 2015-05-14, period = month', ->
        describe 'inclusive mode', ->
          c = new Config({
            period: 'month'
            minDate: [moment.utc('2014-01-01'), 'inclusive']
            maxDate: [moment.utc('2015-05-14'), 'inclusive']
          })

          it 'converts 2015-04-15 into 2015-04-15', () ->
            assert.equal(c.startDate.fit('2015-04-15').format(fmt), '2015-04-15')

          it 'converts 2015-05-05 into 2015-05-05', () ->
            assert.equal(c.startDate.fit('2015-05-05').format(fmt), '2015-05-05')

          it 'converts 2015-05-14 into 2015-05-14', () ->
            assert.equal(c.startDate.fit('2015-05-14').format(fmt), '2015-05-14')

          it 'converts 2015-05-25 into 2015-05-14', () ->
            assert.equal(c.startDate.fit('2015-05-25').format(fmt), '2015-05-14')

          it 'converts 2015-06-15 into 2015-05-14', () ->
            assert.equal(c.startDate.fit('2015-06-15').format(fmt), '2015-05-14')

        describe 'exclusive mode', ->
          c = new Config({
            period: 'month'
            minDate: [moment.utc('2014-01-01'), 'inclusive']
            maxDate: [moment.utc('2015-05-14'), 'exclusive']
          })

          it 'converts 2015-04-15 into 2015-04-15', () ->
            assert.equal(c.startDate.fit('2015-04-15').format(fmt), '2015-04-15')

          it 'converts 2015-05-05 into 2015-04-30', () ->
            assert.equal(c.startDate.fit('2015-05-05').format(fmt), '2015-04-30')

          it 'converts 2015-05-14 into 2015-04-30', () ->
            assert.equal(c.startDate.fit('2015-05-14').format(fmt), '2015-04-30')

          it 'converts 2015-05-25 into 2015-04-30', () ->
            assert.equal(c.startDate.fit('2015-05-25').format(fmt), '2015-04-30')

          it 'converts 2015-06-15 into 2015-04-30', () ->
            assert.equal(c.startDate.fit('2015-06-15').format(fmt), '2015-04-30')

        describe 'extended mode', ->
          c = new Config({
            period: 'month'
            minDate: [moment.utc('2014-01-01'), 'inclusive']
            maxDate: [moment.utc('2015-05-14'), 'extended']
          })

          it 'converts 2015-04-15 into 2015-04-15', () ->
            assert.equal(c.startDate.fit('2015-04-15').format(fmt), '2015-04-15')

          it 'converts 2015-05-05 into 2015-05-05', () ->
            assert.equal(c.startDate.fit('2015-05-05').format(fmt), '2015-05-05')

          it 'converts 2015-05-14 into 2015-05-14', () ->
            assert.equal(c.startDate.fit('2015-05-14').format(fmt), '2015-05-14')

          it 'converts 2015-05-25 into 2015-05-25', () ->
            assert.equal(c.startDate.fit('2015-05-25').format(fmt), '2015-05-25')

          it 'converts 2015-06-15 into 2015-05-31', () ->
            assert.equal(c.startDate.fit('2015-06-15').format(fmt), '2015-05-31')

    describe '#isWithinBoundaries()', ->
      describe 'minDate = 2015-05-14, period = month', ->
        describe 'inclusive mode', ->
          c = new Config({
            period: 'month'
            minDate: [moment.utc('2015-05-14'), 'inclusive']
            maxDate: [moment.utc('2016-01-01'), 'inclusive']
          })

          it 'returns false for 2015-04-15', () ->
            assert.isFalse(c.startDate.isWithinBoundaries('2015-04-15'), '2015-04-15')

          it 'returns true for 2015-05-05', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-05'), '2015-05-05') # tricky one

          it 'returns true for 2015-05-14', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-14'), '2015-05-14')

          it 'returns true for 2015-05-25', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-25'), '2015-05-25')

          it 'returns true for 2015-06-15', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-06-15'), '2015-06-15')

        describe 'exclusive mode', ->
          c = new Config({
            period: 'month'
            minDate: [moment.utc('2015-05-14'), 'exclusive']
            maxDate: [moment.utc('2016-01-01'), 'inclusive']
          })

          it 'returns false for 2015-04-15', () ->
            assert.isFalse(c.startDate.isWithinBoundaries('2015-04-15'), '2015-04-15')

          it 'returns false for 2015-05-05', () ->
            assert.isFalse(c.startDate.isWithinBoundaries('2015-05-05'), '2015-05-05')

          it 'returns false for 2015-05-14', () ->
            assert.isFalse(c.startDate.isWithinBoundaries('2015-05-14'), '2015-05-14')

          it 'returns false for 2015-05-25', () ->
            assert.isFalse(c.startDate.isWithinBoundaries('2015-05-25'), '2015-05-25')

          it 'returns true for 2015-06-15', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-06-15'), '2015-06-15')

        describe 'extended mode', ->
          c = new Config({
            period: 'month'
            minDate: [moment.utc('2015-05-14'), 'extended']
            maxDate: [moment.utc('2016-01-01'), 'inclusive']
          })

          it 'returns false for 2015-04-15', () ->
            assert.isFalse(c.startDate.isWithinBoundaries('2015-04-15'), '2015-04-15')

          it 'returns true for 2015-05-05', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-05'), '2015-05-05')

          it 'returns true for 2015-05-14', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-14'), '2015-05-14')

          it 'returns true for 2015-05-25', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-25'), '2015-05-25')

          it 'returns true for 2015-06-15', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-06-15'), '2015-06-15')

      describe 'maxDate = 2015-05-14, period = month', ->
        describe 'inclusive mode', ->
          c = new Config({
            period: 'month'
            minDate: [moment.utc('2014-01-01'), 'inclusive']
            maxDate: [moment.utc('2015-05-14'), 'inclusive']
          })

          it 'returns true for 2015-04-15', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-04-15'), '2015-04-15')

          it 'returns true for 2015-05-05', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-05'), '2015-05-05')

          it 'returns true for 2015-05-14', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-14'), '2015-05-14')

          it 'returns true for 2015-05-25', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-25'), '2015-05-25') # tricky one

          it 'returns false for 2015-06-15', () ->
            assert.isFalse(c.startDate.isWithinBoundaries('2015-06-15'), '2015-06-15')

        describe 'exclusive mode', ->
          c = new Config({
            period: 'month'
            minDate: [moment.utc('2014-01-01'), 'inclusive']
            maxDate: [moment.utc('2015-05-14'), 'exclusive']
          })

          it 'returns true for 2015-04-15', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-04-15'), '2015-04-15')

          it 'returns false for 2015-05-05', () ->
            assert.isFalse(c.startDate.isWithinBoundaries('2015-05-05'), '2015-05-05')

          it 'returns false for 2015-05-14', () ->
            assert.isFalse(c.startDate.isWithinBoundaries('2015-05-14'), '2015-05-14')

          it 'returns false for 2015-05-25', () ->
            assert.isFalse(c.startDate.isWithinBoundaries('2015-05-25'), '2015-05-25')

          it 'returns false for 2015-06-15', () ->
            assert.isFalse(c.startDate.isWithinBoundaries('2015-06-15'), '2015-06-15')

        describe 'extended mode', ->
          c = new Config({
            period: 'month'
            minDate: [moment.utc('2014-01-01'), 'inclusive']
            maxDate: [moment.utc('2015-05-14'), 'extended']
          })

          it 'returns true for 2015-04-15', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-04-15'), '2015-04-15')

          it 'returns true for 2015-05-05', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-05'), '2015-05-05')

          it 'returns true for 2015-05-14', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-14'), '2015-05-14')

          it 'returns true for 2015-05-25', () ->
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-25'), '2015-05-25')

          it 'returns false for 2015-06-15', () ->
            assert.isFalse(c.startDate.isWithinBoundaries('2015-06-15'), '2015-06-15')
