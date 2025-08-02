{
  make_commands_script =
    {
      pkgs,
      options,
      name,
    }:
    with pkgs.lib;
    let
      cases = strings.concatStrings (
        attrsets.mapAttrsToList (
          { name, script }:
          ''
            "${name}")
              shift
              ${script}
              ;;
          ''
        ) options
      );

      default_prints = strings.concatStrings (
        pkgs.lib.attrsets.mapAttrsToList (
          { name, script }:
          ''
            echo "  name"
          ''
        ) options
      );
    in
    pkgs.writeShellScriptBin name ''
      case $1 in
        ${cases}
        *)
          echo "unknown command: $1"
          echo "valid commands: "
        ${default_prints}
      esac
    '';
}
