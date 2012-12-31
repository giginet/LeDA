TileType =
  None : 0
  Floor : 1
  Wall : 2

class Tile extends GameObject
  constructor ->
    super
    @setImage ""