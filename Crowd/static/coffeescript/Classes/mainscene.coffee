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
    @addEventListener 'touchstart', @onMousePressed
    @addChild @cursor
    @tileSetQueue = []
    @moveTo(@map.player, Direction.Up, 10)

  setup : ->
    @

  update : (e) ->
    for set in @tileSetQueue
      set.update()
      if set.isEnd()
        @tileSetQueue.deleteAt(@tileSetQueue.index(set))

  updateMousePosition : (e) ->
    cursor = @scene.cursor
    v = @scene.map.globalToLocal(e.clientX, e.clientY)
    cursor.x = Tile.WIDTH * v.x  - 144 / 2.0
    cursor.y = Tile.HEIGHT * v.y - 144 / 2.0
    #console.log(e.clientX, e.clientY)

  onMousePressed : (e) ->
    v = @map.globalToLocal(e.x - Tile.WIDTH, e.y - Tile.HEIGHT)
    set = @map.rotate(v.x, v.y, RotateDirection.Left)
    if set != null
      @tileSetQueue.push set

  rotate : (e) ->
    @

  moveTo : (character, direction, frame) ->
    if character in @map.characters
      local = @map.globalToLocal(character.x, character.y)
      fromTile = @map.getTile(local.x, local.y)
      toTile = @map.getTileWithDirection(local, direction)
      character.setMoveAnimation(fromTile.getPosition(), toTile.getPosition(), frame)