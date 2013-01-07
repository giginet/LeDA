class GameObject extends Sprite
  constructor: (w, h, x=0, y=0) ->
    super w, h
    @removeEventListener 'enterframe'
    @x = x
    @y = y
    @velocity = new Vector()
    @speed = 7
  update : (e) ->
    @x += @velocity.x
    @y += @velocity.y
  setImage : (fileName) ->
    @image = MaWorld.game.assets["#{MaWorld.config.IMAGE_PATH}#{fileName}"]
  getPosition : ->
    return new Vector(@x, @y)
  getCenter : ->
    return new Vector(@x + @width / 2, @y + @height / 2)
  setPosition : (v) ->
    @x = v.x
    @y = v.y