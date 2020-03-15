if [ -z "$1" ]; then
  configuration="debug"
else
  configuration="$1"
fi

mkdir -p bin
cp layout/index.html bin/index.html

if [ "$configuration" == "debug" ]; then
    haxe build.hxml -debug
else
    haxe build.hxml
    neko replace.n
    cp bin/index.html index.html
fi