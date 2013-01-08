class MapObject extends GameObject
  constructor : (w, h) ->
    super(w, h)
    @addEventListener "enterframe", @update

  update : (e) ->
    @timer?.tick()
    if @timer?.isOver()
      @

  setMoveAnimation : (from, to, frame) ->
    if not @timer? or @timer.isOver()
      @timer = new Timer(frame)
      @timer.play()
      obj = @
      @timer.setOnUpdate ->
        sub = to.clone().sub(from)
        velocity = sub.div(frame)
        obj.x += velocity.x
        obj.y += velocity.y
  isMoving : ->
    return @timer? and not @timer?.isOver()