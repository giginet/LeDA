class Metric extends Group
  constructor : ->
    super()
    @time = 0

  load : (metricURL, callback) ->
    metric = @
    $.getJSON metricURL, {}, (data) ->
      callback(data)
      metric.data = data
      metric.operations = data['operations']
      metric.addEventListener 'enterframe', metric.update

  setScene : (scene) ->
    @scene = scene

  update : (e) ->
    if not @operations.isEmpty()
      operation = @operations[0]
      if operation.offset < @time
        @performOperation(operation)
        @operations.shift()
    @time += e.elapsed / 1000.0

  performOperation : (operation) ->
    if @scene?
      v = new Vector(operation.x, operation.y)
      @scene.rotate(v, operation.direction)