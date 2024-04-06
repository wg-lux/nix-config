{pkgs}:

pkgs.writeShellScriptBin "my-test-script" ''
#!/usr/bin/env bash
echo "hello world" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
''