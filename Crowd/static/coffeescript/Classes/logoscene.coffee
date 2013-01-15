class LogoScene extends Scene
  setup : (preMetricPK, stage=undefined) ->
    if stage?
      stageNo = stage['pk']
      url = "/levels/#{stageNo}/json"
      $("#stage_url").attr("stageurl", url)
    else
      url = $("#stage_url").attr("stageurl")
      stageNo = url.match(/[0-9]+/)[0]
    $metric = $("#metric_url")
    $.getJSON url, {}, (data) ->
      if $metric.size() > 0
        # #metric_urlがあるとき、再生モードにする
        metric_url = $metric.attr("metricurl")
        MaWorld.game.replaceScene(new MainScene(data["stage_data"], undefined, GameMode.Metric), metric_url)
      else
        # ロードが終わったらメトリックスを生成してあげる
        param = {"stage" : stageNo}
        if preMetricPK?
          param["pre_metric"] = preMetricPK
        new Post "/metrics/create", param, (response) ->
          metric_pk = response['pk']
          MaWorld.game.replaceScene(new MainScene(data["stage_data"], metric_pk), GameMode.Play)