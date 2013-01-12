class Map extends Group
  constructor : (width, height, data) ->
    super
    @tileLayer = new Group()
    @objectLayer = new Group()
    @addChild @tileLayer
    console.log data
    @_map = []
    for x in [0...width]
      @_map.push([])
      for y in [0...height]
        kind = data["map"][x][y]
        kinds = [TileType.None, TileType.Ground, TileType.Goal, TileType.Rock, TileType.Jump, TileType.Hole, TileType.Rock]
        tile = new Tile(x, y, kinds[kind])
        @_map[x].push tile
        @tileLayer.addChild tile
    @width = width
    @height = height
    @player = new Player()
    @player.setPosition(@localToGlobal(data["player"][0], data["player"][1]))
    direction = ((Direction.Left + data["player"][2]) + 4) % 4
    console.log direction
    @player.setDirection(direction)
    @characters = [@player]
    @objects = [@player]
    @addChild @objectLayer
    @objectLayer.addChild @player

  getTile : (x, y) ->
    if x < 0 or y < 0 or x >= @width or y >= @height
      return undefined
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

  getPointWithDirection : (v, d) ->
    switch (d)
      when Direction.Up then return new Vector(v.x, v.y - 1)
      when Direction.Left then return new Vector(v.x - 1, v.y)
      when Direction.Down then return new Vector(v.x, v.y + 1)
      when Direction.Right then return new Vector(v.x + 1, v.y)

  canRotate : (x, y) ->
    lu = @getTile(x, y)
    ld = @getTile(x, y + 1)
    ru = @getTile(x + 1, y)
    rd = @getTile(x + 1, y + 1)
    return lu.isRotatable() and ld.isRotatable() and ru.isRotatable() and rd.isRotatable()