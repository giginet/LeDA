class MainScene extends Scene
  constructor : ->
    super
    @stage = new Map(10, 10)
    @addChild @stage
    @addEventListener 'enterframe', @update
    @cursor = new GameObject(144, 144)
    @cursor.setImage("cursor0.png")
    @cursor.x = 0
    @cursor.y = 100
    stage = document.getElementById('enchant-stage')
    stage.scene = @
    stage.addEventListener 'mousemove', @updateMousePosition
    @addEventListener 'touchstart', @onMousePressed
    @addChild @cursor
    @tileSetQueue = []

  setup : ->
    @

  update : (e) ->
    for set in @tileSetQueue
      set.update()
      if set.isEnd()
        @tileSetQueue.deleteAt(@tileSetQueue.index(set))

  updateMousePosition : (e) ->
    cursor = @scene.cursor
    v = @scene.stage.globalToLocal(e.clientX, e.clientY)
    cursor.x = Tile.WIDTH * v.x  - 144 / 2.0
    cursor.y = Tile.HEIGHT * v.y - 144 / 2.0
    #console.log(e.clientX, e.clientY)

  onMousePressed : (e) ->
    v = @stage.globalToLocal(e.x - Tile.WIDTH, e.y - Tile.HEIGHT)
    set = @stage.rotate(v.x, v.y, RotateDirection.Left)
    if set != null
      @tileSetQueue.push set

  rotate : (e) ->
    @