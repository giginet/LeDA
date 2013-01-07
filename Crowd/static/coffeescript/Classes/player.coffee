class Player extends Character
  constructor : () ->
    super(3)
    @setImage "characters/player.png"
    @setDirection(Direction.Up)