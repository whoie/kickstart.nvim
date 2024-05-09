-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- zig language plugin
  { 'ziglang/zig.vim' },

  -- change the working directory to the project root for an open file
  { 'airblade/vim-rooter' },

  -- file explorer with buffer-style editing
  {
    'stevearc/oil.nvim',
    opts = {
      view_options = {
        -- show files and directories that start with '.'
        show_hidden = true,
        -- define what is hidden
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, '.')
        end,
        -- define what is not hidden
        is_alwasy_hidden = function(name, bufnr)
          return false
        end,
      },
    },
  },

  -- modify telescope picker options on the fly
  {
    'molecule-man/telescope-menufacture',
    config = function()
      local menufacture = require('telescope').extensions.menufacture

      -- replace these telescope mappings to use the menufacture replacements
      vim.keymap.set('n', '<leader>sf', menufacture.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sg', menufacture.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sw', menufacture.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>gf', menufacture.git_files, { desc = '[G]it ls-[F]iles' })
    end,
  },

  -- harpoon the terminals/buffers/files/etc. I'm looking for
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup {}

      -- basic telescope configuration
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader>gh', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })
      vim.keymap.set('n', '<leader>gp', function()
        harpoon:list():prev()
      end, { desc = '[G]o to [P]revious harpoon mark' })
      vim.keymap.set('n', '<leader>gn', function()
        harpoon:list():next()
      end, { desc = '[G]o to [N]ext harpoon mark' })
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = '[A]dd file to harpoon list' })
    end,
  },
}
