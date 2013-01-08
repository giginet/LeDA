// Generated by CoffeeScript 1.4.0
(function() {
  var Character, Direction, GameObject, GameState, Jukebox, LogoScene, MaWorld, MainScene, Map, MapObject, Player, RotateDirection, StageType, Tile, TileSet, TileType, Timer, Vector,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Vector = (function() {

    function Vector(x, y) {
      if (x == null) {
        x = 0;
      }
      if (y == null) {
        y = 0;
      }
      this.set(x, y);
    }

    Vector.prototype.set = function(x, y) {
      if (x == null) {
        x = 0;
      }
      if (y == null) {
        y = 0;
      }
      this.x = x;
      this.y = y;
      return this;
    };

    Vector.prototype.add = function(v) {
      this.x += v.x;
      this.y += v.y;
      return this;
    };

    Vector.prototype.sub = function(v) {
      this.x -= v.x;
      this.y -= v.y;
      return this;
    };

    Vector.prototype.scale = function(n) {
      this.x *= n;
      this.y *= n;
      return this;
    };

    Vector.prototype.div = function(n) {
      this.x /= n;
      this.y /= n;
      return this;
    };

    Vector.prototype.product = function(v) {
      return this.x * v.x + this.y * v.y;
    };

    Vector.prototype.length = function() {
      return Math.sqrt(this.x * this.x + this.y * this.y);
    };

    Vector.prototype.resize = function(n) {
      if (this.length()) {
        this.scale(n / this.length());
      }
      return this;
    };

    Vector.prototype.normalize = function() {
      return this.resize(1);
    };

    Vector.prototype.angle = function() {
      return (180 * Math.atan2(this.y, this.x)) / Math.PI;
    };

    Vector.prototype.rotate = function(deg) {
      var rad, size, x, y;
      rad = (deg * Math.PI) / 180;
      size = this.length();
      x = this.x;
      y = this.y;
      this.x = Math.sin(rad) * y + Math.cos(rad) * x;
      this.y = Math.cos(rad) * y - Math.sin(rad) * x;
      return this.resize(size);
    };

    Vector.prototype.clone = function() {
      return new Vector(this.x, this.y);
    };

    Vector.prototype.reverse = function() {
      this.x *= -1;
      this.y *= -1;
      return this;
    };

    Vector.prototype.max = function(m) {
      if (this.length() <= m) {
        return this;
      }
      return this.resize(m);
    };

    Vector.prototype.min = function(m) {
      if (this.length() >= m) {
        return this;
      }
      return this.resize(m);
    };

    Vector.prototype.isZero = function() {
      return this.x === 0 && this.y === 0;
    };

    return Vector;

  })();

  Array.prototype._index = function(index) {
    var length;
    if (index < 0) {
      length = this.length;
      return length + index;
    }
    return index;
  };

  Array.prototype.at = function(index) {
    return this[this._index(index)];
  };

  Array.prototype.map = function(func) {
    var value, _ref;
    return ([].splice.apply(this, [0, this.length - 0].concat(_ref = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = this.length; _i < _len; _i++) {
        value = this[_i];
        _results.push(func(value));
      }
      return _results;
    }).call(this))), _ref);
  };

  Array.prototype.clone = function() {
    return this.dup();
  };

  Array.prototype.dup = function() {
    return this.slice(0, this.length);
  };

  Array.prototype.each = function(func) {
    var index, _i, _ref;
    for (index = _i = 0, _ref = this.length; 0 <= _ref ? _i < _ref : _i > _ref; index = 0 <= _ref ? ++_i : --_i) {
      func(this[index], index);
    }
    return this;
  };

  Array.prototype.deleteAt = function(index) {
    index = this._index(index);
    if (index >= this.length) {
      return void 0;
    }
    return this.splice(index, 1);
  };

  Array.prototype.deleteIf = function(func) {
    var i;
    return this.replace((function() {
      var _i, _ref, _results;
      _results = [];
      for (i = _i = 0, _ref = this.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        if (!func(this[i], i)) {
          _results.push(this[i]);
        }
      }
      return _results;
    }).call(this));
  };

  Array.prototype.reject = function(func) {
    var before;
    before = this.length;
    this.deleteIf(func);
    if (before === this.length) {
      return void 0;
    }
    return this;
  };

  Array.prototype.isEmpty = function() {
    return this.length === 0;
  };

  Array.prototype.isEql = function(other, eql) {
    var index, _i, _ref;
    if (eql == null) {
      eql = function(a, b) {
        return a === b;
      };
    }
    if (this.length !== other.length) {
      return false;
    }
    for (index = _i = 0, _ref = this.length; 0 <= _ref ? _i < _ref : _i > _ref; index = 0 <= _ref ? ++_i : --_i) {
      if (!eql(this[index], other[index])) {
        return false;
      }
    }
    return true;
  };

  Array.prototype.fill = function(val, start, end) {
    var i, _ref;
    if (start == null) {
      start = 0;
    }
    if (end == null) {
      end = this.length - 1;
    }
    start = this._index(start);
    end = this._index(end);
    [].splice.apply(this, [start, end - start + 1].concat(_ref = (function() {
      var _i, _results;
      _results = [];
      for (i = _i = start; start <= end ? _i <= end : _i >= end; i = start <= end ? ++_i : --_i) {
        _results.push(val);
      }
      return _results;
    })())), _ref;
    return this;
  };

  Array.prototype.first = function() {
    return this[0];
  };

  Array.prototype.last = function() {
    var last;
    last = this._index(-1);
    return this[last];
  };

  Array.prototype.uniq = function(eql) {
    var array, val, _i, _len;
    if (eql == null) {
      eql = function(a, b) {
        return a === b;
      };
    }
    array = [];
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      val = this[_i];
      if (!array.isInclude(val, eql)) {
        array.push(val);
      }
    }
    return this.replace(array);
  };

  Array.prototype.index = function(value, eql) {
    var index, _i, _ref;
    if (eql == null) {
      eql = function(a, b) {
        return a === b;
      };
    }
    for (index = _i = 0, _ref = this.length; 0 <= _ref ? _i < _ref : _i > _ref; index = 0 <= _ref ? ++_i : --_i) {
      if (eql(this[index], value)) {
        return index;
      }
    }
    return void 0;
  };

  Array.prototype.indexes = function() {
    var index, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = arguments.length; _i < _len; _i++) {
      index = arguments[_i];
      _results.push(this.at(index));
    }
    return _results;
  };

  Array.prototype.rindex = function(value, eql) {
    var index, _i, _ref;
    if (eql == null) {
      eql = function(a, b) {
        return a === b;
      };
    }
    for (index = _i = _ref = this.length; _ref <= 0 ? _i < 0 : _i > 0; index = _ref <= 0 ? ++_i : --_i) {
      if (eql(this[index], value)) {
        return index;
      }
    }
    return void 0;
  };

  Array.prototype.flatten = function() {
    return this.replace(this.reduce(function(a, b) {
      return a.concat(b instanceof Array ? b.flatten() : b);
    }, []));
  };

  Array.prototype.transpose = function() {
    var h, i, t, w, x, y, _i, _j;
    w = this.isEmpty() ? 0 : this.length;
    h = this.first() instanceof Array ? this.first().length : 0;
    if (!w || !h) {
      return this;
    }
    t = (function() {
      var _i, _results;
      _results = [];
      for (i = _i = 0; 0 <= h ? _i < h : _i > h; i = 0 <= h ? ++_i : --_i) {
        _results.push([]);
      }
      return _results;
    })();
    for (x = _i = 0; 0 <= w ? _i < w : _i > w; x = 0 <= w ? ++_i : --_i) {
      for (y = _j = 0; 0 <= h ? _j < h : _j > h; y = 0 <= h ? ++_j : --_j) {
        t[y][x] = this[x][y];
      }
    }
    return this.replace(t);
  };

  Array.prototype.compact = function() {
    return this.deleteIf(function(value) {
      return value === void 0;
    });
  };

  Array.prototype.isInclude = function(val, eql) {
    var elem, _i, _len;
    if (eql == null) {
      eql = function(a, b) {
        return a === b;
      };
    }
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      elem = this[_i];
      if (eql(elem, val)) {
        return true;
      }
    }
    return false;
  };

  Array.prototype.size = function() {
    return this.length;
  };

  Array.prototype.swap = function(a, b) {
    var tmp;
    a = this._index(a);
    b = this._index(b);
    tmp = this[a];
    this[a] = this[b];
    this[b] = tmp;
    return this;
  };

  Array.prototype.shuffle = function() {
    var i, _i, _ref;
    for (i = _i = 0, _ref = this.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      this.swap(i, Math.floor(Math.random() * this.length));
    }
    return this;
  };

  Array.prototype.choice = function() {
    return this[Math.floor(Math.random() * this.length)];
  };

  Array.prototype.count = function(val, eql) {
    var index, sum, _i, _ref;
    if (eql == null) {
      eql = function(a, b) {
        return a === b;
      };
    }
    sum = 0;
    for (index = _i = 0, _ref = this.length; 0 <= _ref ? _i < _ref : _i > _ref; index = 0 <= _ref ? ++_i : --_i) {
      if (eql(this[index], val)) {
        ++sum;
      }
    }
    return sum;
  };

  Array.prototype.replace = function(other) {
    var elem, _i, _len;
    this.clear();
    for (_i = 0, _len = other.length; _i < _len; _i++) {
      elem = other[_i];
      this.push(elem);
    }
    return this;
  };

  Array.prototype.nitems = function() {
    return this.clone().compact().size();
  };

  Array.prototype.insert = function() {
    var args, i, index, values, _i, _ref;
    args = Array.prototype.slice.call(arguments, 0, arguments.length);
    if (args.size() <= 1) {
      return this;
    }
    index = this._index(args[0]);
    values = args.slice(1, this.length);
    for (i = _i = 0, _ref = values.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      this.splice(index + i, 0, values[i]);
    }
    return this;
  };

  Array.prototype.clear = function() {
    var _results;
    _results = [];
    while (!this.isEmpty()) {
      _results.push(this.deleteAt(0));
    }
    return _results;
  };

  Array.prototype.max = function(cmp) {
    var result;
    if (cmp == null) {
      cmp = function(a, b) {
        if (a === b) {
          return 0;
        }
        if (a < b) {
          return -1;
        } else {
          return 1;
        }
      };
    }
    result = this.first();
    this.reduce(function(a, b) {
      if (cmp(result, b) < 0) {
        return result = b;
      }
    });
    return result;
  };

  Array.prototype.min = function(cmp) {
    var result;
    if (cmp == null) {
      cmp = function(a, b) {
        if (a === b) {
          return 0;
        }
        if (a < b) {
          return -1;
        } else {
          return 1;
        }
      };
    }
    result = this.first();
    this.reduce(function(a, b) {
      if (cmp(result, b) >= 0) {
        return result = b;
      }
    });
    return result;
  };

  Timer = (function() {

    function Timer(max, repeat, time, active, complete) {
      if (repeat == null) {
        repeat = false;
      }
      if (time == null) {
        time = 0;
      }
      if (active == null) {
        active = false;
      }
      if (complete == null) {
        complete = void 0;
      }
      this.set(max);
      this._time = time;
      this._active = active;
      this._onComplete = complete;
      this._onUpdate = void 0;
      this._repeat = repeat;
    }

    Timer.prototype.set = function(max) {
      if (max == null) {
        max = 0;
      }
      this._max = max;
      return this;
    };

    Timer.prototype.play = function() {
      this._active = true;
      return this;
    };

    Timer.prototype.stop = function() {
      this._active = false;
      this._time = 0;
      return this;
    };

    Timer.prototype.pause = function() {
      this._active = false;
      return this;
    };

    Timer.prototype.reset = function() {
      this._time = 0;
      return this;
    };

    Timer.prototype.tick = function() {
      if (this._time < this._max && this._active) {
        ++this._time;
        if (this._onUpdate != null) {
          this._onUpdate(this);
        }
        if (this._time === this._max) {
          if (this._onComplete != null) {
            this._onComplete(this);
          }
          if (this._repeat) {
            this._time = 0;
          }
        }
      }
      return this;
    };

    Timer.prototype.now = function() {
      return this._time;
    };

    Timer.prototype.max = function() {
      return this._max;
    };

    Timer.prototype.setNow = function(_time) {
      this._time = _time;
      return this;
    };

    Timer.prototype.setOnComplete = function(func) {
      this._onComplete = func;
      return this;
    };

    Timer.prototype.setOnUpdate = function(func) {
      return this._onUpdate = func;
    };

    Timer.prototype.setRepeat = function(repeat) {
      this._repeat = repeat;
      return this;
    };

    Timer.prototype.isActive = function() {
      return this._active;
    };

    Timer.prototype.isOver = function() {
      return this._time >= this._max;
    };

    return Timer;

  })();

  Jukebox = (function() {

    function Jukebox() {}

    Jukebox._sounds = [];

    Jukebox.root = '';

    Jukebox.load = function() {
      var sound, sounds, _i, _len, _results;
      sounds = Array.prototype.slice.call(arguments);
      _results = [];
      for (_i = 0, _len = sounds.length; _i < _len; _i++) {
        sound = sounds[_i];
        _results.push(Jukebox._loadSound(sound));
      }
      return _results;
    };

    Jukebox.play = function(sound) {
      if (!(Jukebox._sounds[sound] != null)) {
        Jukebox._loadSound(sound);
      }
      Jukebox.stop(sound);
      return Jukebox._sounds[sound].play();
    };

    Jukebox.pause = function(sound) {
      if (sound != null) {
        return Jukebox._sounds[sound].pause();
      }
    };

    Jukebox.stop = function(sound) {
      if (sound != null) {
        return Jukebox._sounds[sound].stop();
      }
    };

    Jukebox._loadSound = function(sound, mimetype) {
      if (!(Jukebox._sounds[sound] != null)) {
        if (mimetype != null) {
          return Jukebox._sounds[sound] = Sound.load("" + Jukebox.root + sound, mimetype);
        } else {
          return Jukebox._sounds[sound] = Sound.load("" + Jukebox.root + sound);
        }
      }
    };

    return Jukebox;

  })();

  enchant();

  MaWorld = (function(_super) {

    __extends(MaWorld, _super);

    MaWorld.prototype.config = {
      WIDTH: 640,
      HEIGHT: 480,
      FPS: 30,
      FONT: 'Helvetica',
      IMAGE_PATH: '/image/',
      IMAGES: ['kawaz.png', 'characters/player.png', 'chips/grass/ground.png', 'chips/grass/goal.png', 'chips/grass/hole.png', 'chips/grass/rock.png', 'cursor0.png'],
      SOUND_PATH: '/sound/',
      SOUNDS: [],
      INITIAL_LEVEL: 1,
      LAST_LEVEL: 7,
      LEVEL_TIME: 30
    };

    function MaWorld() {
      var image, root, _i, _len, _ref;
      MaWorld.__super__.constructor.call(this, this.config.WIDTH, this.config.HEIGHT);
      this.fps = this.config.FPS;
      this.keybind(90, 'a');
      this.keybind(88, 'b');
      MaWorld.game = this;
      MaWorld.config = this.config;
      _ref = this.config.IMAGES;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        image = _ref[_i];
        this.preload("" + this.config.IMAGE_PATH + image);
      }
      root = new LogoScene();
      this.onload = function() {
        root.setup();
        return this.pushScene(root);
      };
      this.start();
    }

    return MaWorld;

  })(Game);

  window.onload = function() {
    return new MaWorld();
  };

  GameObject = (function(_super) {

    __extends(GameObject, _super);

    function GameObject(w, h, x, y) {
      if (x == null) {
        x = 0;
      }
      if (y == null) {
        y = 0;
      }
      GameObject.__super__.constructor.call(this, w, h);
      this.removeEventListener('enterframe');
      this.x = x;
      this.y = y;
      this.velocity = new Vector();
      this.speed = 7;
    }

    GameObject.prototype.update = function(e) {
      this.x += this.velocity.x;
      return this.y += this.velocity.y;
    };

    GameObject.prototype.setImage = function(fileName) {
      return this.image = MaWorld.game.assets["" + MaWorld.config.IMAGE_PATH + fileName];
    };

    GameObject.prototype.getPosition = function() {
      return new Vector(this.x, this.y);
    };

    GameObject.prototype.getCenter = function() {
      return new Vector(this.x + this.width / 2, this.y + this.height / 2);
    };

    GameObject.prototype.setPosition = function(v) {
      this.x = v.x;
      return this.y = v.y;
    };

    return GameObject;

  })(Sprite);

  MapObject = (function(_super) {

    __extends(MapObject, _super);

    function MapObject(w, h) {
      MapObject.__super__.constructor.call(this, w, h);
      this.addEventListener("enterframe", this.update);
    }

    MapObject.prototype.update = function(e) {
      var _ref, _ref1;
      if ((_ref = this.timer) != null) {
        _ref.tick();
      }
      if ((_ref1 = this.timer) != null ? _ref1.isOver() : void 0) {
        return this;
      }
    };

    MapObject.prototype.setMoveAnimation = function(from, to, frame) {
      var obj;
      if (!(this.timer != null) || this.timer.isOver()) {
        this.timer = new Timer(frame);
        this.timer.play();
        obj = this;
        this.timer.setOnUpdate(function() {
          var sub, velocity;
          sub = to.clone().sub(from);
          velocity = sub.div(frame);
          obj.x += velocity.x;
          return obj.y += velocity.y;
        });
        return this.timer.setOnComplete(function() {
          return obj.setPosition(to);
        });
      }
    };

    MapObject.prototype.isMoving = function() {
      var _ref;
      return (this.timer != null) && !((_ref = this.timer) != null ? _ref.isOver() : void 0);
    };

    return MapObject;

  })(GameObject);

  Direction = {
    Up: 0,
    Right: 1,
    Down: 2,
    Left: 3
  };

  Character = (function(_super) {

    __extends(Character, _super);

    function Character(maxFrame) {
      Character.__super__.constructor.call(this, 48, 48);
      this.maxFrame = maxFrame;
      this.fps = 10;
      this.setDirection(Direction.Right);
    }

    Character.prototype.setDirection = function(direction) {
      var array, i, j, root, _i, _j, _ref, _ref1;
      direction = (direction + 4) % 4;
      root = this.maxFrame * ((direction + 2) % 4);
      array = [];
      for (i = _i = root, _ref = root + this.maxFrame; root <= _ref ? _i < _ref : _i > _ref; i = root <= _ref ? ++_i : --_i) {
        for (j = _j = 0, _ref1 = this.fps; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; j = 0 <= _ref1 ? ++_j : --_j) {
          array.push(i);
        }
      }
      this.frame = array;
      return this.direction = direction;
    };

    return Character;

  })(MapObject);

  Player = (function(_super) {

    __extends(Player, _super);

    function Player() {
      Player.__super__.constructor.call(this, 3);
      this.setImage("characters/player.png");
      this.setDirection(Direction.Up);
    }

    return Player;

  })(Character);

  StageType = {
    Grass: 0,
    Lake: 1,
    Tower: 2,
    Castle: 3,
    Cave: 4,
    Forest: 5
  };

  TileType = {
    Ground: 0,
    Goal: 1,
    Hole: 2,
    Jump: 3,
    Needle: 4,
    BrokenGround: 5,
    Ice: 6
  };

  Tile = (function(_super) {

    __extends(Tile, _super);

    Tile.WIDTH = 48;

    Tile.HEIGHT = 48;

    function Tile(localX, localY, type) {
      Tile.__super__.constructor.call(this, Tile.WIDTH, Tile.HEIGHT);
      this.setImage(this.getFilePath(StageType.Grass, type));
      this.direction = 0;
      this.addEventListener("enterframe", this.update);
      this.localX = localX;
      this.localY = localY;
      this.x = localX * Tile.WIDTH;
      this.y = localY * Tile.HEIGHT;
      this.type = type;
    }

    Tile.prototype.update = function(e) {
      return this.rotaiton = this.direction * 90;
    };

    Tile.prototype.getFilePath = function(stage, type) {
      var ROOT, stages, types;
      ROOT = "chips";
      if (type === TileType.Ice) {
        return "" + ROOT + "/ice.png";
      } else {
        stages = ["grass", "lake", "tower", "castle", "cave", "forest"];
        types = ["ground", "goal", "hole", "jump", "needle", "brokenGround"];
        return "" + ROOT + "/" + stages[stage] + "/" + types[type] + ".png";
      }
    };

    Tile.prototype.getTileType = function() {
      return this.type;
    };

    return Tile;

  })(GameObject);

  RotateDirection = {
    Left: 0,
    Right: 1
  };

  TileSet = (function(_super) {

    __extends(TileSet, _super);

    TileSet.speed = 10;

    function TileSet(map, x, y, direction) {
      var h, local, node, object, tile, w, _i, _j, _len, _len1, _ref, _ref1, _ref2, _ref3;
      TileSet.__super__.constructor.call(this);
      this.map = map;
      this.lu = this.map.getTile(x, y);
      this.ld = this.map.getTile(x, y + 1);
      this.ru = this.map.getTile(x + 1, y);
      this.rd = this.map.getTile(x + 1, y + 1);
      this.root = this.lu.getPosition().clone();
      this.end = this.lu.getPosition().clone().add(new Vector(Tile.WIDTH * 2, Tile.HEIGHT * 2));
      _ref = [this.lu, this.ld, this.ru, this.rd];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        node = _ref[_i];
        node.parentNode.removeChild(node);
        this.addChild(node);
        node.x -= this.root.x;
        node.y -= this.root.y;
      }
      this.objects = [];
      _ref1 = this.map.objects;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        object = _ref1[_j];
        if ((this.root.x <= (_ref2 = object.x) && _ref2 < this.end.x) && (this.root.y <= (_ref3 = object.y) && _ref3 < this.end.y)) {
          local = this.map.globalToLocal(object.getPosition().x, object.getPosition().y);
          tile = this.map.getTile(local.x, local.y);
          this.objects.push([object, tile]);
          this.map.objectLayer.removeChild(object);
          this.addChild(object);
          object.setPosition(this.globalToNodePosition(object.getPosition()));
        }
      }
      w = Tile.WIDTH;
      h = Tile.HEIGHT;
      this.originX = w;
      this.originY = h;
      this.x = this.root.x;
      this.y = this.root.y;
      this.count = 0;
      this.direction = direction;
      this.addEventListener('enterframe', this.update);
    }

    TileSet.prototype.update = function(e) {
      var array, local, object, rootx, rooty, speed, tile, _i, _j, _len, _len1, _ref, _ref1;
      if (!this.isEnd()) {
        if (this.direction === RotateDirection.Left) {
          speed = -TileSet.speed;
        } else {
          speed = TileSet.speed;
        }
        this.rotation += speed;
        this.count += 1;
      }
      if (this.isEnd()) {
        if (this.direction === RotateDirection.Left) {
          local = this.map.globalToLocal(this.root.x, this.root.y);
          rootx = local.x;
          rooty = local.y;
          this.map.setTile(rootx, rooty + 1, this.lu);
          this.map.setTile(rootx, rooty, this.ru);
          this.map.setTile(rootx + 1, rooty, this.rd);
          this.map.setTile(rootx + 1, rooty + 1, this.ld);
        } else {
          this.map.setTile(rootx, rooty + 1, this.rd);
          this.map.setTile(rootx, rooty, this.ld);
          this.map.setTile(rootx + 1, rooty, this.lu);
          this.map.setTile(rootx + 1, rooty + 1, this.ru);
        }
        _ref = [this.lu, this.ld, this.ru, this.rd];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          tile = _ref[_i];
          tile.rotation = 0;
          tile.originX = Tile.WIDTH * 0.5;
          tile.originY = Tile.HEIGHT * 0.5;
          tile.direction = (tile.direction + 1) % 4;
          this.removeChild(tile);
          this.map.tileLayer.addChild(tile);
        }
        _ref1 = this.objects;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          array = _ref1[_j];
          object = array[0];
          tile = array[1];
          this.removeChild(object);
          this.map.objectLayer.addChild(object);
          if (this.direction === RotateDirection.Left) {
            object.setDirection(object.direction - 1);
          } else {
            object.setDirection(object.direction + 1);
          }
          object.setPosition(tile.getPosition());
        }
        return this.map.removeChild(this);
      }
    };

    TileSet.prototype.isEnd = function() {
      return this.count >= 90 / TileSet.speed;
    };

    TileSet.prototype.globalToNodePosition = function(v) {
      return v.clone().sub(this.root);
    };

    TileSet.prototype.nodeToGlobalPosition = function(v) {
      return v.clone().add(this.root);
    };

    return TileSet;

  })(Group);

  Map = (function(_super) {

    __extends(Map, _super);

    function Map(width, height) {
      var tile, x, y, _i, _j;
      Map.__super__.constructor.apply(this, arguments);
      this.tileLayer = new Group();
      this.objectLayer = new Group();
      this.addChild(this.tileLayer);
      this._map = [];
      for (x = _i = 0; 0 <= width ? _i < width : _i > width; x = 0 <= width ? ++_i : --_i) {
        this._map.push([]);
        for (y = _j = 0; 0 <= height ? _j < height : _j > height; y = 0 <= height ? ++_j : --_j) {
          if (x === 5 && y === 5) {
            tile = new Tile(x, y, TileType.Goal);
          } else {
            tile = new Tile(x, y, TileType.Ground);
          }
          this._map[x].push(tile);
          this.tileLayer.addChild(tile);
        }
      }
      this.width = width;
      this.height = height;
      this.player = new Player();
      this.player.setPosition(this.localToGlobal(1, 1));
      this.characters = [this.player];
      this.objects = [this.player];
      this.addChild(this.objectLayer);
      this.objectLayer.addChild(this.player);
    }

    Map.prototype.getTile = function(x, y) {
      return this._map[x][y];
    };

    Map.prototype.setTile = function(x, y, tile) {
      var v;
      v = this.localToGlobal(x, y);
      tile.localX = x;
      tile.localY = y;
      tile.x = v.x;
      tile.y = v.y;
      return this._map[x][y] = tile;
    };

    Map.prototype.rotate = function(x, y, direction) {
      var h, ld, lu, rd, ru, set, w;
      if (x < 0 || x >= this.width - 1 || y < 0 || y >= this.height) {
        return null;
      }
      lu = this.getTile(x, y);
      ld = this.getTile(x, y + 1);
      ru = this.getTile(x + 1, y);
      rd = this.getTile(x + 1, y + 1);
      w = lu.width;
      h = lu.height;
      set = new TileSet(this, x, y, direction);
      return set;
    };

    Map.prototype.localToGlobal = function(x, y) {
      return new Vector(x * Tile.WIDTH, y * Tile.HEIGHT);
    };

    Map.prototype.globalToLocal = function(x, y) {
      return new Vector(Math.floor(x / Tile.WIDTH), Math.floor(y / Tile.HEIGHT));
    };

    Map.prototype.getPointWithDirection = function(v, d) {
      switch (d) {
        case Direction.Up:
          return new Vector(v.x, v.y - 1);
        case Direction.Left:
          return new Vector(v.x - 1, v.y);
        case Direction.Down:
          return new Vector(v.x, v.y + 1);
        case Direction.Right:
          return new Vector(v.x + 1, v.y);
      }
    };

    return Map;

  })(Group);

  GameState = {
    Ready: 0,
    Main: 1,
    Rotation: 2,
    Move: 3,
    Goal: 4
  };

  MainScene = (function(_super) {

    __extends(MainScene, _super);

    function MainScene() {
      var stage;
      MainScene.__super__.constructor.apply(this, arguments);
      this.map = new Map(10, 10);
      this.addChild(this.map);
      this.addEventListener('enterframe', this.update);
      this.cursor = new GameObject(144, 144);
      this.cursor.setImage("cursor0.png");
      this.cursor.x = 0;
      this.cursor.y = 100;
      stage = document.getElementById('enchant-stage');
      stage.scene = this;
      stage.addEventListener('mousemove', this.updateMousePosition);
      this.addEventListener('touchstart', this.onMousePressed);
      this.addChild(this.cursor);
      this.rotationSet = void 0;
      this.state = GameState.Main;
    }

    MainScene.prototype.setup = function() {
      return this;
    };

    MainScene.prototype.update = function(e) {
      if (this.state === GameState.Rotation) {
        if (this.rotationSet.isEnd()) {
          this.rotationSet = void 0;
          this.state = GameState.Move;
          return this.moveTo(this.map.player, this.map.player.direction, 10);
        }
      } else if (this.state === GameState.Move) {
        if (!this.map.player.isMoving()) {
          this.onMoveCompleted();
          return this.state = GameState.Main;
        }
      }
    };

    MainScene.prototype.onMoveCompleted = function() {
      var local, tile;
      local = this.map.globalToLocal(this.map.player.getPosition().x, this.map.player.getPosition().y);
      tile = this.map.getTile(local.x, local.y);
      if (tile.getTileType() === TileType.Goal) {
        return alert("goal");
      }
    };

    MainScene.prototype.updateMousePosition = function(e) {
      var cursor, v;
      cursor = this.scene.cursor;
      v = this.scene.map.globalToLocal(e.clientX, e.clientY);
      cursor.x = Tile.WIDTH * v.x - 144 / 2.0;
      return cursor.y = Tile.HEIGHT * v.y - 144 / 2.0;
    };

    MainScene.prototype.onMousePressed = function(e) {
      var v;
      v = this.map.globalToLocal(e.x, e.y).sub(new Vector(1, 1));
      return this.rotate(v, RotateDirection.Left);
    };

    MainScene.prototype.rotate = function(v, direction) {
      var set;
      if (this.state === GameState.Main) {
        set = this.map.rotate(v.x, v.y, direction);
        if (set !== null) {
          this.rotationSet = set;
          this.map.addChild(set);
          return this.state = GameState.Rotation;
        }
      }
    };

    MainScene.prototype.moveTo = function(character, direction, frame) {
      var from, local, localTo, to;
      if (__indexOf.call(this.map.characters, character) >= 0) {
        local = this.map.globalToLocal(character.x, character.y);
        from = this.map.localToGlobal(local.x, local.y);
        localTo = this.map.getPointWithDirection(local, direction);
        to = this.map.localToGlobal(localTo.x, localTo.y);
        return character.setMoveAnimation(from, to, frame);
      }
    };

    return MainScene;

  })(Scene);

  LogoScene = (function(_super) {

    __extends(LogoScene, _super);

    function LogoScene() {
      return LogoScene.__super__.constructor.apply(this, arguments);
    }

    LogoScene.prototype.setup = function() {
      this.kawaz = new GameObject(253, 81);
      this.kawaz.setImage('kawaz.png');
      this.kawaz.x = 193.5;
      this.kawaz.y = 220;
      this.kawaz.opacity = 0;
      this.addChild(this.kawaz);
      this.addEventListener('enterframe', this.update);
      this.timer = new Timer(180);
      this.timer.setOnComplete(function() {
        MaWorld.game.replaceScene(new MainScene());
        return this;
      });
      return this.timer.play();
    };

    LogoScene.prototype.update = function() {
      if (MaWorld.game.input.a) {
        MaWorld.game.replaceScene(new MainScene());
        this;

      }
      this.timer.tick();
      if (this.timer.now() < 60) {
        return this.kawaz.opacity += 1.0 / 60;
      } else if (this.timer.now() > 120) {
        return this.kawaz.opacity -= 1.0 / 60;
      }
    };

    return LogoScene;

  })(Scene);

}).call(this);
