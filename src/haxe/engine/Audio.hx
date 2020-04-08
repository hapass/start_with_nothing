package engine;

import js.html.audio.BiquadFilterType;
import js.html.audio.BiquadFilterNode;
import js.html.audio.GainNode;
import js.html.audio.OscillatorType;
import js.html.audio.OscillatorNode;
import js.html.audio.AudioContext;

class ModulationParameters {
    public var modulation:String = "lfo";

    //timing percentage
    public var attack:Float = 0.0;
    public var decay:Float = 0.0;
    public var release:Float = 0.0;

    //levels
    public var sustain:Float = 0.0;
    public var peak:Float = 0.0;

    //lfo
    public var lfo:OscillatorParameters = new OscillatorParameters();

    public function new() {}
}

class OscillatorParameters {
    public var frequency:Float = 200.0;
    public var amplitude:Float = 1.0;
    public var wave:String = "sine";

    public function new() {}
}

class SoundParameters {
    public var name:String = "default";
    public var time:Float = 0.5;
    public var oscillatorOne:OscillatorParameters = new OscillatorParameters();
    public var oscillatorTwo:OscillatorParameters = new OscillatorParameters();
    public var filter:ModulationParameters = new ModulationParameters();
    public var amplifier:ModulationParameters = new ModulationParameters();

    public function new() {}
}

class Filter {
    private var filter:BiquadFilterNode;
    private var oscillator:OscillatorNode;
    private var oscillatorAmplifier:GainNode;
    private var parameters:ModulationParameters;
    private var context:AudioContext;

    public function new(context:AudioContext, parameters:ModulationParameters, time:Float) {
        this.context = context;
        this.parameters = parameters;
        this.filter = this.context.createBiquadFilter();
        this.filter.type = BiquadFilterType.LOWPASS;
        this.oscillator = this.context.createOscillator();
        this.oscillatorAmplifier = this.context.createGain();

        switch (this.parameters.modulation) {
            case "envelope":
                var attackTime = this.context.currentTime + this.parameters.attack * time;
                var decayTime = attackTime + this.parameters.decay * time;
                var sustainTime = this.context.currentTime + time - this.parameters.release * time;
                var releaseTime = this.context.currentTime + time;

                this.filter.frequency.setValueAtTime(0, this.context.currentTime);
                this.filter.frequency.linearRampToValueAtTime(this.parameters.peak, attackTime);
                this.filter.frequency.linearRampToValueAtTime(this.parameters.sustain, decayTime);
                this.filter.frequency.linearRampToValueAtTime(this.parameters.sustain, sustainTime);
                this.filter.frequency.linearRampToValueAtTime(0, releaseTime);
            case "lfo":
                this.oscillator.type = switch (this.parameters.lfo.wave) {
                    case "sine": OscillatorType.SINE;
                    case "square": OscillatorType.SQUARE;
                    case "sawtooth": OscillatorType.SAWTOOTH;
                    case "triangle": OscillatorType.TRIANGLE;
                    default: OscillatorType.SINE;
                };
                this.oscillator.frequency.value = this.parameters.lfo.frequency;
                this.oscillatorAmplifier.gain.value = this.parameters.lfo.amplitude;
                this.oscillator.connect(this.oscillatorAmplifier).connect(this.filter.frequency);
                this.oscillator.start();
        }
    }

    public function getNode() {
        return this.filter;
    }
}

class Amplifier {
    private var amplifier:GainNode;
    private var oscillator:OscillatorNode;
    private var oscillatorAmplifier:GainNode;
    private var parameters:ModulationParameters;
    private var context:AudioContext;

    public function new(context:AudioContext, parameters:ModulationParameters, time:Float) {
        this.context = context;
        this.parameters = parameters;
        this.amplifier = this.context.createGain();
        this.oscillator = this.context.createOscillator();
        this.oscillatorAmplifier = this.context.createGain();

        switch (this.parameters.modulation) {
            case "envelope":
                var attackTime = this.context.currentTime + this.parameters.attack * time;
                var decayTime = attackTime + this.parameters.decay * time;
                var sustainTime = this.context.currentTime + time - this.parameters.release * time;
                var releaseTime = this.context.currentTime + time;

                this.amplifier.gain.setValueAtTime(0, this.context.currentTime);
                this.amplifier.gain.linearRampToValueAtTime(this.parameters.peak, attackTime);
                this.amplifier.gain.linearRampToValueAtTime(this.parameters.sustain, decayTime);
                this.amplifier.gain.linearRampToValueAtTime(this.parameters.sustain, sustainTime);
                this.amplifier.gain.linearRampToValueAtTime(0, releaseTime);
            case "lfo":
                this.oscillator.type = switch (this.parameters.lfo.wave) {
                    case "sine": OscillatorType.SINE;
                    case "square": OscillatorType.SQUARE;
                    case "sawtooth": OscillatorType.SAWTOOTH;
                    case "triangle": OscillatorType.TRIANGLE;
                    default: OscillatorType.SINE;
                };
                this.oscillator.frequency.value = this.parameters.lfo.frequency;
                this.oscillatorAmplifier.gain.value = this.parameters.lfo.amplitude;
                this.oscillator.connect(this.oscillatorAmplifier).connect(this.amplifier.gain);
                this.oscillator.start();
        }
    }

    public function getNode() {
        return this.amplifier;
    }
}

class Oscillator {
    public var isPlaying:Bool = false;

    private var oscillator:OscillatorNode;
    private var parameters:OscillatorParameters;
    private var context:AudioContext;
    private var amplifier:GainNode;

    public function new(context:AudioContext, parameters:OscillatorParameters, time:Float) {
        this.context = context;
        this.parameters = parameters;
        this.oscillator = this.context.createOscillator();
        this.oscillator.type = switch (this.parameters.wave) {
            case "sine": OscillatorType.SINE;
            case "square": OscillatorType.SQUARE;
            case "sawtooth": OscillatorType.SAWTOOTH;
            case "triangle": OscillatorType.TRIANGLE;
            default: OscillatorType.CUSTOM;
        };
        this.oscillator.frequency.value = this.parameters.frequency;

        this.amplifier = this.context.createGain();
        this.amplifier.gain.value = this.parameters.amplitude;
        this.oscillator.connect(this.amplifier);

        this.isPlaying = true;
        this.oscillator.start();
        this.oscillator.stop(this.context.currentTime + time);
        this.oscillator.onended = ()->{ this.isPlaying = false; };
    }

    public function getNode() {
        return this.amplifier;
    }
}

class Sound {
    private var oscillatorOne:Oscillator;
    private var oscillatorTwo:Oscillator;
    private var filter:Filter;
    private var amplifier:Amplifier;
    private var context:AudioContext;

    public function new(context:AudioContext, parameters:SoundParameters) {
        this.context = context;
        this.oscillatorOne = new Oscillator(context, parameters.oscillatorOne, parameters.time);
        this.oscillatorTwo = new Oscillator(context, parameters.oscillatorTwo, parameters.time);
        this.filter = new Filter(context, parameters.filter, parameters.time);
        this.amplifier = new Amplifier(context, parameters.amplifier, parameters.time);

        this.oscillatorOne.getNode().connect(this.filter.getNode());
        this.oscillatorTwo.getNode().connect(this.filter.getNode());
        this.filter.getNode().connect(this.amplifier.getNode());
        this.amplifier.getNode().connect(context.destination);
    }

    public function isEnded() {
        return !this.oscillatorOne.isPlaying && !this.oscillatorTwo.isPlaying;
    }

    public function dispose() {
        this.amplifier.getNode().disconnect(this.context.destination);
        this.filter.getNode().disconnect(this.amplifier.getNode());
        this.oscillatorTwo.getNode().disconnect(this.filter.getNode());
        this.oscillatorOne.getNode().disconnect(this.filter.getNode());
    }
}

class Audio {
    private var context:AudioContext = new AudioContext();
    private var soundMap:Map<String, Sound> = new Map<String, Sound>();

    public function new() {}

    public function playSound(parameters:SoundParameters) {
        if (soundMap.exists(parameters.name)) {
            Debug.log('Sound ${parameters.name} is already playing.');
        } else {
            soundMap.set(parameters.name, new Sound(context, parameters));
        }
    }

    public function update() {
        for (soundEntry in this.soundMap.keyValueIterator()) {
            if (soundEntry.value.isEnded()) {
                soundEntry.value.dispose();
                soundMap.remove(soundEntry.key);
            }
        }
    }

    public function dispose() {
        for (soundEntry in this.soundMap.keyValueIterator()) {
            soundEntry.value.dispose();
        }

        soundMap.clear();
        this.context.close();
    }
}