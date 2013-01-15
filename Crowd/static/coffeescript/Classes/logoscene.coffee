class LogoScene extends Scene
  setup : (preMetricPK) ->
    url = $("#map_id").attr("mapurl")
    stage_number = url.match(/[0-9]+/)[0]
    $.getJSON url, {}, (data) ->
      # ロードが終わったらメトリックスを生成してあげる
      param = {"stage" : stage_number}
      if preMetricPK?
        param["pre_metric"] = preMetricPK
      new Post "/metrics/create", param, (response) ->
        metrix_pk = response['pk']
        MaWorld.game.replaceScene(new MainScene(data, metrix_pk))