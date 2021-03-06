enchant()
class MaWorld extends Game
  config : {
  WIDTH : 640,
  HEIGHT : 480,
  FPS : 30,
  FONT : 'Helvetica',
  IMAGE_PATH : '/image/',
  IMAGES : [
    'kawaz.png',
    'characters/player.png',
    'chips/grass/ground.png',
    'chips/grass/goal.png',
    'chips/grass/hole.png',
    'chips/grass/rock.png',
    'chips/cave/ground.png',
    'chips/cave/goal.png',
    'chips/cave/hole.png',
    'chips/cave/rock.png',
    'chips/cave/needle.png',
    'chips/cave/broken.png',
    'chips/ice.png',
    'chips/none.png',
    'background.png',
    'cursor0.png'
  ],
  SOUND_PATH : '/sound/',
  SOUNDS : [
  ],
  INITIAL_LEVEL : 1,
  LAST_LEVEL : 7,
  LEVEL_TIME : 30
  }
  constructor : ->
    super @config.WIDTH, @config.HEIGHT
    @fps = @config.FPS
    @keybind(90, 'a')
    @keybind(88, 'b')
    MaWorld.game = @
    MaWorld.config = @config
    for image in @config.IMAGES
      @preload("#{@config.IMAGE_PATH}#{image}")
    #Jukebox.root = @config.SOUND_PATH
    #for sound in @config.SOUNDS
    #  Jukebox._loadSound sound, 'audio/wav'
    root = new LogoScene()
    @onload = ->
      root.setup()
      @pushScene root
    @start()

window.onload = ->
  new MaWorld()