{
  pkgs,
  config,
  lib,
  ...
}:
with builtins;
with lib;
{
  options.myhome.fish = {
    enable = mkOption {
      description = "enable fish";
      type = lib.types.bool;
      default = true;
    };
  };

  config = mkIf config.myhome.fish.enable {
    # home.packages = [ pkgs.fish ];

    stylix.targets.fish.enable = false;

    programs.fish = {
      enable = true;
      functions = {
        fish_prompt = ''
          if fish_is_root_user
              set div ""
          else 
              set div ""
          end
          set_color -b green; set_color -o black; 
          echo (date "+%H:%M:%S")(set_color -b cyan; set_color -o green)$div(set_color normal; set_color -o black; set_color -b cyan) (prompt_pwd)(set_color -b magenta; set_color cyan)$div(set_color normal ; set_color -o black; set_color -b magenta) (echo $CMD_DURATION)ms(set_color normal; set_color -o black; set_color magenta)$div(set_color normal)" "
        '';

        fish_greeting = ''
          fastfetch
          cal
        '';

        fish_title = ''
          prompt_pwd
          date "+  Time: %H:%M:%S"
        '';

        fish_default_mode_prompt = ''
          echo ""
        '';
      };

      shellInit = ''
        fish_add_path ~/.bin/ ~/.local/bin/ ~/.pack/bin/
        zoxide init fish | source
      '';

      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../../";
        c = "clear";
        ll = "ls -FGghot";
        la = "ls -FGghotA";
        h = "ghc";
        hi = "ghci";
        se = "stack run";
      };
    };
  };
}
