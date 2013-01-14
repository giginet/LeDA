class LogoScene extends Scene
  setup : ->
    url = $("#map_id").attr("mapurl")
    stage_number = url.match(/[0-9]+/)[0]
    csrf = $("input[name='csrfmiddlewaretoken']").val()
    $.getJSON url, {}, (data) ->
      # ロードが終わったらメトリックスを生成してあげる
      console.log {"stage" : stage_number, "csrfmiddlewaretoken" : csrf}
      $.post "/metrics/create", {"stage" : stage_number, "csrfmiddlewaretoken" : csrf}, (response) ->
        MaWorld.game.replaceScene(new MainScene(data))