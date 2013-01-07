class Map extends Group
  constructor : (width, height) ->
    super
    @_map = []
    for x in [0...width]
      @_map.push([])
      for y in [0...height]
        tile = new Tile(x, y)
        @_map[x].push tile
        @addChild tile
    @width = width
    @height = height
    @player = new Player()
    @player.setPosition(@localToGlobal(1, 1))
    @characters = [@player]
    @addChild @player

  getTile : (x, y) ->
    @_map[x][y]

  setTile : (x, y, tile) ->
    v = @localToGlobal(x, y)
    tile.localX = x
    tile.localY = y
    tile.x = v.x
    tile.y = v.y
    @_map[x][y] = tile

  rotate : (x, y, direction) ->
    if x < 0 or x >= @width - 1 or y < 0 or y >= @height
      return null
    lu = @getTile(x, y)
    ld = @getTile(x, y + 1)
    ru = @getTile(x + 1, y)
    rd = @getTile(x + 1, y + 1)
    w = lu.width
    h = lu.height
    set = new TileSet(@, x, y, direction)
    set

  localToGlobal : (x, y) ->
    new Vector(x * Tile.WIDTH, y * Tile.HEIGHT)

  globalToLocal : (x, y) ->
    new Vector(Math.floor(x / Tile.WIDTH), Math.floor(y / Tile.HEIGHT))

  getTileWithDirection : (v, d) ->
    switch (d)
      when Direction.Up then return @getTile(v.x, v.y - 1)
      when Direction.Left then return @getTile(v.x - 1, v.y)
      when Direction.Down then return @getTile(v.x, v.y + 1)
      when Direction.Right then return @getTile(v.x + 1, v.y)