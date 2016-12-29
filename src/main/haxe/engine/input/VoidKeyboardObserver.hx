package engine.input;

class VoidKeyboardObserver implements KeyboardObserver {
    public function new() {
        //do nothing, hence the name void
    }

    public function onInput(state: KeyboardState): Void {
        //do nothing, hence the name void
    }
}