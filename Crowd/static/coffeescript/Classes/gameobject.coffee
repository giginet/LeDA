class GameObject extends Sprite
  constructor: (w, h, x=0, y=0) ->
    super w, h
    @removeEventListener 'enterframe'
    @x = x
    @y = y
    @v = new Vector()
    @speed = 7
  update : (e) ->
    @x += @v.x
    @y += @v.y
  setImage : (fileName) ->
    console.log "#{MaWorld.config.IMAGE_PATH}#{fileName}"
    @image = MaWorld.game.assets["#{MaWorld.config.IMAGE_PATH}#{fileName}"]
  position : ->
    return new Vector(@x, @y)
  center : ->
    return new Vector(@x + @width / 2, @y + @height / 2)