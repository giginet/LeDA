StageType =
  Grass : 0
  Lake : 1
  Tower : 2
  Castle : 3
  Cave : 4
  Forest : 5

TileType =
  None : 0
  Ground : 1
  Goal : 2
  Hole : 3
  Jump : 4
  Needle : 5
  BrokenGround : 6
  Rock : 7
  Ice : 8

class Tile extends GameObject
  @WIDTH = 48
  @HEIGHT = 48
  constructor : (localX, localY, type) ->
    super(Tile.WIDTH, Tile.HEIGHT)
    @setImage @getFilePath(StageType.Grass, type)
    @direction = Direction.Down
    @addEventListener "enterframe", @update
    @localX = localX
    @localY = localY
    @x = localX * Tile.WIDTH
    @y = localY * Tile.HEIGHT
    @type = type

  update : (e) ->
    @rotaiton = @direction * 90

  getFilePath : (stage, type) ->
    ROOT = "chips"
    if type is TileType.None
      "#{ROOT}/none.png"
    else if type is TileType.Ice
      "#{ROOT}/ice.png"
    else
      stages = ["grass", "lake", "tower", "castle", "cave", "forest"]
      types = ["ground", "goal", "hole", "jump", "needle", "brokenGround", "rock"]
      "#{ROOT}/#{stages[stage]}/#{types[type - 1]}.png"

  getTileType : ->
    @type

  isDangerous : (fromDirection) ->
    @type in [TileType.Hole, TileType.Needle, TileType.None]

  isWalkable : (fromDirection) ->
    not (@type in [TileType.Rock])

  isRotatable : ->
    not (@type in [TileType.None])

  setDirection : (direction) ->
    @originX = Tile.WIDTH * 0.5
    @originY = Tile.HEIGHT * 0.5
    @direction = direction
    @rotation = 90 * ((direction + 2) % 4)
