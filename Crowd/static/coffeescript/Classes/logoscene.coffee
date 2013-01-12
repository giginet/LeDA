class LogoScene extends Scene
  setup : ->
    @kawaz = new GameObject(253, 81)
    @kawaz.setImage 'kawaz.png'
    @kawaz.x = 193.5
    @kawaz.y = 220
    @addChild @kawaz
    @addEventListener 'enterframe', @update
    $.getJSON "/javascript/test2.json", {}, (data) ->
      MaWorld.game.replaceScene(new MainScene(data))