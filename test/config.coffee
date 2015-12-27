describe 'Config', ->
  Config = $.fn.daterangepicker.Config
  fmt = 'YYYY-MM-DD'
  describe 'dateObservable', ->
    describe '#fit()', ->
      describe 'minDate', ->
        describe 'inclusive mode', ->
          it 'should work', () ->
            c = new Config({
              period: 'month'
              minDate: [moment.utc('2015-05-14'), 'inclusive']
              maxDate: [moment.utc('2016-01-01'), 'inclusive']
            })
            assert.equal(c.startDate.fit('2015-04-15').format(fmt), '2015-05-14')
            assert.equal(c.startDate.fit('2015-05-05').format(fmt), '2015-05-14')
            assert.equal(c.startDate.fit('2015-05-14').format(fmt), '2015-05-14')
            assert.equal(c.startDate.fit('2015-05-25').format(fmt), '2015-05-25')
            assert.equal(c.startDate.fit('2015-06-15').format(fmt), '2015-06-15')

        describe 'exclusive mode', ->
          it 'should work', () ->
            c = new Config({
              period: 'month'
              minDate: [moment.utc('2015-05-14'), 'exclusive']
              maxDate: [moment.utc('2016-01-01'), 'inclusive']
            })
            assert.equal(c.startDate.fit('2015-04-15').format(fmt), '2015-06-01')
            assert.equal(c.startDate.fit('2015-05-05').format(fmt), '2015-06-01')
            assert.equal(c.startDate.fit('2015-05-14').format(fmt), '2015-06-01')
            assert.equal(c.startDate.fit('2015-05-25').format(fmt), '2015-06-01')
            assert.equal(c.startDate.fit('2015-06-15').format(fmt), '2015-06-15')

        describe 'extended mode', ->
          it 'should work', () ->
            c = new Config({
              period: 'month'
              minDate: [moment.utc('2015-05-14'), 'extended']
              maxDate: [moment.utc('2016-01-01'), 'inclusive']
            })
            assert.equal(c.startDate.fit('2015-04-15').format(fmt), '2015-05-01')
            assert.equal(c.startDate.fit('2015-05-05').format(fmt), '2015-05-05')
            assert.equal(c.startDate.fit('2015-05-14').format(fmt), '2015-05-14')
            assert.equal(c.startDate.fit('2015-05-25').format(fmt), '2015-05-25')
            assert.equal(c.startDate.fit('2015-06-15').format(fmt), '2015-06-15')

      describe 'maxDate', ->
        describe 'inclusive mode', ->
          it 'should work', () ->
            c = new Config({
              period: 'month'
              minDate: [moment.utc('2014-01-01'), 'inclusive']
              maxDate: [moment.utc('2015-05-14'), 'inclusive']
            })
            assert.equal(c.startDate.fit('2015-04-15').format(fmt), '2015-04-15')
            assert.equal(c.startDate.fit('2015-05-05').format(fmt), '2015-05-05')
            assert.equal(c.startDate.fit('2015-05-14').format(fmt), '2015-05-14')
            assert.equal(c.startDate.fit('2015-05-25').format(fmt), '2015-05-14')
            assert.equal(c.startDate.fit('2015-06-15').format(fmt), '2015-05-14')

        describe 'exclusive mode', ->
          it 'should work', () ->
            c = new Config({
              period: 'month'
              minDate: [moment.utc('2014-01-01'), 'inclusive']
              maxDate: [moment.utc('2015-05-14'), 'exclusive']
            })
            assert.equal(c.startDate.fit('2015-04-15').format(fmt), '2015-04-15')
            assert.equal(c.startDate.fit('2015-05-05').format(fmt), '2015-04-30')
            assert.equal(c.startDate.fit('2015-05-14').format(fmt), '2015-04-30')
            assert.equal(c.startDate.fit('2015-05-25').format(fmt), '2015-04-30')
            assert.equal(c.startDate.fit('2015-06-15').format(fmt), '2015-04-30')

        describe 'extended mode', ->
          it 'should work', () ->
            c = new Config({
              period: 'month'
              minDate: [moment.utc('2014-01-01'), 'inclusive']
              maxDate: [moment.utc('2015-05-14'), 'extended']
            })
            assert.equal(c.startDate.fit('2015-04-15').format(fmt), '2015-04-15')
            assert.equal(c.startDate.fit('2015-05-05').format(fmt), '2015-05-05')
            assert.equal(c.startDate.fit('2015-05-14').format(fmt), '2015-05-14')
            assert.equal(c.startDate.fit('2015-05-25').format(fmt), '2015-05-25')
            assert.equal(c.startDate.fit('2015-06-15').format(fmt), '2015-05-31')

    describe '#isWithinBoundaries()', ->
      describe 'minDate', ->
        describe 'inclusive mode', ->
          it 'should work', () ->
            c = new Config({
              period: 'month'
              minDate: [moment.utc('2015-05-14'), 'inclusive']
              maxDate: [moment.utc('2016-01-01'), 'inclusive']
            })
            assert.isFalse(c.startDate.isWithinBoundaries('2015-04-15'), '2015-04-15')
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-05'), '2015-05-05') # tricky one
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-14'), '2015-05-14')
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-25'), '2015-05-25')
            assert.isTrue(c.startDate.isWithinBoundaries('2015-06-15'), '2015-06-15')

        describe 'exclusive mode', ->
          it 'should work', () ->
            c = new Config({
              period: 'month'
              minDate: [moment.utc('2015-05-14'), 'exclusive']
              maxDate: [moment.utc('2016-01-01'), 'inclusive']
            })
            assert.isFalse(c.startDate.isWithinBoundaries('2015-04-15'), '2015-04-15')
            assert.isFalse(c.startDate.isWithinBoundaries('2015-05-05'), '2015-05-05')
            assert.isFalse(c.startDate.isWithinBoundaries('2015-05-14'), '2015-05-14')
            assert.isFalse(c.startDate.isWithinBoundaries('2015-05-25'), '2015-05-25')
            assert.isTrue(c.startDate.isWithinBoundaries('2015-06-15'), '2015-06-15')

        describe 'extended mode', ->
          it 'should work', () ->
            c = new Config({
              period: 'month'
              minDate: [moment.utc('2015-05-14'), 'extended']
              maxDate: [moment.utc('2016-01-01'), 'inclusive']
            })
            assert.isFalse(c.startDate.isWithinBoundaries('2015-04-15'), '2015-04-15')
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-05'), '2015-05-05')
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-14'), '2015-05-14')
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-25'), '2015-05-25')
            assert.isTrue(c.startDate.isWithinBoundaries('2015-06-15'), '2015-06-15')

      describe 'maxDate', ->
        describe 'inclusive mode', ->
          it 'should work', () ->
            c = new Config({
              period: 'month'
              minDate: [moment.utc('2014-01-01'), 'inclusive']
              maxDate: [moment.utc('2015-05-14'), 'inclusive']
            })
            assert.isTrue(c.startDate.isWithinBoundaries('2015-04-15'), '2015-04-15')
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-05'), '2015-05-05')
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-14'), '2015-05-14')
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-25'), '2015-05-25') # tricky one
            assert.isFalse(c.startDate.isWithinBoundaries('2015-06-15'), '2015-06-15')

        describe 'exclusive mode', ->
          it 'should work', () ->
            c = new Config({
              period: 'month'
              minDate: [moment.utc('2014-01-01'), 'inclusive']
              maxDate: [moment.utc('2015-05-14'), 'exclusive']
            })
            assert.isTrue(c.startDate.isWithinBoundaries('2015-04-15'), '2015-04-15')
            assert.isFalse(c.startDate.isWithinBoundaries('2015-05-05'), '2015-05-05')
            assert.isFalse(c.startDate.isWithinBoundaries('2015-05-14'), '2015-05-14')
            assert.isFalse(c.startDate.isWithinBoundaries('2015-05-25'), '2015-05-25')
            assert.isFalse(c.startDate.isWithinBoundaries('2015-06-15'), '2015-06-15')

        describe 'extended mode', ->
          it 'should work', () ->
            c = new Config({
              period: 'month'
              minDate: [moment.utc('2014-01-01'), 'inclusive']
              maxDate: [moment.utc('2015-05-14'), 'extended']
            })
            assert.isTrue(c.startDate.isWithinBoundaries('2015-04-15'), '2015-04-15')
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-05'), '2015-05-05')
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-14'), '2015-05-14')
            assert.isTrue(c.startDate.isWithinBoundaries('2015-05-25'), '2015-05-25')
            assert.isFalse(c.startDate.isWithinBoundaries('2015-06-15'), '2015-06-15')
