TileType =
  None : 0
  Floor : 1
  Wall : 2

class Tile extends GameObject
  @WIDTH = 48
  @HEIGHT = 48
  constructor : (localX, localY) ->
    super(Tile.WIDTH, Tile.HEIGHT)
    @setImage "chips/grass.png"
    @direction = 0
    @addEventListener "enterframe", @update
    @localX = localX
    @localY = localY
    @x = localX * Tile.WIDTH
    @y = localY * Tile.HEIGHT

  update : (e) ->
    @rotaiton = @direction * 90