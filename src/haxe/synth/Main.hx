package synth;

import js.html.SelectElement;
import engine.Debug;
import engine.Audio;
import js.html.Element;
import js.html.InputElement;
import js.html.ButtonElement;
import js.Browser;

typedef OscillatorElements = {
    frequency:InputElement,
    wave:SelectElement,
    amplitude:InputElement
}

typedef EnvelopeElements = {
    attack:InputElement,
    decay:InputElement,
    release:InputElement,
    peak:InputElement,
    sustain:InputElement
}

typedef UI = {
    button:ButtonElement,
    time:InputElement,
    firstOscillator:OscillatorElements,
    secondOscillator:OscillatorElements,
    amplifierModulation:SelectElement,
    amplifierLfo:OscillatorElements,
    amplifierEnvelope:EnvelopeElements,
    filterModulation:SelectElement,
    filterLfo:OscillatorElements,
    filterEnvelope:EnvelopeElements
}

class Main {

    static function main() {
        var ui:UI = {
            button: get("play", ButtonElement),
            time: get("time", InputElement),
            firstOscillator: getOscillator("osc_1"),
            secondOscillator: getOscillator("osc_2"),
            amplifierModulation: get("amplifier_modulation", SelectElement),
            amplifierLfo: getOscillator("amplifier_lfo"),
            amplifierEnvelope: getEnvelope("amplifier"),
            filterModulation: get("filter_modulation", SelectElement),
            filterLfo: getOscillator("filter_lfo"),
            filterEnvelope: getEnvelope("filter")
        }

        var parameters = new SoundParameters();
        setParametersToUI(parameters, ui);

        var audio:Audio = null;
        ui.button.addEventListener("click", (event)->{
            if (audio != null) {
                audio.dispose();
            }

            audio = new Audio();
            readParametersFromUI(parameters, ui);
            audio.playSound(parameters);
        });
    }

    public static function setParametersToUI(parameters:SoundParameters, ui:UI) {
        //time
        ui.time.valueAsNumber = parameters.time;

        //oscillators
        ui.firstOscillator.frequency.valueAsNumber = parameters.oscillatorOne.frequency;
        ui.firstOscillator.amplitude.valueAsNumber = parameters.oscillatorOne.amplitude;
        ui.firstOscillator.wave.value = parameters.oscillatorOne.wave;

        parameters.oscillatorTwo.frequency = ui.secondOscillator.frequency.valueAsNumber;
        parameters.oscillatorTwo.amplitude = ui.secondOscillator.amplitude.valueAsNumber;
        parameters.oscillatorTwo.wave = ui.secondOscillator.wave.value;

        //amplifier
        ui.amplifierModulation.value = switch(parameters.amplifier.modulation) {
            case ModulationType.Envelope: "envelope";
            default: "lfo";
        };

        ui.amplifierEnvelope.attack.valueAsNumber = parameters.amplifier.attack;
        ui.amplifierEnvelope.decay.valueAsNumber = parameters.amplifier.decay;
        ui.amplifierEnvelope.release.valueAsNumber = parameters.amplifier.release;
        ui.amplifierEnvelope.peak.valueAsNumber = parameters.amplifier.peak;
        ui.amplifierEnvelope.sustain.valueAsNumber = parameters.amplifier.sustain;

        ui.amplifierLfo.amplitude.valueAsNumber = parameters.amplifier.lfo.amplitude;
        ui.amplifierLfo.frequency.valueAsNumber = parameters.amplifier.lfo.frequency;
        ui.amplifierLfo.wave.value = parameters.amplifier.lfo.wave;

        //filter
        ui.filterModulation.value = switch(parameters.filter.modulation) {
            case ModulationType.Envelope: "envelope";
            default: "lfo";
        };

        ui.filterEnvelope.attack.valueAsNumber = parameters.filter.attack;
        ui.filterEnvelope.decay.valueAsNumber = parameters.filter.decay;
        ui.filterEnvelope.release.valueAsNumber = parameters.filter.release;
        ui.filterEnvelope.peak.valueAsNumber = parameters.filter.peak;
        ui.filterEnvelope.sustain.valueAsNumber = parameters.filter.sustain;

        ui.filterLfo.amplitude.valueAsNumber = parameters.filter.lfo.amplitude;
        ui.filterLfo.frequency.valueAsNumber = parameters.filter.lfo.frequency;
        ui.filterLfo.wave.value = parameters.filter.lfo.wave;
    }

    public static function readParametersFromUI(parameters:SoundParameters, ui:UI) {
        //time
        parameters.time = ui.time.valueAsNumber;

        //oscillators
        parameters.oscillatorOne.frequency = ui.firstOscillator.frequency.valueAsNumber;
        parameters.oscillatorOne.amplitude = ui.firstOscillator.amplitude.valueAsNumber;
        parameters.oscillatorOne.wave = ui.firstOscillator.wave.value;

        parameters.oscillatorTwo.frequency = ui.secondOscillator.frequency.valueAsNumber;
        parameters.oscillatorTwo.amplitude = ui.secondOscillator.amplitude.valueAsNumber;
        parameters.oscillatorTwo.wave = ui.secondOscillator.wave.value;

        //amplifier
        parameters.amplifier.modulation = switch(ui.amplifierModulation.value) {
            case "envelope": ModulationType.Envelope;
            default: ModulationType.Lfo;
        };

        parameters.amplifier.attack = ui.amplifierEnvelope.attack.valueAsNumber;
        parameters.amplifier.decay = ui.amplifierEnvelope.decay.valueAsNumber;
        parameters.amplifier.release = ui.amplifierEnvelope.release.valueAsNumber;
        parameters.amplifier.peak = ui.amplifierEnvelope.peak.valueAsNumber;
        parameters.amplifier.sustain = ui.amplifierEnvelope.sustain.valueAsNumber;

        parameters.amplifier.lfo.amplitude = ui.amplifierLfo.amplitude.valueAsNumber;
        parameters.amplifier.lfo.frequency = ui.amplifierLfo.frequency.valueAsNumber;
        parameters.amplifier.lfo.wave = ui.amplifierLfo.wave.value;

        //filter
        parameters.filter.modulation = switch(ui.filterModulation.value) {
            case "envelope": ModulationType.Envelope;
            default: ModulationType.Lfo;
        };

        parameters.filter.attack = ui.filterEnvelope.attack.valueAsNumber;
        parameters.filter.decay = ui.filterEnvelope.decay.valueAsNumber;
        parameters.filter.release = ui.filterEnvelope.release.valueAsNumber;
        parameters.filter.peak = ui.filterEnvelope.peak.valueAsNumber;
        parameters.filter.sustain = ui.filterEnvelope.sustain.valueAsNumber;

        parameters.filter.lfo.amplitude = ui.filterLfo.amplitude.valueAsNumber;
        parameters.filter.lfo.frequency = ui.filterLfo.frequency.valueAsNumber;
        parameters.filter.lfo.wave = ui.filterLfo.wave.value;
    }

    public static function setParametersStorage(parameters:SoundParameters) {
        throw "not implemented";
    }

    public static function readParametersStorage():SoundParameters {
        throw "not implemented";
    }

    public static function get<T:Element>(name:String, cls:Class<T>):T {
        var result:T = Std.downcast(Browser.document.getElementById(name), cls);
        Debug.assert(result != null, 'Cannot find ${name}');
        return result;
    }

    public static function getOscillator(name:String):OscillatorElements {
        return {
            frequency: get('${name}_frequency', InputElement),
            wave: get('${name}_wave', SelectElement),
            amplitude: get('${name}_amplitude', InputElement)
        }
    }

    public static function getEnvelope(name:String):EnvelopeElements {
        return {
            attack: get('${name}_attack', InputElement),
            decay: get('${name}_decay', InputElement),
            release: get('${name}_release', InputElement),
            peak: get('${name}_peak', InputElement),
            sustain: get('${name}_sustain', InputElement)
        }
    }
}