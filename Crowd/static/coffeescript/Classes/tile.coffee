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
  Wall : 3
  BrokenGround : 4
  Hole : 5
  Rock : 6
  Ice : 7
  NeedleLeft : 224
  NeedleUp : 225
  NeedleRight : 226
  NeedleDown : 227


class Tile extends GameObject
  @WIDTH = 48
  @HEIGHT = 48
  constructor : (localX, localY, type) ->
    super(Tile.WIDTH, Tile.HEIGHT)
    @setType type
    @addEventListener "enterframe", @update
    @localX = localX
    @localY = localY
    @x = localX * Tile.WIDTH
    @y = localY * Tile.HEIGHT
    if @type is TileType.NeedleRight
      this.setDirection(Direction.Right)
    else if @type is TileType.NeedleUp
      this.setDirection(Direction.Up)
    else if @type is TileType.NeedleLeft
      this.setDirection(Direction.Left)
    else
      this.setDirection(Direction.Down)

  update : (e) ->
    @rotaiton = @direction * 90

  setType : (type) ->
    @type = type
    @setImage @getFilePath(StageType.Cave, type)

  getFilePath : (stage, type) ->
    ROOT = "chips"
    stages = ["grass", "lake", "tower", "castle", "cave", "forest"]
    if type is TileType.None
      "#{ROOT}/none.png"
    else if type is TileType.Ice
      "#{ROOT}/ice.png"
    else if type in [TileType.NeedleRight, TileType.NeedleDown, TileType.NeedleUp, TileType.NeedleLeft]
      "#{ROOT}/#{stages[stage]}/needle.png"
    else
      types = ["ground", "goal", "rock", "broken", "hole", "rock"]
      "#{ROOT}/#{stages[stage]}/#{types[type - 1]}.png"

  getTileType : ->
    @type

  onAfterMove : (toDirection) ->
    # 移動後に行う処理です
    console.log "onAfterMove"
    if @type is TileType.BrokenGround
      @setType TileType.Hole

  isDangerous : (fromDirection) ->
    if @type in [TileType.NeedleRight, TileType.NeedleDown, TileType.NeedleUp, TileType.NeedleLeft]
      #ハリのとき、進行方向の逆向きを向いてたら危険
      return fromDirection is ((@direction + 2) % 4)
    @type in [TileType.Hole, TileType.Needle, TileType.None]

  isWalkable : (fromDirection) ->
    if @type in [TileType.NeedleRight, TileType.NeedleDown, TileType.NeedleUp, TileType.NeedleLeft]
      # ハリのとき、進行方向の逆向き以外だったら進めない
      return fromDirection is (@direction + 2) % 4
    not (@type in [TileType.Rock, TileType.Wall])

  isRotatable : ->
    not (@type in [TileType.None])

  setDirection : (direction) ->
    @originX = Tile.WIDTH * 0.5
    @originY = Tile.HEIGHT * 0.5
    @direction = direction
    @rotation = 90 * ((direction + 2) % 4)
