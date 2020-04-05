package engine;

class Promise<T> {
    private var thenAction:(T)->Void;

    private var isResolved:Bool;
    private var resolvedResult:T;

    public function new() {
        this.thenAction = function(result:T) {};
        this.isResolved = false;
    }

    public function then(action:(T)->Void):Promise<T> {
        this.thenAction = action;

        if(this.isResolved) {
            this.thenAction(this.resolvedResult);
        }

        return this;
    }

    public function resolve(result:T):Promise<T> {
        this.thenAction(result);
        
        this.isResolved = true;
        this.resolvedResult = result;

        return this;
    }
}