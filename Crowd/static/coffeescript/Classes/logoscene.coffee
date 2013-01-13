class LogoScene extends Scene
  setup : ->
    url = $("#map_id").attr("mapurl")
    $.getJSON url, {}, (data) ->
      MaWorld.game.replaceScene(new MainScene(data))