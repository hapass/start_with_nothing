package replace;

import sys.io.File;

using StringTools;

class Main {
  static function main() {
      var index = File.getContent('bin/index.html');
      var script = File.getContent('bin/glow.js');
      File.saveContent('bin/index.html', index.replace(
        '<script type="text/javascript" src="glow.js"></script>',
        '<script type="text/javascript">$script</script>'));
  }
}