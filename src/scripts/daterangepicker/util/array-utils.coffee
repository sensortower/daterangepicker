class ArrayUtils
  @rotateArray: (array, offset) ->
    offset = offset % array.length
    array.slice(offset).concat(array.slice(0, offset))

  @uniqArray: (array) ->
    newArray = []
    for i in array
      if newArray.indexOf(i) == -1
        newArray.push(i)
    newArray
