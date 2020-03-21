package game;

import js.html.audio.AudioContextState;
import js.html.audio.OscillatorType;
import js.html.audio.OscillatorNode;
import js.html.audio.AudioContext;

class Audio {
    private var context:AudioContext;
    private var oscillator:OscillatorNode;
    private var isPlaying:Bool = false;

    public function new() {}

    public function initialize() {
        this.context = new AudioContext();
        this.oscillator = this.context.createOscillator();
        this.oscillator.type = OscillatorType.SINE;
        this.oscillator.frequency.value = Config.GLOW_LIGHT_MIN_FREQUENCY;
        this.oscillator.start();
    }

    public function play() {
        if (!this.isPlaying) {
            this.oscillator.connect(this.context.destination);
            this.isPlaying = true;
        }
    }

    public function setValue(value:Float) {
        this.oscillator.frequency.value = value;
    }

    public function stop() {
        if (this.isPlaying) {
            this.oscillator.disconnect(this.context.destination);
            this.isPlaying = false;
        }
    }

    public function dispose() {
        if (this.isPlaying) {
            this.oscillator.disconnect(this.context.destination);
        }
        this.isPlaying = false;
        this.oscillator = null;
        this.context.close();
    }
}