class LogoScene extends Scene
  setup : ->
    url = $("#map_id").attr("mapurl")
    stage_number = url.match(/[0-9]+/)[0]
    $.getJSON url, {}, (data) ->
      # ロードが終わったらメトリックスを生成してあげる
      new Post "/metrics/create", {"stage" : stage_number}, (response) ->
        metrix_pk = response['pk']
        MaWorld.game.replaceScene(new MainScene(data, metrix_pk))