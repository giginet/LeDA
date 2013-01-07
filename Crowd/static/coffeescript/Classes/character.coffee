Direction =
  Up : 0
  Right : 1
  Down : 2
  Left : 3


class Character extends GameObject
  constructor : (maxFrame) ->
    super(48, 48)
    @maxFrame = maxFrame
    @fps = 10

  setDirection : (direction) ->
    root = @maxFrame * ((direction + 2) % 4)
    array = []
    for i in [root...(root + @maxFrame)]
      for j in [0...@fps]
        array.push i
    @frame = array