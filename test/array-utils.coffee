describe 'ArrayUtils', ->
  ArrayUtils = $.fn.daterangepicker.ArrayUtils
  describe '##rotateArray()', ->
    it 'should with a positive number', () ->
      assert.deepEqual(ArrayUtils.rotateArray([1, 2, 3, 4], 2), [3, 4, 1, 2])
    it 'should with a large positive number', () ->
      assert.deepEqual(ArrayUtils.rotateArray([1, 2, 3, 4], 10), [3, 4, 1, 2])
    it 'should work a negative number', () ->
      assert.deepEqual(ArrayUtils.rotateArray([1, 2, 3, 4], -2), [3, 4, 1, 2])
    it 'should with a large negative number', () ->
      assert.deepEqual(ArrayUtils.rotateArray([1, 2, 3, 4], -10), [3, 4, 1, 2])
    it 'should work a zero', () ->
      assert.deepEqual(ArrayUtils.rotateArray([1, 2, 3, 4], 0), [1, 2, 3, 4])

  describe '##uniqArray()', ->
    it 'should work', () ->
      assert.sameMembers(ArrayUtils.uniqArray([1, 2, 3, 1, 2, 4]), [1, 2, 3, 4])
