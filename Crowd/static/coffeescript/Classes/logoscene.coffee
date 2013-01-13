class LogoScene extends Scene
  setup : ->
    $.getJSON "/levels/1/json", {}, (data) ->
      MaWorld.game.replaceScene(new MainScene(data))