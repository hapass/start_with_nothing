package lang;

class Promise<T> {
    private var thenAction:T->Void;

    public function new() {
        this.thenAction = function(result:T) {};
    }

    public function then(action:T->Void):Void {
        this.thenAction = action;
    }

    public function resolve(result:T):Void {
        this.thenAction(result);
    }
}