class Map extends Group
  constructor : ->
    super
    for x in [0...10]
      for y in [0...10]
        tile = new Tile()
        tile.x = x * 48
        tile.y = y * 48
        @addChild tile