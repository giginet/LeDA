GameMode =
  Play : 0
  Metric : 1
  View : 2

GameState =
  Ready : 0
  Main : 1
  Rotation : 2
  Move : 3
  Goal : 4
  GameOver : 5

class MainScene extends Scene
  constructor : (mapData, mode=GameMode.Play, metricPK, metric=undefined) ->
    super
    @mode = mode
    @metric = metric
    @background = new GameObject(640, 480)
    @background.setImage "background.png"
    @addChild @background
    @map = new Map(10, 10, mapData)
    @addChild @map
    @addEventListener 'enterframe', @update
    @cursor = new GameObject(144, 144)
    @cursor.setImage("cursor0.png")
    @cursor.x = Tile.WIDTH  - 144 / 2.0
    @cursor.y = Tile.HEIGHT - 144 / 2.0
    @addChild @cursor
    @metricPK = metricPK
    stage = document.getElementById('enchant-stage')
    stage.scene = @
    if @mode == GameMode.Play
      stage.addEventListener 'mousemove', @updateMousePosition
      stage.addEventListener 'mousedown', @onMousePressed
    else if @mode == GameMode.Metric
      # Metricモードのとき
      metric.setScene(@)
      @addChild metric
    else if @mode == GameMode.View
      @removeChild @cursor
    stage.oncontextmenu = ->
      false
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
      if @mode == GameMode.Play
        # ゲームオーバーになったことを通知
        scene = @
        new Post "/metrics/#{@metricPK}/update", {'state' : 2}, (response) ->
          console.log response
          if confirm("ゲームオーバー もう一度プレイしますか？")
            # はいの場合、同じステージを読み直す
            logo = new LogoScene()
            logo.setup(scene.metricPK)
            MaWorld.game.replaceScene(logo)
          else
            # いいえの場合、別のステージを読み直す
            scene.loadAnotherStage()

    else if tile.getTileType() == TileType.Goal
      # ゴール
      @state = GameState.Goal
      if @mode == GameMode.Play
        # クリアしたことを通知
        scene = @
        new Post "/metrics/#{@metricPK}/update", {'state' : 1}, (response) ->
          console.log response
          if confirm("ステージクリア！他のステージを遊びますか？")
            scene.loadAnotherStage()
    else if tile.type == TileType.Ice
      # 滑る床のとき、もう一度進めてやる
      if not @moveNext(@map.player, @map.player.direction)
        @state = GameState.Main
    else
      @state = GameState.Main

  setCursorPosition : (v) ->
    @cursor.x = Tile.WIDTH * v.x  - 144 / 2.0
    @cursor.y = Tile.HEIGHT * v.y - 144 / 2.0

  moveNext : (character, direction) ->
    nextPoint = @map.getPointWithDirection(@map.globalToLocal(character.x, character.y), direction)
    nextTile = @map.getTile(nextPoint.x, nextPoint.y)
    if not nextTile? or (nextTile? and nextTile.isWalkable(direction))
      @moveTo(character, direction, 10)
      return true
    else if nextTile? and not nextTile.isWalkable(direction)
      console.log nextTile.type
      console.log TileType.Rock
      if nextTile.type == TileType.Rock # 岩があったら一度だけ反射する
        newDirection = (direction + 2) % 4
        character.setDirection(newDirection)
        nextPoint = @map.getPointWithDirection(@map.globalToLocal(character.x, character.y), newDirection)
        nextTile = @map.getTile(nextPoint.x, nextPoint.y)
        if not nextTile? or (nextTile? and nextTile.isWalkable(newDirection))
          @moveTo(character, newDirection, 10)
    false

  updateMousePosition : (e) ->
    v = @scene.map.globalToLocal(e.clientX, e.clientY)
    @scene.setCursorPosition(v)
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
      if success and @scene.mode is GameMode.Play
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

  loadAnotherStage : ->
    scene = @
    $.get "/levels/json?ignore=#{scene.metricPK}", {}, (response) ->
      console.log response
      next = response
      logo = new LogoScene()
      logo.setup(scene.metricPK, response)
      MaWorld.game.replaceScene(logo)