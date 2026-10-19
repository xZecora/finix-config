{ pkgs, ... }:
{
  hjem.users.vitrial = {
    packages = with pkgs; [ any-nix-shell ];
    rum.programs = {
      direnv = {
        enable = true;
        integrations.nushell.enable = true;
        integrations.nix-direnv.enable = true;
      };

      zoxide = {
        enable = true;
        integrations.nushell.enable = true;
      };

      nushell = {
        enable = true;

        settings = {
          show_banner = false;
          buffer_editor = "vim";
        };

        aliases = {
          rat = "startx ~/.config/Xinitrc ratpoison"; # I don't wanna type all this to start my x server, I normally have more wm's
          ":q" = "exit"; # sometimes I do this from vim habit so might as well make it work

          ls = "eza -la --icons --color=auto"; # eza gang
          cat = "bat";

          poweroff = "doas poweroff";
          reboot = "doas reboot";
          cd = "z";

          lsblk = "lsblk | bat -l conf -p";

          tags = "ctags --recurse=yes --exclude=.git --exclude=build --exclude=.cache --exclude=.ccls-cache";
        };

        extraConfig = ''
          # Cribbed from https://github.com/nushell/nu_scripts/blob/main/modules/prompt/oh-my.nu
          # Abbreviate home path
          def home_abbrev [] {
            let is_home_in_path = ($env.PWD | str starts-with $nu.home-dir)
            if $is_home_in_path {
                basename ($env.PWD | str replace $nu.home-dir '~')
            } else {
                basename $env.PWD
            }
          }

          # Cribbed from
          # https://github.com/nushell/nushell/issues/9095#issuecomment-2230987214
          # with get_current_ref improvement stolen from
          # https://github.com/nushell/nu_scripts/blob/main/modules/prompt/panache-git.nu

          def create_left_prompt [] {
              let path_segment = if (is-admin) {
                  $"(ansi blue)(home_abbrev)"
              } else {
                  $"(ansi blue)(home_abbrev)"
              }

              let git_current_ref = (git rev-parse --abbrev-ref HEAD)
              let git_segment = if ($git_current_ref != "") {
                  $" \(($git_current_ref)" 
              }

              let git_closer = if ($git_current_ref != "") {
                  if ((git status -s) != "") {
                      $"*\)"
                  } else {
                      "\)"
                  }
              }

              let prompt = ($"(ansi red)[(ansi cyan)($env.USER)(ansi yellow)@(ansi green)((sys host).name) ($path_segment)(ansi magenta_bold)($git_segment)($git_closer)(ansi red)]" | str trim)
              $prompt
          }

          $env.PROMPT_COMMAND = {||create_left_prompt}
          $env.PROMPT_COMMAND_RIGHT = {||}
        '';

        plugins = with pkgs.nushellPlugins; [
        ];
      };
    };
  };
}
