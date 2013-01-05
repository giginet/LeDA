class MainScene extends Scene
  constructor : ->
    super
    @stage = new Map()
    @addChild @stage
    @addEventListener 'enterframe', @update

  setup : ->
    @

  update : ->
    @