GameState =
  Ready : 0
  Main : 1
  Rotation : 2
  Move : 3
  Goal : 4
  GameOver : 5

class MainScene extends Scene
  constructor : (mapData, metricPK) ->
    super
    @map = new Map(10, 10, mapData)
    @addChild @map
    @addEventListener 'enterframe', @update
    @cursor = new GameObject(144, 144)
    @cursor.setImage("cursor0.png")
    @cursor.x = 0
    @cursor.y = 100
    @metricPK = metricPK
    stage = document.getElementById('enchant-stage')
    stage.scene = @
    stage.addEventListener 'mousemove', @updateMousePosition
    stage.addEventListener 'mousedown', @onMousePressed
    stage.oncontextmenu = ->
      false
    @addChild @cursor
    @rotationSet = undefined
    @state = GameState.Main
    @prevTile = undefined

  setup : ->
    @

  update : (e) ->
    if @state == GameState.Rotation
      if @rotationSet.isEnd()
        @rotationSet = undefined
        @state = GameState.Move
        p = @map.globalToLocal(@map.player.x, @map.player.y)
        @prevTile = @map.getTile(p.x, p.y)
        if not @moveNext(@map.player, @map.player.direction)
          @state = GameState.Main
    else if @state == GameState.Move
      if not @map.player.isMoving()
        @onMoveCompleted()

  onMoveCompleted : ->
    local = @map.globalToLocal(@map.player.getPosition().x, @map.player.getPosition().y)
    tile = @map.getTile(local.x, local.y)
    @prevTile?.onAfterMove(@map.player.direction)
    if not tile? or tile.isDangerous(@map.player.direction)
      # 危険な床
      @state = GameState.GameOver
      # ゲームオーバーになったことを通知
      scene = @
      new Post "metrics/#{@metricPK}/update", {'state' : 2}, (response) ->
        console.log response
        if confirm("ゲームオーバー もう一度プレイしますか？")
          logo = new LogoScene()
          logo.setup(scene.metricPK)
          MaWorld.game.replaceScene(logo)
        else
          location.href = "/"
    else if tile.getTileType() == TileType.Goal
      # ゴール
      @state = GameState.Goal
      alert("goal")
      # クリアしたことを通知
      new Post "metrics/#{@metricPK}/update", {'state' : 1}, (response) ->
        console.log response
    else if tile.type == TileType.Ice
      # 滑る床のとき、もう一度進めてやる
      if not @moveNext(@map.player, @map.player.direction)
        @state = GameState.Main
    else
      @state = GameState.Main

  moveNext : (character, direction) ->
    nextPoint = @map.getPointWithDirection(@map.globalToLocal(character.x, character.y), direction)
    nextTile = @map.getTile(nextPoint.x, nextPoint.y)
    if not nextTile? or (nextTile? and nextTile.isWalkable(direction))
      @moveTo(character, direction, 10)
      return true
    false

  updateMousePosition : (e) ->
    cursor = @scene.cursor
    v = @scene.map.globalToLocal(e.clientX, e.clientY)
    cursor.x = Tile.WIDTH * v.x  - 144 / 2.0
    cursor.y = Tile.HEIGHT * v.y - 144 / 2.0
    #console.log(e.clientX, e.clientY)

  onMousePressed : (e) ->
    v = @scene.map.globalToLocal(e.clientX, e.clientY).sub(new Vector(1, 1))
    if @scene.map.canRotate(v.x, v.y)
      success = false
      if e.button == 0
        d = RotateDirection.Left
        success = @scene.rotate(v, RotateDirection.Left)
      else
        d = RotateDirection.Right
        success = @scene.rotate(v, RotateDirection.Right)
      if success
        # Operationを送信してやる
        new Post "/operations/create", {"metric" : @scene.metricPK, "x" : v.x, "y" : v.y, "direction" : d}, (response) ->
          console.log response
        return true
    false

  rotate : (v, direction) ->
    if @state == GameState.Main
      set = @map.rotate(v.x, v.y, direction)
      if set != null
        @rotationSet = set
        @map.addChild set
        @state = GameState.Rotation
        return true
    return false

  moveTo : (character, direction, frame) ->
    if character in @map.characters
      local = @map.globalToLocal(character.x, character.y)
      from = @map.localToGlobal(local.x, local.y)
      localTo = @map.getPointWithDirection(local, direction)
      to = @map.localToGlobal(localTo.x, localTo.y)
      character.setMoveAnimation(from, to, frame)