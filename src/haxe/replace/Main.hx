package replace;

import sys.io.File;
import haxe.Http;

using StringTools;

class Main {
    static function main() {
        File.saveContent('bin/index.html', File.getContent('bin/index.html').replace(
        '<script type="text/javascript" src="glow.js"></script>',
        '<script type="text/javascript">${File.getContent('bin/glow.min.js')}</script>'));
    }
}