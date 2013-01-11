StageType =
  Grass : 0
  Lake : 1
  Tower : 2
  Castle : 3
  Cave : 4
  Forest : 5

TileType =
  Ground : 0
  Goal : 1
  Hole : 2
  Jump : 3
  Needle : 4
  BrokenGround : 5
  Rock : 6
  Ice : 7

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
    if type is TileType.Ice
      "#{ROOT}/ice.png"
    else
      stages = ["grass", "lake", "tower", "castle", "cave", "forest"]
      types = ["ground", "goal", "hole", "jump", "needle", "brokenGround", "rock"]
      "#{ROOT}/#{stages[stage]}/#{types[type]}.png"

  getTileType : ->
    @type

  isDangerous : (fromDirection) ->
    @type in [TileType.Hole, TileType.Needle]

  isWalkable : (fromDirection) ->
    not (@type in [TileType.Rock])

  setDirection : (direction) ->
    @originX = Tile.WIDTH * 0.5
    @originY = Tile.HEIGHT * 0.5
    @direction = direction
    @rotation = 90 * ((direction + 2) % 4)
