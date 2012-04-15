package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;
  
  public class PlayState extends FlxState {

    [Embed(source='assets/images/egg.png')] protected var Egg1:Class;
    [Embed(source='assets/images/shell.png')] protected var Shell1:Class;
    [Embed(source='map/level.png')] protected var LevelTiles:Class;
    [Embed(source='map/level.csv', mimeType='application/octet-stream')] protected var LevelCSV:Class;
  
    private var _snake:Snake;
    private var _food:FlxGroup;
    private var _hud:FlxText;
    private var _pointHud:Tween;
    private var _score:int;
    private var _map:FlxTilemap;
    private var _level:FlxGroup;
    override public function create():void {

      FlxG.log("Starting game");

      FlxG.mouse.hide();

      _score = 0;
      
      _map = new FlxTilemap(); 
      _map.loadMap(new LevelCSV, LevelTiles, 16, 16);
      _level = new FlxGroup();
      _level.add(_map);
      
      _snake = new Snake(8);

      _food = new FlxGroup();
      addFood();

      _hud = new FlxText(32,32,400,'0');
      _hud.size = 16;

      add(_level);
      add(_snake);
      add(_food);
      add(_hud);

      FlxKongregate.init(apiHasLoaded);
      
    }

    private function apiHasLoaded():void
    {
      FlxKongregate.connect();
      FlxG.log(FlxKongregate.isLocal);
      FlxG.log(FlxKongregate.getUserName);
      updateHud();
    }

    private function updateHud():void {
      _hud.text = "Hi, " + FlxKongregate.getUserName +"! Score: " + String(_score) + "\nLives: " + String(_snake.lives);
      _hud.y = ((64 - _hud.height) / 2) + 16;
    }


    override public function update():void {
      super.update();

      if(_snake.lives < 0) {
        FlxG.score = _score;
        FlxG.switchState(new GameOver);
      }
      
      updateHud();

      // I tried to use FlxG.overlap for this, but sometimes, the callback will
      // be called twice. This works, so leave it like this.
      for(var i:int = 0; i < _food.length; i++){
        if(_snake.head.overlaps(_food.members[i])){
          eat(_snake.head, _food.members[i]);
        }
      }
      FlxG.collide(_snake.head, _level, hitBoundary);
    }


    private function initPointHUD(egg:Egg):void{
      var points:int = egg.points;
      _pointHud = new Tween(0.5, 20, egg.x, egg.y, 40, points.toString());
      add(_pointHud); 
      
    }

    private function eat(snakeHead:FlxSprite, egg:Egg):void {
      FlxG.log("Eating at " + snakeHead.x + ", " + snakeHead.y);
      FlxG.shake();

      var shells:FlxEmitter = egg.shells;
      shells.at(snakeHead);
      shells.start(true, 3);

      initPointHUD(egg);
    
      _food.remove(egg);
      egg.kill();

      addFood();

      _snake.faster();
      _snake.swallow();
      _score++;
    }

    private function hitBoundary(snakeHead:FlxObject, tile:FlxObject):void {
      FlxG.log("Hitting at " + tile.x + ", " + tile.y);
      _snake.die(); 
    }

    private function addFood():void{
      var egg:Egg = new Egg(Egg1, Shell1);
      egg.randomPlace(_snake);

      _food.add(egg);
    }
     
  }
}
