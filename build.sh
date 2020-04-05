if [ -z "$1" ]; then
  configuration="debug"
else
  configuration="$1"
fi

mkdir -p bin
rm -rf bin/*
cp src/html/game/index.html bin/index.html
cp src/html/synth/synth.html bin/synth.html

if [ "$configuration" == "debug" ]; then
    haxe -debug build.hxml
else
    haxe build.hxml
    cd bin
    curl -X POST -s --data-urlencode 'input@glow.js' https://javascript-minifier.com/raw > glow.min.js
    cd ..
    neko replace.n
    cp bin/index.html index.html
fi