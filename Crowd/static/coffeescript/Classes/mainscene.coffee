GameState =
  Ready : 0
  Main : 1
  Rotation : 2
  Move : 3
  Goal : 4
  GameOver : 5

class MainScene extends Scene
  constructor : ->
    super
    @map = new Map(10, 10)
    @addChild @map
    @addEventListener 'enterframe', @update
    @cursor = new GameObject(144, 144)
    @cursor.setImage("cursor0.png")
    @cursor.x = 0
    @cursor.y = 100
    stage = document.getElementById('enchant-stage')
    stage.scene = @
    stage.addEventListener 'mousemove', @updateMousePosition
    stage.addEventListener 'mousedown', @onMousePressed
    stage.oncontextmenu = ->
      false
    @addChild @cursor
    @rotationSet = undefined
    @state = GameState.Main

  setup : ->
    @

  update : (e) ->
    if @state == GameState.Rotation
      if @rotationSet.isEnd()
        @rotationSet = undefined
        @state = GameState.Move
        @moveTo(@map.player, @map.player.direction, 10)
    else if @state == GameState.Move
      if not @map.player.isMoving()
        @onMoveCompleted()

  onMoveCompleted : ->
    local = @map.globalToLocal(@map.player.getPosition().x, @map.player.getPosition().y)
    tile = @map.getTile(local.x, local.y)
    if tile.getTileType() == TileType.Goal
      # ゴール
      @state = GameState.Goal
      alert("goal")
    else if tile.isDangerous()
      # 危険な床
      @state = GameState.GameOver
      alert("gameover")
    else if tile.type == TileType.Ice
      # 滑る床のとき、もう一度進めてやる
      @moveTo(@map.player, @map.player.direction, 10)
    else
      @state = GameState.Main


  updateMousePosition : (e) ->
    cursor = @scene.cursor
    v = @scene.map.globalToLocal(e.clientX, e.clientY)
    cursor.x = Tile.WIDTH * v.x  - 144 / 2.0
    cursor.y = Tile.HEIGHT * v.y - 144 / 2.0
    #console.log(e.clientX, e.clientY)

  onMousePressed : (e) ->
    v = @scene.map.globalToLocal(e.clientX, e.clientY).sub(new Vector(1, 1))
    if e.button == 0
      @scene.rotate(v, RotateDirection.Left)
    else
      @scene.rotate(v, RotateDirection.Right)
    return true

  rotate : (v, direction) ->
    if @state == GameState.Main
      set = @map.rotate(v.x, v.y, direction)
      if set != null
        @rotationSet = set
        @map.addChild set
        @state = GameState.Rotation

  moveTo : (character, direction, frame) ->
    if character in @map.characters
      local = @map.globalToLocal(character.x, character.y)
      from = @map.localToGlobal(local.x, local.y)
      localTo = @map.getPointWithDirection(local, direction)
      to = @map.localToGlobal(localTo.x, localTo.y)
      character.setMoveAnimation(from, to, frame)