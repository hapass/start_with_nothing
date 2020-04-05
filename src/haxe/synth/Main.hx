package synth;

import js.html.InputElement;
import engine.Debug;
import game.Audio;
import js.html.ButtonElement;
import js.Browser;

class Main {
    static var audio:Audio = new Audio();

    static function main() {
        var button:ButtonElement = Std.downcast(Browser.document.getElementById("play"), ButtonElement);
        Debug.assert(button != null, "Play button doesn't exist.");

        var time:InputElement = Std.downcast(Browser.document.getElementById("time"), InputElement);
        Debug.assert(time != null, "Time input doesn't exist.");

        time.value = Std.string(audio.time);

        button.addEventListener("click", (event)->{
            if (!audio.isInitialized) {
                audio.initialize();
            }

            audio.time = Std.parseFloat(time.value);
            audio.play();
        });
    }
}