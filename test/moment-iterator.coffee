describe 'MomentIterator', ->
  MomentIterator = $.fn.daterangepicker.MomentIterator
  fmt = 'YYYY-MM-DD'
  describe '#next()', ->
    it 'should work', () ->
      iter = new MomentIterator(moment.utc([2015, 1, 1]), 'month')
      assert.equal(iter.next().format(fmt), '2015-02-01')
      assert.equal(iter.next().format(fmt), '2015-03-01')

  describe '##array()', ->
    it 'should work', () ->
      arr = MomentIterator.array(moment.utc([2015, 1, 1]), 6, 'month')

      expectations = [
        '2015-02-01',
        '2015-03-01',
        '2015-04-01',
        '2015-05-01',
        '2015-06-01',
        '2015-07-01'
      ]

      assert.sameMembers(arr.map((x) -> x.format(fmt)), expectations)
