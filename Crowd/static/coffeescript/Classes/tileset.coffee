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
    @root = @lu.getPosition().clone()
    @end = @lu.getPosition().clone().add(new Vector(Tile.WIDTH * 2, Tile.HEIGHT * 2))

    for node in [@lu, @ld, @ru, @rd]
      @map.removeChild node
      @addChild node
      node.x -= @root.x
      node.y -= @root.y

    @objects = [] # オブジェクトと下のタイルを持った配列
    for object in @map.objects
      if @root.x <= object.x < @end.x and @root.y <= object.y < @end.y
        local = @map.globalToLocal(object.getPosition().x, object.getPosition().y)
        tile = @map.getTile(local.x, local.y)
        @objects.push [object, tile]
        @map.removeChild object
        @addChild object
        object.setPosition(@globalToNodePosition(object.getPosition()))
    w = Tile.WIDTH
    h = Tile.HEIGHT
    @originX = w
    @originY = h
    @x = @root.x
    @y = @root.y
    @count = 0
    @direction = direction
    @addEventListener 'enterframe', @update

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
        local = @map.globalToLocal(@root.x, @root.y)
        rootx = local.x
        rooty = local.y
        @map.setTile(rootx, rooty + 1, @lu)
        @map.setTile(rootx, rooty, @ru)
        @map.setTile(rootx + 1, rooty, @rd)
        @map.setTile(rootx + 1, rooty + 1, @ld)
      else
        @map.setTile(rootx, rooty + 1, @rd)
        @map.setTile(rootx, rooty, @ld)
        @map.setTile(rootx + 1, rooty, @lu)
        @map.setTile(rootx + 1, rooty + 1, @ru)
      for tile in [@lu, @ld, @ru, @rd]
        tile.rotation = 0
        tile.originX = Tile.WIDTH * 0.5
        tile.originY = Tile.HEIGHT * 0.5
        tile.direction = (tile.direction + 1) % 4
        @removeChild tile
        @map.addChild tile
      for array in @objects
        object = array[0]
        tile = array[1]
        @removeChild object
        @map.addChild object
        if @direction == RotateDirection.Left
          object.setDirection(object.direction - 1)
        else
          object.setDirection(object.direction + 1)
        object.setPosition(tile.getPosition())
      @map.removeChild @
  isEnd : ->
    return @count >= 90 / TileSet.speed

  globalToNodePosition : (v) ->
    return v.clone().sub(@root)

  nodeToGlobalPosition : (v) ->
    return v.clone().add(@root)