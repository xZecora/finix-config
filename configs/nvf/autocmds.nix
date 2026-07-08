{
  programs.nvf = {
    settings.vim = {
      autocmds = [
        {
          enable = true;
          event = ["VimEnter"];
          pattern = ["*.*"];
          once = false;
          command = ":vunmap ii";
        }
        {
          enable = true;
          event = ["VimEnter"];
          pattern = ["*.*"];
          once = false;
          command = ":ounmap ii";
        }
        {
          enable = true;
          event = ["FileType"];
          pattern = [
            "markdown"
            "sagafinder"
            "TelescopePrompt"
            "nix"
          ];
          command = ":set nofoldenable";
        }
        {
          enable = true;
          event = ["FileType"];
          pattern = [
            "zig"
          ];
          command = ":set shiftwidth=2 tabstop=2";
        }
        {
          enable = true;
          event = ["FileType"];
          pattern = [
            "oil"
          ];
          command = ":setlocal relativenumber! number!";
        }
        {
          enable = true;
          event = ["FileType"];
          pattern = [
            "oil"
          ];
          command = ":highlight OilFloat guibg=#303030";
        }
      ];
    };
  };
}
