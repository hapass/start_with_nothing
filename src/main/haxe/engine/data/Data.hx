package engine.data;

import js.Browser;

class Data {
    public static function getString(id:String):String {
        var element = Browser.document.getElementById(id);
        return element.getAttribute("data-string");
    }
}