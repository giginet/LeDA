class LogoScene extends Scene
  setup : (preMetricPK, stage=undefined) ->
    if stage?
      stageNo = stage['pk']
      url = "levels/#{stageNo}/json"
      $("#stage_url").attr("stageurl", url)
    else
      url = $("#stage_url").attr("stageurl")
      stageNo = url.match(/[0-9]+/)[0]
    $.getJSON url, {}, (data) ->
      # ロードが終わったらメトリックスを生成してあげる
      param = {"stage" : stageNo}
      if preMetricPK?
        param["pre_metric"] = preMetricPK
      new Post "/metrics/create", param, (response) ->
        metrix_pk = response['pk']
        MaWorld.game.replaceScene(new MainScene(data["stage_data"], metrix_pk))