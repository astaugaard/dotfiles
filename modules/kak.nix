{
  pkgs,
  pkgs-unstable,
  config,
  lib,
  ...
}:
with builtins;
with lib;
{
  options.myhome.kak = {
    enable = mkOption {
      description = "enable kakoune";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.kak.enable {
    home.packages = with pkgs; [
      reasymotion
      kakoune-lsp
      lua
      fd
    ];

    programs.kakoune = {
      enable = true;
      defaultEditor = true;

      colorSchemePackage = pkgs.kakounePlugins.kakoune-catppuccin;

      config = {
        colorScheme = "catppuccin_macchiato";
        ui.assistant = "cat";
        scrollOff.lines = 4;
        tabStop = 4;
        autoReload = "yes";

        hooks = [
          {
            name = "BufWritePre";
            option = ".*";
            commands = ''
              try %{
                  format
              }'';
          }
          {
            name = "InsertChar";
            option = "\\t";
            commands = ''
              exec -draft h@
            '';
          }
          {
            name = "BufSetOption";
            option = "filetype=cpp,h";
            commands = ''
              set-option buffer formatcmd 'clang-format'
            '';
          }
          {
            name = "BufSetOption";
            option = "filetype=nix";
            commands = ''
              set-option buffer formatcmd 'nixfmt'
            '';
          }
          {
            name = "BufSetOption";
            option = "filetype=yaml";
            commands = ''
              map buffer user L "S^[^ ]*|[\d.]*\)<ret><a-k> <ret>c-<esc>ghi- <esc>gld," -docstring "add latest version" 
              map buffer user C ' op"zZs^ <ret>wd<esc>"zz L' -docstring "add latest version from clipboard" 
            '';
          }
          {
            name = "BufCreate";
            option = ".*[.]idr";
            commands = ''
              set-option buffer filetype 'idris'
            '';
          }
          {
            name = "BufSetOption";
            option = "filetype=idris";
            commands = ''
              hook buffer BufWritePost .* %{
                  lsp-semantic-tokens
              }

              hook buffer BufReload .* %{
                  lsp-semantic-tokens
              }

              map buffer user i ":enter-user-mode idris<ret>"
            '';
          }
          {
            name = "BufCreate";
            option = ".*[.]typ";
            commands = ''
              set-option buffer filetype 'typst'
            '';
          }
          {
            name = "BufSetOption";
            option = "filetype=haskell";
            commands = ''
              set-option buffer formatcmd 'fourmulo'
            '';
          }
          # no escape
          {
            name = "InsertChar";
            option = "\.";
            commands = ''
               try %{
              	exec -draft hH <a-k>,\.<ret> d
                    exec "<esc>:phantom-selection-clear<ret>"
               }
            '';
          }
          {
            name = "InsertCompletionShow";
            option = ".*";
            commands = ''
              try %{
                  # this command temporarily removes cursors preceded by whitespace;
                  # if there are no cursors left, it raises an error, does not
                  # continue to execute the mapping commands, and the error is eaten
                  # by the `try` command so no warning appears.
                  execute-keys -draft 'h<a-K>\h<ret>'
                  map window insert <tab> <c-n>
                  map window insert <s-tab> <c-p>
                  hook -once -always window InsertCompletionHide .* %{
                      unmap window insert <tab> <c-n>
                      unmap window insert <s-tab> <c-p>
                  }
              }
            '';
          }
          {
            name = "WinCreate";
            option = ".*";
            commands = ''add-highlighter window/number-lines number-lines'';
          }
        ];

        keyMappings = [
          {
            mode = "normal";
            key = "\\\'";
            effect = ":reasymotion-on-letter-to-word<ret>";
            docstring = "easymotion to word starting letter";
          }
          {
            mode = "normal";
            key = "\\\"";
            effect = ":reasymotion-on-letter-to-word-expand<ret>";
            docstring = "easymotion to word starting letter";
          }
          {
            mode = "user";
            key = "c";
            effect = ":comment-line<ret>";
            docstring = "comment line";
          }
          {
            mode = "user";
            key = "w";
            effect = ":write<ret>";
            docstring = "write file";
          }
          {
            mode = "user";
            key = "b";
            effect = ":change-buffer-selection<ret>";
            docstring = "change buffer";
          }
          {
            mode = "user";
            key = "l";
            effect = ":enter-user-mode lsp<ret>";
          }
          {
            mode = "user";
            key = "j";
            effect = ":reasymotion-line<ret>";
            docstring = "easymotion to a line";
          }
          {
            mode = "user";
            key = "J";
            effect = ":reasymotion-line-expand<ret>";
            docstring = "easymotion to a line";
          }
          {
            mode = "user";
            key = "o";
            effect = ":enter-user-mode open<ret>";
            docstring = "open";
          }
          {
            mode = "open";
            key = "r";
            effect = ":peneira-files<ret>";
            docstring = "open file recursive";
          }
          {
            mode = "open";
            key = "d";
            effect = ":doc ";
            docstring = "open doc";
          }
          {
            mode = "open";
            key = "M";
            effect = ":man ";
            docstring = "open manpage";
          }
          {
            mode = "open";
            key = "g";
            effect = ":prompt \"grep for> \" ''grep %val{text}''<ret>";
            docstring = "grep";
          }
          {
            mode = "open";
            key = "v";
            effect = ":tmux-terminal-horizontal kak -c %val{session}<ret>";
            docstring = "vertical split";
          }
          {
            mode = "open";
            key = "h";
            effect = ":tmux-terminal-vertical kak -c %val{session}<ret>";
            docstring = "horizontal split";
          }
          {
            mode = "open";
            key = "a";
            effect = ":alt<ret>";
            docstring = "open alt";
          }
          {
            mode = "open";
            key = "t";
            effect = ":suspend-and-resume fish<ret>";
            docstring = "open terminal";
          }
          {
            mode = "user";
            key = "v";
            effect = ":enter-user-mode git<ret>";
            docstring = "git";
          }
          {
            mode = "git";
            key = "a";
            effect = ":prompt \"add> \" ''git add \"%val{text}\"''<ret>";
            docstring = "add";
          }
          {
            mode = "git";
            key = "c";
            effect = ":prompt \"message> \" ''git commit -m \"%val{text}\"''<ret>";
            docstring = "commit";
          }
          {
            mode = "git";
            key = "i";
            effect = ":git init<ret>";
            docstring = "init";
          }
          {
            mode = "user";
            key = "t";
            effect = ":enter-user-mode toggle<ret>";
            docstring = "toggle";
          }
          {
            mode = "toggle";
            key = "w";
            effect = ":toggleOnWhite<ret>";
            docstring = "whitespace";
          }
          {
            mode = "user";
            key = "g";
            effect = ":enter-user-mode goplace<ret>";
            docstring = "goto";
          }
          {
            mode = "goplace";
            key = "s";
            effect = ":peneira-lines<ret>";
            docstring = "swiper";
          }
          {
            mode = "insert";
            key = "<c-s>";
            effect = "<a-;>:lsp-snippets-select-next-placeholders<ret>";
            docstring = "select next lsp snippet section";
          }
          {
            mode = "idris";
            key = "c";
            effect = ":lsp-code-actions -auto-single refactor.rewrite.CaseSplit<ret>";
          }
          {
            mode = "idris";
            key = "i";
            effect = ":lsp-code-actions -auto-single refactor.rewrite.Intro<ret>";
          }
          {
            mode = "idris";
            key = "w";
            effect = ":lsp-code-actions -auto-single refactor.rewrite.MakeWith<ret>";
          }
          {
            mode = "idris";
            key = "l";
            effect = ":lsp-code-actions -auto-single refactor.rewrite.MakeLemma<ret>";
          }
        ];
      };
      extraConfig = ''
        require-module luar

        require-module peneira-core

        require-module peneira

        eval %sh{kak-lsp --kakoune -s $kak_session}

        lsp-enable

        clipb-detect
        clipb-enable

        evaluate-commands %sh{
            rkak_easymotion load
        }

        face global REasymotionBackground rgb:aaaaaa
        face global REasymotionForeground "rgb:24273a,rgb:c6a0f6+F"

        def toggleOnWhite %{
            add-highlighter global/ show-whitespaces
            unmap global toggle w
            map global toggle w ":toggleOffWhite<ret>"
        }

        def toggleOffWhite %{
            remove-highlighter global/show-whitespaces
            unmap global toggle w
            map global toggle w ":toggleOnWhite<ret>"
        }

        def startTypstPreview -params 1 %{
            nop %sh{
              (kitty typst-live $1 &) >/dev/null 2>/dev/null
            }
        }

        def change-buffer-selection %{
            peneira 'buffers: ' %{ printf '%s\n' $kak_quoted_buflist } %{
                buffer %arg{1}
            }
        }

        def suspend-and-resume \
            -params 1..2 \
            -docstring 'suspend-and-resume <cli command> [<kak command after resume>]: backgrounds current kakoune client and runs specified cli command.  Upon exit of command the optional kak command is executed.' \
            %{ evaluate-commands %sh{

            # Note we are adding '&& fg' which resumes the kakoune client process after the cli command exits
            cli_cmd="$1 && fg"
            post_resume_cmd="$2"

            # automation is different platform to platform
            platform=$(uname -s)
            case $platform in
                Darwin)
                    automate_cmd="sleep 0.01; osascript -e 'tell application \"System Events\" to keystroke \"$cli_cmd\" & return '"
                    kill_cmd="/bin/kill"
                    break
                    ;;
                Linux)
                    automate_cmd="sleep 0.2; xdotool type '$cli_cmd'; xdotool key Return"
                    kill_cmd="/usr/bin/kill"
                    break
                    ;;
            esac

            # Uses platforms automation to schedule the typing of our cli command
            nohup sh -c "$automate_cmd"  > /dev/null 2>&1 &
            # Send kakoune client to the background
            $kill_cmd -SIGTSTP $kak_client_pid

            # ...At this point the kakoune client is paused until the " && fg " gets run in the $automate_cmd

            # Upon resume, run the kak command is specified
            if [ ! -z "$post_resume_cmd" ]; then
                echo "$post_resume_cmd"
            fi
            }}

        declare-option str bufferKey ""
      '';

      plugins = with pkgs; [
        luar
        peneira
        clipb
      ];
    };

    home.sessionVariables.EDITOR = "kak";
  };
}
