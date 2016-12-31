package engine.collisions;

class CollisionResolver {
    private var colliders: Map<String, Array<Collider>>;
    private var observers: Map<String, CollisionObserver>;
    private var keys: Array<String>;

    public function new() {
        this.colliders = new Map<String, Array<Collider>>();
        this.observers = new Map<String, CollisionObserver>();
        this.keys = new Array<String>();
    }

    public function addToCollisionGroup(groupName: String, collider: Collider, observer: CollisionObserver = null): Void {
        if(collider == null)
            return;

        var colliderGroupArray: Array<Collider> = [];
        if(this.colliders.exists(groupName)) {
            colliderGroupArray = this.colliders.get(groupName);
        }
        else {
            this.keys.push(groupName);
        }

        colliderGroupArray.push(collider);
        this.colliders.set(groupName, colliderGroupArray);
        
        if(observer != null)
            this.observers.set(groupName, observer);
    }

    public function resolve(): Void {
        doForEveryCombination(this.keys, function(i, j){
            var oneGroupName = this.keys[i];
            var otherGroupName = this.keys[j];

            var doGroupsIntersect = checkConditionForEachPair(this.colliders.get(oneGroupName), this.colliders.get(otherGroupName), function(oneObject, otherObject) {
                return oneObject.intersects(otherObject);
            });

            if(!doGroupsIntersect)
                return;

            if(this.observers.exists(oneGroupName))
                this.observers.get(oneGroupName).onCollision();

            if(this.observers.exists(otherGroupName))
                this.observers.get(otherGroupName).onCollision();
        });
    }

    private function checkConditionForEachPair<T>(oneArray: Array<T>, otherArray: Array<T>, handler: T -> T -> Bool): Bool {
        for(oneObject in oneArray) {
            for(otherObject in otherArray) {
                if(handler(oneObject, otherObject))
                    return true;
            }
        }

        return false;
    }

    private function doForEveryCombination<T>(array: Array<T>, handler: Int -> Int -> Void) {
        for(i in 0...array.length) {
            for(j in (i + 1)...array.length) {
                handler(i, j);
            }
        }
    }
}