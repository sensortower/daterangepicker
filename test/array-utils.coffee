describe 'ArrayUtils', ->
  ArrayUtils = $.fn.daterangepicker.ArrayUtils
  describe '##rotateArray()', ->
    it 'should work', () ->
      assert.sameMembers(ArrayUtils.rotateArray([1, 2, 3, 4], 2), [3, 4, 1, 2])

  describe '##uniqArray()', ->
    it 'should work', () ->
      assert.sameMembers(ArrayUtils.uniqArray([1, 2, 3, 1, 2, 4]), [1, 2, 3, 4])
