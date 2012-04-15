package {
  import org.flixel.*;

  public class DemoSnake extends Snake {
    private var _wind:int = 1;    

    public function DemoSnake(){
      super(60, 1, 20, 0, 0);
    }

    //get a random color
    private function randColor():uint {
      var _randG:uint = int(Math.random() * 155 + 100);
      var _randR:uint = int(Math.random() * 255);
      var _randB:uint = int(Math.random() * 255);
        
      return FlxU.makeColor(_randG, _randR, _randB);
    }


    override protected function move():void{
        if (_body.length < 150) {
          swallow(_head.width, randColor());
        }
        super.move();
    }


    private function changeDir():void {
      if (_head.facing == FlxObject.RIGHT && _head.x == FlxG.width - _head.width * _wind) {
        _head.facing = FlxObject.DOWN;
      }
      if (_head.facing == FlxObject.DOWN && _head.y == FlxG.height - _head.height * _wind) {
       _head.facing = FlxObject.LEFT;
      }
      if (_head.facing == FlxObject.LEFT && _head.x == _head.height * (_wind - 1)) {
       _head.facing = FlxObject.UP;
      }
      if (_head.facing == FlxObject.UP && _head.y == _head.height * _wind) {
       _head.facing = FlxObject.RIGHT;
       _wind++;
      }
    }


    override public function update():void{
        _timer += FlxG.elapsed;
        if(_timer >= _speed){
          changeDir();
          move();
          _timer -= _speed;

          if(_head.overlaps(_body)) {
            FlxG.shake();
          }

          if(!_body.members[_body.length - 1].onScreen()) {
            _body.clear();
            _head.reset(0, 0);
            _head.facing = FlxObject.RIGHT;
            _wind = 1;
          } 
        } 

    }





  }
}
