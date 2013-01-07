class LogoScene extends Scene
  setup : ->
    @kawaz = new GameObject(253, 81)
    @kawaz.setImage 'kawaz.png'
    @kawaz.x = 193.5
    @kawaz.y = 220
    @kawaz.opacity = 0
    @addChild @kawaz
    @addEventListener 'enterframe', @update
    @timer = new Timer(180)
    @timer.setOnComplete ->
      MaWorld.game.replaceScene(new MainScene())
      @
    @timer.play()
  update : ->
    if MaWorld.game.input.a
      MaWorld.game.replaceScene(new MainScene())
      @
    @timer.tick()
    if @timer.now() < 60
      @kawaz.opacity += 1.0/60
    else if @timer.now() > 120
      @kawaz.opacity -= 1.0/60