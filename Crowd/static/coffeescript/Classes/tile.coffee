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
  Ice : 6

class Tile extends GameObject
  @WIDTH = 48
  @HEIGHT = 48
  constructor : (localX, localY, type) ->
    super(Tile.WIDTH, Tile.HEIGHT)
    @setImage @getFilePath(StageType.Grass, type)
    @direction = 0
    @addEventListener "enterframe", @update
    @localX = localX
    @localY = localY
    @x = localX * Tile.WIDTH
    @y = localY * Tile.HEIGHT

  update : (e) ->
    @rotaiton = @direction * 90

  getFilePath : (stage, type) ->
    ROOT = "chips"
    if type is TileType.Ice
      return "#{ROOT}/ice.png"
    else
      stages = ["grass", "lake", "tower", "castle", "cave", "forest"]
      types = ["ground", "goal", "hole", "jump", "needle", "brokenGround"]
      return "#{ROOT}/#{stages[stage]}/#{types[type]}.png"