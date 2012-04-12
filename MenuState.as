package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;
  import org.flixel.plugin.photonstorm.FX.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;
  
  public class MenuState extends FlxState {

    [Embed(source='assets/images/egg.png')] protected var Egg:Class;

    private var _snakeTitleFX:SineWaveFX;
    private var _snakeTitleText:FlxText;
    private var _snakeTitleSprite:FlxSprite;
    private var _playButton:FlxButton;

    //snake
    private var _head:FlxSprite;
    private var _body:FlxGroup;
    private var _newPart:FlxSprite;

    //timer
    private var _timer:Number;
    private static var _SPEED:Number;

    //wind
    private var _wind:uint;

    override public function create():void {

      if (FlxG.getPlugin(FlxSpecialFX) == null)
      {
        FlxG.addPlugin(new FlxSpecialFX);
      }
      
      

      _snakeTitleFX = FlxSpecialFX.sineWave();     
      _snakeTitleText = new FlxText(120,50,400,'SNAKE');
      _snakeTitleText.size = 100;
      _snakeTitleText.antialiasing = true;
      _snakeTitleText.alignment = 'center';
  
      _snakeTitleSprite = _snakeTitleFX.createFromFlxSprite(_snakeTitleText, SineWaveFX.WAVETYPE_VERTICAL_SINE,32, _snakeTitleText.width, 8);

      _snakeTitleFX.start();


      FlxKongregate.init(apiHasLoaded);

      FlxG.mouse.show();
      
      //make snake
      _head = new FlxSprite(0, 0);
      _head.makeGraphic(20, 20, randColor());
      _head.facing = FlxObject.RIGHT;

      _body = new FlxGroup();
      
      //set timer
      _timer = 0;
      _SPEED =  1 / 80;

      //wind
      _wind = 1; 


      add(_head);
      add(_body);
      add(_snakeTitleSprite);
    }
    
    //get a random color
    private function randColor():uint {
      var _randG:uint = int(Math.random() * 155 + 100);
      var _randR:uint = int(Math.random() * 255);
      var _randB:uint = int(Math.random() * 255);
      
      return FlxU.makeColor(_randG, _randR, _randB);
    }

    private function grow():void{
      _newPart = new FlxSprite();
      _newPart.makeGraphic(20, 20, randColor());
      _body.add(_newPart);
    }

    private function move():void{
      if (_body.length < 150) {
        grow();
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
            xSpeed = _head.frameWidth;
          break;
        case FlxObject.LEFT:
            xSpeed = _head.frameWidth * -1;
          break;
        case FlxObject.UP:
            ySpeed = _head.frameHeight * -1;
          break;
        case FlxObject.DOWN:
            ySpeed = _head.frameHeight;
          break;
      }

      _head.x += xSpeed;
      _head.y += ySpeed;

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
    
    private function isWithin(obj:FlxSprite, startX:int, startY:int, endX:int, endY:int):Boolean {
      return obj.x >= startX && obj.y >= startY && obj.x <= endX && obj.y <= endY;
    }

    override public function update():void {
      super.update();
      
      _timer += FlxG.elapsed;
      if(_timer >= _SPEED){
        changeDir();
        move();
        _timer -= _SPEED;

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

    private function apiHasLoaded():void
    {
      FlxKongregate.connect();
      _playButton = new FlxButton(FlxG.width/2-40, 300, 'Play Snake!', switchToPlayState); 
      add(_playButton);
    }

    private function switchToPlayState():void {
      FlxG.switchState(new PlayState);
    }

    override public function destroy():void {
      FlxSpecialFX.clear();
      super.destroy();
    }
  }
}
