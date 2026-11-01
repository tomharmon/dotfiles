{ pkgs }:
let
  module = import ../home/common.nix {
    inherit pkgs;
    lib = pkgs.lib // {
      hm.dag.entryAfter = after: data: { inherit after data; };
    };
  };
  activation = module.home.activation.herdrPlugins;
  herdr = pkgs.writeShellScript "mock-herdr" ''
    case "$*" in
      'plugin list --json') printf '%s\n' "$plugins" ;;
      'plugin install --yes '*)
        if [ "$4" = persiyanov/herdr-reviewr ]; then
          test "$(command -v awk)" = ${pkgs.gawk}/bin/awk || exit 1
        fi
        printf '%s\n' "$4" >> "$calls"
        ;;
      *) exit 1 ;;
    esac
  '';
  script = pkgs.writeText "herdr-activation.sh" (builtins.replaceStrings
    [ "${pkgs.herdr}/bin/herdr" ] [ "${herdr}" ] activation.data);
in
assert activation.after == [ "writeBoundary" ];
pkgs.runCommand "dotfiles-herdr-plugins-check" { } ''
  run() { "$@"; }
  export calls="$TMPDIR/installs"
  export plugins='{"result":{"plugins":[]}}'
  : > "$calls"
  source ${script}
  test "$(cat "$calls")" = "$(printf '%s\n' persiyanov/herdr-reviewr rjyo/herdr-window-title-sync)"

  export plugins='{"result":{"plugins":[{"plugin_id":"persiyanov.reviewr"}]}}'
  : > "$calls"
  source ${script}
  test "$(cat "$calls")" = rjyo/herdr-window-title-sync

  export plugins='{"result":{"plugins":[{"plugin_id":"rjyo.window-title-sync"}]}}'
  : > "$calls"
  source ${script}
  test "$(cat "$calls")" = persiyanov/herdr-reviewr

  export plugins='{"result":{"plugins":[{"plugin_id":"persiyanov.reviewr"},{"plugin_id":"rjyo.window-title-sync"}]}}'
  : > "$calls"
  source ${script}
  test ! -s "$calls"
  touch "$out"
''
