package game;

import engine.Vec2;
import js.html.audio.BiquadFilterType;
import js.html.audio.BiquadFilterNode;
import js.html.audio.GainNode;
import js.html.audio.AudioContextState;
import js.html.audio.OscillatorType;
import js.html.audio.OscillatorNode;
import js.html.audio.AudioContext;

class Audio {
    private var context:AudioContext;

    public var osc_1:OscillatorNode;
    public var osc_1_is_playing:Bool = false;

    public var osc_2:OscillatorNode;
    public var osc_2_is_playing:Bool = false;

    public var vcf:BiquadFilterNode;
    public var vcf_lfo:OscillatorNode;
    public var vcf_lfo_amp:GainNode;
    public var vcf_env_a:Vec2 = new Vec2();
    public var vcf_env_d:Vec2 = new Vec2();
    public var vcf_env_s:Vec2 = new Vec2();
    public var vcf_is_lfo:Bool = true;

    public var vca:GainNode;
    public var vca_lfo:OscillatorNode;
    public var vca_lfo_amp:GainNode;
    public var vca_env_a:Vec2 = new Vec2();
    public var vca_env_d:Vec2 = new Vec2();
    public var vca_env_s:Vec2 = new Vec2();
    public var vca_is_lfo:Bool = false;

    public function new() {}

    public function initialize() {
        this.context = new AudioContext();

        this.vcf = this.context.createBiquadFilter();
        this.vcf.type = BiquadFilterType.LOWPASS;
        this.vcf.frequency.value = 400;
        this.vcf_lfo = this.context.createOscillator();
        this.vcf_lfo.frequency.value = 40;
        this.vcf_lfo_amp = this.context.createGain();
        this.vcf_lfo_amp.gain.value = 400;
        this.vcf_lfo.start();

        this.vca = this.context.createGain();
        this.vca.gain.value = 1;
        this.vca_lfo = this.context.createOscillator();
        this.vca_lfo.frequency.value = 40;
        this.vca_lfo_amp = this.context.createGain();
        this.vca_lfo_amp.gain.value = 1;
        this.vca_lfo.start();

        this.vcf_lfo.connect(this.vcf_lfo_amp);
        this.vca_lfo.connect(this.vca_lfo_amp);
        this.vcf.connect(this.vca).connect(context.destination);
    }

    public function play() {
        if (osc_1_is_playing || osc_2_is_playing) {
            return;
        }

        if (this.osc_1 != null) {
            this.osc_1.disconnect(this.vcf);
            this.osc_1 = null;
        }
        this.osc_1 = this.context.createOscillator();
        this.osc_1.type = OscillatorType.SAWTOOTH;
        this.osc_1.frequency.value = 120;
        this.osc_1.connect(this.vcf);

        if (this.osc_2 != null) {
            this.osc_2.disconnect(this.vcf);
            this.osc_2 = null;
        }
        this.osc_2 = this.context.createOscillator();
        this.osc_2.type = OscillatorType.SAWTOOTH;
        this.osc_2.frequency.value = 121;
        this.osc_2.connect(this.vcf);

        this.vcf_lfo_amp.connect(this.vcf.frequency);
        if (this.vcf_is_lfo) {
        } else {
            this.vcf_lfo_amp.disconnect(this.vcf.frequency);
        }

        this.vca_lfo_amp.connect(this.vca.gain);
        if (this.vca_is_lfo) {
        } else {
            this.vca_lfo_amp.disconnect(this.vca.gain);
        }

        var time:Float = 0.5;

        this.osc_1_is_playing = true;
        this.osc_1.start();
        this.osc_1.stop(context.currentTime + time);
        this.osc_1.onended = ()->{
            this.osc_1_is_playing = false;
        };

        this.osc_2_is_playing = true;
        this.osc_2.start();
        this.osc_2.stop(context.currentTime + time);
        this.osc_2.onended = ()->{
            this.osc_2_is_playing = false;
        };
    }
}