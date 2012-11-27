package com.zeusprod.components
{
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.text.TextField;

    public class CustomButton extends Sprite
    {
        private var upColor:uint = 0xFFCC00;

        private var overColor:uint = 0xCCFF00;

        private var downColor:uint = 0x00CCFF;

        private var sizeX:uint;

        private var sizeY:uint;

        private var simpleButton:SimpleButton;

        private var label:TextField;


        public function CustomButton(labelString:String = null, sizeX:uint = 65, sizeY:uint = 25)
        {
            this.sizeX = sizeX;
            this.sizeY = sizeY;
            simpleButton = new SimpleButton();
            simpleButton.downState = new ButtonDisplayState(downColor, sizeX, sizeY);
            simpleButton.overState = new ButtonDisplayState(overColor, sizeX, sizeY);
            simpleButton.upState = new ButtonDisplayState(upColor, sizeX, sizeY);
            simpleButton.hitTestState = new ButtonDisplayState(upColor, sizeX, sizeY);
            // simpleButton.hitTestState.x = -(sizeX / 4);
            // simpleButton.hitTestState.y = -(sizeY / 4);
            simpleButton.useHandCursor = true;
            addChild(simpleButton);
            if (labelString)
            {
                label = new TextField();
                label.text = labelString;
                label.selectable = false;
                addChild(label);
                label.mouseEnabled = false;
            }
        }


    }


}

