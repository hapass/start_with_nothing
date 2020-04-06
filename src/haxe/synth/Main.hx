package synth;

import js.html.audio.AudioNode;
import js.html.InputElement;
import engine.Debug;
import engine.Audio;
import js.html.ButtonElement;
import js.Browser;

class Main {
    static function main() {
        var button:ButtonElement = Std.downcast(Browser.document.getElementById("play"), ButtonElement);
        Debug.assert(button != null, "Play button doesn't exist.");

        var time:InputElement = Std.downcast(Browser.document.getElementById("time"), InputElement);
        Debug.assert(time != null, "Time input doesn't exist.");

        var osc1Frequency:InputElement = Std.downcast(Browser.document.getElementById("osc_1_frequency"), InputElement);
        Debug.assert(time != null, "Oscillator 1 frequency input doesn't exist.");

        var osc2Frequency:InputElement = Std.downcast(Browser.document.getElementById("osc_2_frequency"), InputElement);
        Debug.assert(time != null, "Oscillator 2 frequency input doesn't exist.");

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
}