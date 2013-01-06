TileType =
  None : 0
  Floor : 1
  Wall : 2

class Tile extends GameObject
  @WIDTH = 48
  @HEIGHT = 48
  constructor : ->
    super(Tile.WIDTH, Tile.HEIGHT)
    @setImage "chips/grass.png"
    @direction = 0
    @addEventListener "enterframe", @update

  update : (e) ->
    @rotaiton = @direction * 90