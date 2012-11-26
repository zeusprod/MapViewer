// MapViewer protoype.
// See http://stackoverflow.com/questions/10866636/actionscript-3-import-svg-file
// https://github.com/LucasLorentz/AS3SVGRenderer
package com.zeusprod.mapviewer
{
    [SWF(width = "1000", height = "800", frameRate = "60", backgroundColor = "#FFFFFF")]
    import com.lorentz.SVG.display.SVGDocument;
    import com.lorentz.processing.ProcessExecutor;

    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.utils.Dictionary;

    import flashx.textLayout.accessibility.TextAccImpl;


    public class MapViewer extends Sprite
    {
        private var maps:Dictionary;

        private var offsets:Dictionary;

        private static const BASE_PATH:String = "http://upload.wikimedia.org/wikipedia/commons/";

        //http://upload.wikimedia.org/wikipedia/commons/6/6f/Electoral_College_2012.svg
        //http://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Electoral_College_2012.svg/1000px-Electoral_College_2012.svg.png

        private static const SVG_PATH:String = BASE_PATH + "MAPCODE/ElectoralCollegeYYYY.svg";

        //private static const PATH_1868:String = "1868GrantSeymour";

        //  private static const GRANT_1868:int = 1868;

        private static const PATH_2016:String = "Electoral_College_2012";

        private static const EV_2016:int = 2016;

        private static const PNG_PATH:String = BASE_PATH + "thumb/MAPCODE/ElectoralCollegeYYYY.svg/1000px-ElectoralCollegeYYYY.svg.png";

        private static const ELECTORAL_COLLEGE_YEAR:String = "ElectoralCollegeYYYY";

        private static const YEAR_PLACEHOLDER:String = "YYYY";

        private static const MAP_PLACEHOLDER:String = "MAPCODE"

        private static const ELECTION_INTERVAL_THREE:int = 3;

        private static const ELECTION_INTERVAL_FOUR:int = 4;

        private static const YEAR_1789:int = 1789;

        private static const MIN_YEAR:int = YEAR_1789;

        private static const MAX_YEAR:int = 2016;

        private static const INITIAL_YEAR:int = 2012;

        private static const FUDGE_OFFSET_X:int = 0;

        private static const FUDGE_OFFSET_Y:int = 3;

        private static const OFFSET_X:int = 0;

        private var container:MovieClip;

        // private var svgDocument:SVGDocument;

        private var svgDocument1:SVGDocument;

        private var svgDocument2:SVGDocument;

        private var svgLoader:URLLoader;

        private var pngLoader:Loader;

        private var next:TextField;

        private var current:TextField;

        private var previous:TextField;

        private var goTo:TextField;

        private static const SVG:String = "SVG";

        private static const PNG:String = "PNG";

        private static var format:String = PNG;

        public function MapViewer()
        {
            trace("got to mapviewer");
            maps = new Dictionary();
            offsets = new Dictionary();

            maps[1789] = "1/1b";
            maps[1792] = "b/b0";
            maps[1796] = "d/d5";
            maps[1800] = "0/04";
            maps[1804] = "e/e7";
            maps[1808] = "c/c9";
            maps[1812] = "0/02";
            maps[1816] = "1/1f";
            maps[1820] = "e/ef";
            maps[1824] = "e/ea";
            maps[1828] = "0/01";
            maps[1832] = "0/0e";
            maps[1836] = "a/a7";
            maps[1840] = "c/c4";
            maps[1844] = "1/14";
            maps[1848] = "7/73";
            maps[1852] = "2/23";
            maps[1856] = "7/7a";
            maps[1860] = "0/01";
            maps[1864] = "0/0d";
            maps[1868] = "c/ce";
            maps[1872] = "c/c8";
            maps[1876] = "7/77";
            maps[1880] = "2/21";
            maps[1884] = "a/ad";
            maps[1888] = "f/f4";
            maps[1892] = "7/78";
            maps[1896] = "7/74";
            maps[1900] = "4/4a";
            maps[1904] = "a/aa";
            maps[1908] = "0/07";
            maps[1912] = "a/a9";
            maps[1916] = "e/e1";
            maps[1920] = "b/ba";
            maps[1924] = "1/1c";
            maps[1928] = "b/bb";
            maps[1932] = "0/00";
            maps[1936] = "5/50";
            maps[1940] = "4/49";
            maps[1944] = "2/29";
            maps[1948] = "2/2f";
            maps[1952] = "a/a5";
            maps[1956] = "3/3e";
            maps[1960] = "5/5d";
            maps[1964] = "c/ce";
            maps[1968] = "4/41";
            maps[1972] = "3/30";
            maps[1976] = "4/43";
            maps[1980] = "5/5c";
            maps[1984] = "a/ab";
            maps[1988] = "f/fe";
            maps[1992] = "6/6a";
            maps[1996] = "1/12";
            maps[2000] = "1/19";
            maps[2004] = "e/e2";
            maps[2008] = "2/24";
            maps[2012] = "4/44";
            maps[2016] = "6/6f";
            offsets[1972] = { x: FUDGE_OFFSET_X, y: FUDGE_OFFSET_Y };
            offsets[1976] = { x: FUDGE_OFFSET_X, y: FUDGE_OFFSET_Y };
            offsets[1980] = { x: FUDGE_OFFSET_X, y: FUDGE_OFFSET_Y };

            this.addEventListener(Event.ADDED_TO_STAGE, stageInit);

        }

        private function stageInit(evt:Event):void
        {
            if (format == SVG)
                initSVG();
            else
                initPNG();

            container = new MovieClip();
            this.addChild(container);

            next = new TextField();
            next.text = "NEXT";
            next.selectable = false;
            previous = new TextField();
            previous.text = "PREVIOUS";
            previous.selectable = false;

            previous.x = OFFSET_X;
            next.x = previous.x + 400;
            next.y = previous.y = 300;

            next.addEventListener(MouseEvent.CLICK, nextYear);
            previous.addEventListener(MouseEvent.CLICK, previousYear);

            current = new TextField();
            current.text = String(INITIAL_YEAR);
            current.x = (next.x + previous.x) / 2;
            current.y = next.y;
            current.type = TextFieldType.INPUT;

            goTo = new TextField();
            goTo.text = "GO";
            goTo.selectable = false;
            goTo.x = (next.x + previous.x) / 2;
            goTo.y = next.y + 30;
            goTo.addEventListener(MouseEvent.CLICK, loadMapByYear);

            loadMapByYear();

            this.addChild(next);
            this.addChild(previous);
            this.addChild(current);
            this.addChild(goTo);

        }

        private function initPNG():void
        {
            pngLoader = new Loader();
            pngLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, pngLoaded, false, 0, true);
            pngLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, pngLoadFailed);
        }


        private function initSVG():void
        {
            //svgDocument = new SVGDocument();
            svgDocument1 = new SVGDocument();
            svgDocument2 = new SVGDocument();

            svgLoader = new URLLoader();
            svgLoader.dataFormat = URLLoaderDataFormat.TEXT;
            svgLoader.addEventListener(Event.COMPLETE, svgLoaded, false, 0, true);
            svgLoader.addEventListener(IOErrorEvent.IO_ERROR, svgLoadFailed);

        }

        private function nextYear(evt:MouseEvent):void
        {
            var temp:int = int(current.text);

            temp += (temp == YEAR_1789) ? ELECTION_INTERVAL_THREE : ELECTION_INTERVAL_FOUR;

            if (temp > MAX_YEAR)
            {
                temp = MAX_YEAR;
                return;
            }

            current.text = String(temp);
            loadMapByYear();
        }

        private function previousYear(evt:MouseEvent):void
        {
            var temp:int = int(current.text);

            if (temp == MIN_YEAR) // Special handling for 1789
                return;
            else
                temp -= ELECTION_INTERVAL_FOUR;

            if (temp < MIN_YEAR)
                temp = MIN_YEAR;

            current.text = String(temp);
            loadMapByYear();
        }

        private function loadMapByYear(year:int = NaN):void
        {
            if (isNaN(year) || year == 0)
                year = int(current.text);

            if (format == SVG)
                loadSVG(createPath(year, SVG_PATH));
            else
                loadPNG(createPath(year, PNG_PATH));

        }

        private function createPath(year:int, path:String):String
        {
            if (year == EV_2016)
                path = replaceAll(path, ELECTORAL_COLLEGE_YEAR, PATH_2016);
            path = replaceAll(path, MAP_PLACEHOLDER, maps[year]);
            path = replaceAll(path, YEAR_PLACEHOLDER, String(year));
            return path;
        }

        private static function replaceAll(inString:String, replaceThis:String, replaceWithThis:String):String
        {
            //return inString.replace(new RegExp("/" + replaceThis + "/g"), replaceWithThis);
            return inString.split(replaceThis).join(replaceWithThis);
        }


        private function loadSVGByYear(year:int):void
        {

            var temp:String = SVG_PATH;
            temp = temp.replace(MAP_PLACEHOLDER, maps[year]);
            temp = temp.replace(YEAR_PLACEHOLDER, String(year));
            loadSVG(temp);
        }


        private function loadPNG(url:String):void
        {
            initPNG();

            try
            {
                pngLoader.load(new URLRequest(url));
            }
            catch (error:Error)
            {
                trace("Error loading is " + error);
            }
        }

        private function loadSVG(url:String):void
        {
            ProcessExecutor.instance.initialize(stage);
            ProcessExecutor.instance.percentFrameProcessingTime = 0.9;

            initSVG();
            try
            {
                svgLoader.load(new URLRequest(url));
            }
            catch (error:Error)
            {
                trace("Error loading is " + error);
            }
        }

        private function svgLoaded(e:Event):void
        {
            var svgString:String = svgLoader.data as String;
            var svgDocument:SVGDocument;

            if (svgDocument1)
            {
                svgDocument = svgDocument2;
            }
            else
            {
                svgDocument = svgDocument1;
            }

            svgDocument.parse(svgString);

            // svgDocument.height = 500;
            //svgDocument.width = 600;
            svgDocument.scaleX = 0.5;
            svgDocument.scaleY = 0.5;
            svgDocument.x = (offsets[int(current.text)]) ? offsets[int(current.text)].x : 0;
            svgDocument.y = (offsets[int(current.text)]) ? offsets[int(current.text)].y : 0;

            container.addChild(svgDocument);

            if (container.numChildren > 1)
                container.removeChildAt(0);

            //container.alpha = 0.5;
            container.x = OFFSET_X;
        }

        private function svgLoadFailed(err:IOErrorEvent):void
        {
            trace("ERROR: SVG load failed due to " + err.text);
        }

        private function pngLoaded(e:Event):void
        {
            //var pngData:ByteArray = pngLoader.data;
            //   trace("PNG loaded");


            //pngLoader.scaleX = 0.5;
            // pngLoader.scaleY = 0.5;

            // pngLoader.width = 800;
            // pngLoader.height = 600;
            // pngLoader.x = OFFSET_X;

            if (pngLoader.height > 600)
            {

                container.scaleX = 0.29;
                container.scaleY = 0.29;
                container.x = +OFFSET_X;
            }
            else
            {
                container.scaleX = 0.5;
                container.scaleY = 0.5;
                container.x = OFFSET_X;
            }
            container.addChild(pngLoader);


            if (container.numChildren > 1)
                container.removeChildAt(0);
        }

        private function pngLoadFailed(err:IOErrorEvent):void
        {
            trace("ERROR: PNG load failed due to " + err.text);
        }
    }
}
