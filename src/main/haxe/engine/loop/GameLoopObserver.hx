package engine.loop;

interface GameLoopObserver {
    function update(timestamp:Float):Void;
}