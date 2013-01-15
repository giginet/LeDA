class LogoScene extends Scene
  setup : (preMetricPK, stage=undefined) ->
    if stage?
      stageNo = stage['pk']
      url = "/levels/#{stageNo}/json"
      $("#stage_url").attr("stageurl", url)
    else
      url = $("#stage_url").attr("stageurl")
      stageNo = url.match(/[0-9]+/)[0]
    $mode = $("#mode")
    mode = $mode?.attr("mode")
    $.getJSON url, {}, (data) ->
      if mode == "Metric"
        # 再生モードにする
        $metric = $("#metric_url")
        metricURL = $metric.attr("metricurl")
        metric = new Metric()
        metric.load metricURL, (metricData) ->
          MaWorld.game.replaceScene(new MainScene(data["stage_data"], GameMode.Metric, undefined, metric))
      else if mode == "View"
        # ステージ閲覧モード
        MaWorld.game.replaceScene(new MainScene(data["stage_data"], GameMode.View, undefined, undefined))
      else
        # ロードが終わったらメトリックスを生成してあげる
        param = {"stage" : stageNo}
        if preMetricPK?
          param["pre_metric"] = preMetricPK
        new Post "/metrics/create", param, (response) ->
          metric_pk = response['pk']
          MaWorld.game.replaceScene(new MainScene(data["stage_data"], GameMode.Play, metric_pk))