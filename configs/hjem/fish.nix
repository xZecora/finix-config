{
  pkgs,
  config,
  lib,
  ...
}:
let
  packageToPlugin = pkg: pkg.src;
in
{
  hjem.users.vitrial = {
    packages = with pkgs; [ any-nix-shell ];
    rum.programs = {
      direnv = {
        enable = true;
        integrations.fish.enable = true;
        integrations.nix-direnv.enable = true;
      };

      fish = {
        enable = true;
        # generateCompletions = true;

        config = ''
          set -U fish_greeting # Disable greeting
          any-nix-shell fish --info-right | source
          fish_vi_key_bindings
          set -Ux fifc_editor nvim
          set -gx FZF_DEFAULT_OPTS "--bind tab:down,shift-tab:up,space:toggle"
        '';

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

        earlyConfigFiles = {
          set_path = "fish_add_path ~/.local/bin";
        };

        plugins = with pkgs.fishPlugins; {
          async-prompt = packageToPlugin async-prompt;
          sponge = packageToPlugin sponge;
          fishbang = packageToPlugin fishbang;
          fifc = packageToPlugin fifc;
          fish-you-should-use = packageToPlugin fish-you-should-use;
          fish-bd = packageToPlugin fish-bd;
          pisces = packageToPlugin pisces;
        };

        functions = {
          fish_user_key_bindings = ''
            bind -m normal --erase --all
            bind -m visual --erase --all

            bind -m insert u repaint-mode
            bind -M visual -m insert u end-selection repaint-mode

            bind -m insert U beginning-of-line repaint-mode
            bind -M visual -m insert U end-selection beginning-of-line repaint-mode

            bind -m insert a 'set fish_cursor_end_mode exclusive' forward-single-char repaint-mode
            bind -m insert A 'set fish_cursor_end_mode exclusive' end-of-line repaint-mode

            bind n 'fish_vi_run_count backward-char'
            bind -M operator n 'fish_vi_exec_motion backward-char'
            bind -M visual n backward-char

            bind e 'fish_vi_run_count down-or-search'
            bind -M operator e 'fish_vi_exec_motion down-line'
            bind -M visual e down-line
            bind E end-of-line delete-char

            bind i 'fish_vi_run_count up-or-search'
            bind -M operator i 'fish_vi_exec_motion up-line'
            bind -M visual i up-line
            bind I 'man (commandline -t) 2>/dev/null; or echo -n\\a'

            bind o 'fish_vi_run_count forward-char'
            bind -M operator o 'fish_vi_exec_motion forward-char'
            bind -M visual o forward-char

            bind -m insert l 'set fish_cursor_end_mode exclusive' insert-line-under repaint-mode
            bind -M visual l swap-selection-start-stop repaint-mode

            bind -m insert L 'set fish_cursor_end_mode exclusive' insert-line-over repaint-mode

            bind y 'fish_vi_start_operator yank'
            bind -M operator y 'fish_vi_exec_motion --linewise'
            bind -M visual -m default y fish_vi_yank_selection end-selection repaint-mode

            bind 0 'if test -n "$__fish_vi_count"; fish_vi_arg_digit 0; else; commandline -f beginning-of-line; end'
            bind -M operator 0 'fish_vi_exec_motion beginning-of-line'
            bind -M visual 0 beginning-of-line

            bind d 'fish_vi_start_operator delete'
            bind -M operator d 'fish_vi_exec_motion --linewise'
            bind -M visual -m default d kill-selection end-selection backward-char repaint-mode

            bind D kill-line

            bind x __fish_vi_delete_char
            bind -M visual -m default x kill-selection end-selection repaint-mode

            bind X __fish_vi_backward_delete_char
            bind -M visual -m default X kill-whole-line end-selection repaint-mode

            bind p 'set -g fish_cursor_end_mode exclusive' forward-char 'set -g fish_cursor_end_mode inclusive' yank

            bind k undo
            bind ctrl-r redo

            bind \[ history-token-search-backward
            bind \] history-token-search-forward

            bind -m insert / histor-pager repaint-mode

            bind g,g beginning-of-buffer
            bind G end-of-buffer

            bind \~ togglecase-char forward-single-char
            bind -M operator \~ 'fish_vi_exec_motion --linewise'
            bind -M visual -m default \~ togglecase-selection end-selection repaint-mode

            bind g,u downcase-word
            bind -M visual -m default g,u downcase-selection end-selection repaint-mode

            bind g,U upcase-word
            bind -M visual -m default g,U upcase-selection end-selection repaint-mode

            bind :,q exit

            bind backspace backward-char
            bind -M replace backspace backward-char

            bind f 'fish_vi_run_count forward-word-vi'
            bind -M operator f 'fish_vi_exec_motion forward-word-vi'
            bind -M visual w forward-word-vi

            bind F 'fish_vi_run_count forward-bigword-vi'
            bind -M operator F 'fish_vi_exec_motion forward-bigword-vi'
            bind -M visual w forward-bigword-vi

            bind b 'fish_vi_run_count backward-word'
            bind -M operator b 'fish_vi_exec_motion backward-word'
            bind -M visual b backward-word

            bind B 'fish_vi_run_count backward-bigword-vi'
            bind -M operator B 'fish_vi_exec_motion backward-bigword-vi'
            bind -M visual B backward-bigword-vi

            bind -M visual -m default \",\*,y 'fish_clipboard_copy; commandline -f end-selection repaint-mode'

            bind -M insert tab _fifc
            bind -M normal tab _fifc

            for pair in $pisces_pairs
              _pisces_bind_pair insert (string split -- ',' $pair)
            end

            bind -M insert backspace _pisces_backspace
          '';

          fish_prompt = ''
            set BRACKET_COLOR "red"
            set USER_COLOR "cyan"
            set HOST_COLOR "green"
            set PATH_COLOR "blue"
            # gets the error status of the last command and 
            # updates the @ symbol color with the indication
            if test "$status" -ne "0"
              set ARROW "red"
            else
              set ARROW "yellow"
            end

            set HOST_STRING (echo $hostname | cut -f1 -d".")

            echo (set_color $BRACKET_COLOR)"["(set_color $USER_COLOR)(whoami)(set_color $ARROW)@(set_color $HOST_COLOR)(echo $HOST_STRING) (set_color $PATH_COLOR)(pretty_path)(get_branch)(set_color $BRACKET_COLOR)"]"(set_color $ARROW)"|=>> "(set_color "white")
          '';

          get_branch = ''
            set GIT_COLOR "purple"
            # minus symbol if there are no changes detected to tracked files
            # /dev/null prevents nonsensical errors when you are on directories not tracked by git.
            if test (git status --untracked-files=no --porcelain 2> /dev/null | wc -l) -eq 0
              set indicator ""
            else
              set indicator "*"
            end

            set branch_name (git rev-parse --abbrev-ref HEAD 2> /dev/null)
            if test "$branch_name" != ""
              echo (set_color -o $GIT_COLOR)" ($branch_name$indicator)"(set_color --reset)
            else
              echo ""
            end
          '';

          pretty_path = ''
            # by default, Fish shell does not print ~ for $HOME
            echo (pwd | ${lib.getExe' config.programs.coreutils.package "sed"} "s|^$HOME|~|g" | path basename)
          '';

          fish_mode_prompt = "";
        };
      };

      zoxide = {
        enable = true;
        integrations.fish.enable = true;
      };
    };
  };
}
