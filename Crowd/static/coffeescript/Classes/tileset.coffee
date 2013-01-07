RotateDirection =
  Left : 0
  Right : 1

class TileSet extends Group
  @speed = 10
  constructor : (map, x, y, direction) ->
    super()
    @map = map
    @lu = @map.getTile(x, y)
    @ld = @map.getTile(x, y + 1)
    @ru = @map.getTile(x + 1, y)
    @rd = @map.getTile(x + 1, y + 1)
    root = @lu.getPosition().clone()
    for node in [@lu, @ld, @ru, @rd]
      @map.removeChild node
      @addChild node
      node.x -= root.x
      node.y -= root.y
    @map.addChild @
    w = Tile.WIDTH
    h = Tile.HEIGHT
    @originX = w
    @originY = h
    @rootx = x
    @rooty = y
    @x = root.x
    @y = root.y
    @count = 0
    @direction = direction

  update : (e) ->
    if !@isEnd()
      if @direction == RotateDirection.Left
        speed = -TileSet.speed
      else
        speed = TileSet.speed
      @rotation += speed
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
        @removeChild tile
        @map.addChild tile
      @map.removeChild @
  isEnd : ->
    return @count >= 90 / TileSet.speed