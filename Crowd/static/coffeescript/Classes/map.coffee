class Map extends Group
  constructor : (width, height) ->
    super
    @_map = []
    for x in [0...width]
      @_map.push([])
      for y in [0...height]
        tile = new Tile()
        tile.x = x * 48
        tile.y = y * 48
        @_map[x].push tile
        @addChild tile
    @width = width
    @height = height

  getTile : (x, y) ->
    @_map[x][y]

  rotate : (x, y, direction) ->
    if x < 0 or x >= @width - 1 or y < 0 or y >= @height
      return null
    lu = this.getTile(x, y)
    ld = this.getTile(x, y + 1)
    ru = this.getTile(x + 1, y)
    rd = this.getTile(x + 1, y + 1)
    w = lu.width
    h = lu.height
    lu.originX = w * 1.0
    lu.originY = h * 1.0
    ld.originX = w * 1.0
    ld.originY = 0
    ru.originX = 0
    ru.originY = h * 1.0
    rd.originX = 0
    rd.originY = 0
    set = new TileSet(lu, ld, ru, rd, direction)
    set

  localToGlobal : (x, y) ->
    @

  globalToLocal : (x, y) ->
    new Vector(Math.floor(x / Tile.WIDTH), Math.floor(y / Tile.HEIGHT))