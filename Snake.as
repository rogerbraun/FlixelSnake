package {
  import org.flixel.*;

  public class Snake extends FlxGroup {
    private var _head:FlxSprite;
    private var _timer:Number;
    private var _speed:Number;
    
    public function Snake(movesPerSecond:Number = 1) { 
      super();

      _speed = 1 / movesPerSecond;
      _timer = 0;

      _head = new FlxSprite(32,32);
      _head.makeGraphic(16,16);

      add(_head);
    }

    public function head():FlxSprite {
      return _head;
    }
     
    override public function update():void {
      _head.velocity.x = 0;
      _head.velocity.y = 0;

      if(FlxG.keys.UP){
        _head.velocity.y = -16;
      } else
      if(FlxG.keys.DOWN){
        _head.velocity.y = 16;
      } else 
      if(FlxG.keys.RIGHT){
        _head.velocity.x = 16;
      } else 
      if(FlxG.keys.LEFT){
        _head.velocity.x = -16;
      } 

      _timer += FlxG.elapsed;

      if(_timer >= _speed){
        _head.x += _head.velocity.x;
        _head.y += _head.velocity.y;
        _timer -= _speed;
      }
    }
  }
  
}
