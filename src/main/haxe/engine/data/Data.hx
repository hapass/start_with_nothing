package engine.data;

import js.Browser;

class Data
{
    public var stringData(default, null): String;

    public function new (id:String) {
        var element = Browser.document.getElementById(id);
        this.stringData = element.getAttribute("data-lvl-description");
    }
}