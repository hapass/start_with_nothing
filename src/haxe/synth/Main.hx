package synth;

import engine.Debug;
import engine.Audio;
import js.html.Element;
import js.html.InputElement;
import js.html.ButtonElement;
import js.Browser;

class Main {
    static function main() {
        var button = get("play", ButtonElement);
        var time = get("time", InputElement);
        var osc1Frequency = get("osc_1_frequency", InputElement);
        var osc2Frequency = get("osc_2_frequency", InputElement);

        var audio:Audio = null;
        button.addEventListener("click", (event)->{
            if (audio != null) {
                audio.dispose();
            }

            audio = new Audio();

            var parameters = new SoundParameters();

            parameters.name = "test";
            parameters.time = time.valueAsNumber;
            parameters.oscillatorOne.frequency = osc1Frequency.valueAsNumber;
            parameters.oscillatorOne.type = "sine";

            parameters.oscillatorTwo.frequency = osc2Frequency.valueAsNumber;
            parameters.oscillatorTwo.type = "sine";

            parameters.amplifier.modulation = ModulationType.Envelope;
            parameters.amplifier.sustain = 0.5;
            parameters.amplifier.peak = 1;
            parameters.amplifier.attack = 0.1;
            parameters.amplifier.decay = 0.2;
            parameters.amplifier.release = 0.1;

            parameters.filter.modulation = ModulationType.Lfo;
            parameters.filter.amplitude = 400;
            parameters.filter.frequency = 4;

            audio.playSound(parameters);
        });
    }

    public static function get<T:Element>(name:String, cls:Class<T>):T {
        var result:T = Std.downcast(Browser.document.getElementById(name), cls);
        Debug.assert(result != null, 'Cannot find ${name}');
        return result;
    }
}