RotateDirection =
  Left : 0
  Right : 1

class TileSet
  constructor : (lu, ld, ru, rd, direction) ->
    @lu = lu
    @ld = ld
    @ru = ru
    @rd = rd
    @count = 0
    @direction = direction

  update : ->
    if !@isEnd()
      if @direction == RotateDirection.Left
        speed = 10
      else
        speed = -10
      @lu.rotation += speed
      @ld.rotation += speed
      @ru.rotation += speed
      @rd.rotation += speed
      @count += 1

  isEnd : ->
    return @count >= 9