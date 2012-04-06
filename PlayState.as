package {
  import org.flixel.*;
  
  public class PlayState extends FlxState {

    [Embed(source='assets/images/egg.png')] protected var Egg:Class;
    [Embed(source='assets/images/shell.png')] protected var Shell:Class;
  
    private var _snake:Snake;
    private var _food:FlxSprite;
    private var _shells:FlxEmitter;
    
    override public function create():void {
    
      _snake = new Snake(2);
      _food = new FlxSprite(16*5,16*5).makeGraphic(16,16,0xff00ff00);

      _shells = new FlxEmitter();
      _shells.makeParticles(Shell,4);

      add(_snake);
      add(_food);
      add(_shells);
      
    }

    override public function update():void {
      super.update();
      FlxG.overlap(_snake.head(), _food, eat);
    }

    private function eat(snakeHead:FlxSprite, food:FlxSprite):void {
      FlxG.shake();
      _shells.at(food);
      _shells.start();
      food.kill();
    }

  }
}
