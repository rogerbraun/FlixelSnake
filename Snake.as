package {
  import org.flixel.*;

  public class Snake extends FlxGroup {
    private var _head:FlxSprite;
    private var _body:FlxGroup;
    private var _timer:Number;
    private var _speed:Number;
    private var _mps:Number;
    private var _newPart:FlxSprite;
    private var _lives:int = 3;

    public function Snake(movesPerSecond:Number = 1, length:int = 5, blockSize:int = 16, startX:int = 160, startY:int = 160) { 
      super();

      _timer = 0;

      _head = new FlxSprite(startX, startY);
      _head.makeGraphic(blockSize, blockSize);

      _body = new FlxGroup();

      resurrect(movesPerSecond, blockSize, length, startX, startY);

      add(_head);
      add(_body);
    }
    
    public function die():void {
      alive = false;
      _lives--;
    }

    private function resurrect(movesPerSecond:Number = 8, blockSize:int = 16, length:int = 5, startX:int = 160, startY:int = 160):void {
      _body.clear();
      _head.reset(startX, startY);
      _head.facing = FlxObject.RIGHT;
      fillBody(blockSize, length);
      _mps = movesPerSecond;
      _speed = 1 / _mps;
      alive = true;
    }

    public function get head():FlxSprite {
      return _head;
    }

    public function get lives():int {
      return _lives;
    }

    public function faster():void {
      if(_mps < 30)
        _mps += 1;
      
      _speed = 1 / _mps;
    }

    private function fillBody(blockSize:int, length:int):void {
      var i:int;
      for(i = 1; i <= length - 1; i++){
        var part:FlxSprite;
        part = new FlxSprite(_head.x - (i * blockSize), _head.y);
        part.makeGraphic(blockSize, blockSize);
        _body.add(part);
      } 
    }

    public function swallow(blockSize:int = 16, color:uint = 0xff00ff00):void {
      _newPart = new FlxSprite();
      _newPart.makeGraphic(blockSize, blockSize, color);
    }

    private function move():void {
      if(_newPart){ 
        _body.add(_newPart);
        _newPart = null;
      }  

      for(var i:int = _body.length - 1 ; i >= 0; i--){
        var part:FlxSprite;
        part = _body.members[i];
          if(i == 0){
            part.x = _head.x;
            part.y = _head.y; 
          } else {
            part.x = _body.members[i - 1].x;
            part.y = _body.members[i - 1].y;
          }
      }

      var xSpeed:int = 0;
      var ySpeed:int = 0;
      
      switch(_head.facing) {
        case FlxObject.RIGHT:
            xSpeed = _head.width;
          break;
        case FlxObject.LEFT:
            xSpeed = _head.width * -1;
          break;
        case FlxObject.UP:
            ySpeed = _head.height * -1;
          break;
        case FlxObject.DOWN:
            ySpeed = _head.height;
          break;
      }

      _head.x += xSpeed;
      _head.y += ySpeed;

    }

    public function get body():FlxGroup {
      return _body;
    }
     
    override public function update():void {
      super.update();

      if(FlxG.keys.UP && _head.facing != FlxObject.DOWN){
        _head.facing = FlxObject.UP;
      } else
      if(FlxG.keys.DOWN && _head.facing != FlxObject.UP){
        _head.facing = FlxObject.DOWN;
      } else 
      if(FlxG.keys.RIGHT && _head.facing != FlxObject.LEFT){
        _head.facing = FlxObject.RIGHT;
      } else 
      if(FlxG.keys.LEFT && _head.facing != FlxObject.RIGHT){
        _head.facing = FlxObject.LEFT;
      } 

      _timer += FlxG.elapsed;
      if(_timer >= _speed){
        if(alive){
          if(_head.overlaps(_body)){
            die();
          }
          move();
        } else {
          resurrect();
        }
        _timer -= _speed;
      }
    }



  }
}
