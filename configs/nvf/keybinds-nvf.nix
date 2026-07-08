{
  programs.nvf = {
    settings.vim = {
      globals.mapleader = " ";

      keymaps = [
        {
          key = "<leader>y";
          mode = "n";
          silent = true;
          action = ":set relativenumber! number!<CR>";
        }
        {
          key = "<leader>o";
          mode = "n";
          silent = true;
          action = ":bnext<CR>";
        }
        {
          key = "<leader>n";
          mode = "n";
          silent = true;
          action = ":bprev<CR>";
        }
        {
          key = "O";
          mode = "n";
          silent = true;
          action = ":bnext<CR>";
        }
        {
          key = "N";
          mode = "n";
          silent = true;
          action = ":bprev<CR>";
        }
        {
          key = "<leader>tt";
          mode = "n";
          silent = true;
          # action = ":lua MiniFiles.open()<CR>";
          action = ":Oil --float<CR>";
        }
        {
          key = "<leader>w";
          mode = "n";
          silent = true;
          action = "<C-w>";
        }
        {
          key = "n";
          mode = "";
          noremap = true;
          silent = true;
          action = "h";
        }
        {
          key = "e";
          mode = "";
          noremap = true;
          silent = true;
          action = "j";
        }
        {
          key = "l";
          mode = "";
          noremap = true;
          silent = true;
          action = "o";
        }
        {
          key = "<A-l>";
          mode = "";
          noremap = true;
          silent = true;
          action = "mpo<Esc>`p:delm p<cr>";
        }
        {
          key = "L";
          mode = "";
          noremap = true;
          silent = true;
          action = "O";
        }
        {
          key = "<A-L>";
          mode = "";
          noremap = true;
          silent = true;
          action = "mpO<Esc>`p:delm p<cr>";
        }
        {
          key = "U";
          mode = "";
          noremap = true;
          silent = true;
          action = "I";
        }
        {
          key = "u";
          mode = "";
          noremap = true;
          silent = true;
          action = "i";
        }
        {
          key = "un";
          mode = "o";
          noremap = true;
          action = "in";
        }
        {
          key = "ui";
          mode = "o";
          noremap = true;
          action = "ii";
        }
        {
          key = "vu";
          mode = "o";
          silent = true;
          noremap = true;
          action = "vi";
        }
        {
          key = "vi";
          mode = "o";
          silent = true;
          noremap = true;
          action = "";
        }
        {
          key = "ii";
          mode = "";
          action = "<Nop>";
        }
        {
          key = "i";
          mode = [
            "v"
            "o"
            "n"
          ];
          noremap = true;
          nowait = true;
          silent = true;
          action = "k";
        }
        {
          key = "o";
          mode = "";
          noremap = true;
          silent = true;
          action = "l";
        }
        {
          key = "<C-e>";
          mode = "n";
          noremap = true;
          silent = true;
          action = "<C-d>";
        }
        {
          key = "<C-i>";
          mode = "n";
          noremap = true;
          silent = true;
          action = "<C-u>";
        }
        {
          key = "<A-e>";
          mode = "n";
          noremap = true;
          silent = true;
          action = ":m+<CR>";
        }
        {
          key = "<A-i>";
          mode = "n";
          noremap = true;
          silent = true;
          action = ":m-2<CR>";
        }
        {
          key = "h";
          mode = "n";
          noremap = true;
          silent = true;
          action = "n";
        }
        {
          key = "H";
          mode = "n";
          noremap = true;
          silent = true;
          action = "N";
        }
        {
          key = "k";
          mode = "n";
          noremap = true;
          silent = true;
          action = "u";
        }
        {
          key = "K";
          mode = "n";
          noremap = true;
          silent = true;
          action = "U";
        }
        {
          key = "t";
          mode = "n";
          noremap = true;
          silent = true;
          action = "e";
        }
        {
          key = "T";
          mode = "n";
          noremap = true;
          silent = true;
          action = "E";
        }
        {
          key = "ge";
          mode = "n";
          noremap = true;
          silent = true;
          action = "gj";
        }
        {
          key = "gt";
          mode = "n";
          noremap = true;
          silent = true;
          action = "ge";
        }
        {
          key = "gi";
          mode = "n";
          noremap = true;
          silent = true;
          action = "gk";
        }
        {
          key = "gk";
          mode = "n";
          noremap = true;
          silent = true;
          action = "gi";
        }
        {
          key = "<leader>xx";
          mode = "n";
          noremap = true;
          silent = true;
          action = "<cmd>Trouble diagnostics toggle<cr>";
        }
        {
          key = "<leader>q";
          mode = "n";
          silent = true;
          action = "<cmd>bdelete<cr>";
        }
        {
          key = "<leader>tf";
          mode = "n";
          silent = true;
          action = "<cmd>Lspsaga term_toggle<cr>";
        }
        {
          key = "<leader>dn";
          mode = "n";
          silent = true;
          action = "<cmd>Lspsaga diagnostic_jump_prev<cr>";
        }
        {
          key = "<leader>do";
          mode = "n";
          silent = true;
          action = "<cmd>Lspsaga diagnostic_jump_next<cr>";
        }
        {
          key = "<leader>dp";
          mode = "n";
          silent = true;
          action = "<cmd>Lspsaga finder<cr>";
        }
        {
          key = "<leader>do";
          mode = "n";
          silent = true;
          action = "<cmd>Lspsaga incoming_calls<cr>";
        }
        {
          key = "<leader>dO";
          mode = "n";
          silent = true;
          action = "<cmd>Lspsaga outgoing_calls<cr>";
        }
        {
          key = "<leader>dd";
          mode = "n";
          silent = true;
          action = "<cmd>Lspsaga hover_doc<cr>";
        }
        {
          key = "<leader>dD";
          mode = "n";
          silent = true;
          action = "<cmd>Lspsaga hover_doc ++keep<cr>";
        }
        {
          key = "<leader>df";
          mode = "n";
          silent = true;
          action = "<cmd>Lspsaga peek_definition<cr>";
        }
        {
          key = "<leader>ds";
          mode = "n";
          silent = true;
          action = "<cmd>Lspsaga outline<cr>";
        }
        {
          key = "<Esc><Esc>";
          mode = "t";
          silent = true;
          action = "<C-\\><C-n>";
        }
      ];
    };
  };
}
