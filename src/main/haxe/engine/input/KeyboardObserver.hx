package engine.input;

interface KeyboardObserver {
    public function onInput(state: KeyboardState): Void;
}