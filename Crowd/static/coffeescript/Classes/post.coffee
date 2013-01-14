class Post
  @CSRF = 'csrfmiddlewaretoken'
  constructor : (url, object, callback) ->
    csrf = $("input[name=#{Post.CSRF}]").val()
    object[Post.CSRF] = csrf
    $.post url, object, callback