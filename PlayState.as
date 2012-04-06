package {
  import org.flixel.*;
  
  public class PlayState extends FlxState {
  
    private var _snake:Snake;
    private var _food:FlxSprite;
    
    override public function create():void {
    
      _snake = new Snake(2);
      _food = new FlxSprite(16*5,16*5).makeGraphic(16,16,0xff00ff00);

      add(_snake);
      add(_food);
      
    }

    override public function update():void {
      super.update();
      var head:FlxSprite = _snake.head()
      FlxG.overlap(head, _food, eat);
    }

    private function eat(snakeHead:FlxSprite, food:FlxSprite):void {
      FlxG.shake();
      food.kill();
    }

  }
}
