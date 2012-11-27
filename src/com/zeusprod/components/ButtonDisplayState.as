package com.zeusprod.components
{
    import flash.display.Shape;

    public class ButtonDisplayState extends Shape
    {

        private var bgColor:uint;

        private var sizeX:uint;

        private var sizeY:uint;

        public function ButtonDisplayState(bgColor:uint, sizeX:uint, sizeY:uint)
        {
            this.bgColor = bgColor;
            this.sizeX = sizeX;
            this.sizeY = sizeY;
            draw();
        }

        private function draw():void
        {
            graphics.beginFill(bgColor);
            graphics.drawRect(0, 0, sizeX, sizeY);
            graphics.endFill();
        }
    }
}
