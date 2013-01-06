RotateDirection =
  Left : 0
  Right : 1

class TileSet
  constructor : (map, x, y, direction) ->
    @map = map
    @lu = @map.getTile(x, y)
    @ld = @map.getTile(x, y + 1)
    @ru = @map.getTile(x + 1, y)
    @rd = @map.getTile(x + 1, y + 1)
    w = Tile.WIDTH
    h = Tile.HEIGHT
    @rootx = x
    @rooty = y
    @lu.originX = w * 1.0
    @lu.originY = h * 1.0
    @ld.originX = w * 1.0
    @ld.originY = 0
    @ru.originX = 0
    @ru.originY = h * 1.0
    @rd.originX = 0
    @rd.originY = 0
    @count = 0
    @direction = direction

  update : ->
    if !@isEnd()
      if @direction == RotateDirection.Left
        speed = -10
      else
        speed = 10
      @lu.rotation += speed
      @ld.rotation += speed
      @ru.rotation += speed
      @rd.rotation += speed
      @count += 1
    if @isEnd()
      if @direction == RotateDirection.Left
        @map.setTile(@rootx, @rooty + 1, @lu)
        @map.setTile(@rootx, @rooty, @ru)
        @map.setTile(@rootx + 1, @rooty, @rd)
        @map.setTile(@rootx + 1, @rooty + 1, @ld)
      else
        @map.setTile(@rootx, @rooty + 1, @rd)
        @map.setTile(@rootx, @rooty, @ld)
        @map.setTile(@rootx + 1, @rooty, @lu)
        @map.setTile(@rootx + 1, @rooty + 1, @ru)
      for tile in [@lu, @ld, @ru, @rd]
        tile.rotation = 0
        tile.originX = Tile.WIDTH * 0.5
        tile.originY = Tile.HEIGHT * 0.5
        tile.direction = (tile.direction + 1) % 4
  isEnd : ->
    return @count >= 9