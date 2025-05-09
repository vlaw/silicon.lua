# silicon.lua

**silicon** is a lua plugin for neovim to generate beautiful images of code snippet using [silicon](https://github.com/aloxaf/silicon)

<video src = "https://user-images.githubusercontent.com/79555780/198016165-7a47ac6c-e329-4025-8d66-f9b34bd52658.mp4"></video>

## ✨ Features

- **beautiful** images of source code, saved to preferred place.
- **copy** to clipboard

## ⚡️ Requirements

- Neovim >= 0.6.0
- [silicon](https://github.com/aloxaf/silicon)

## 📦 Installation

Install the plugin with your preferred package manager:

### [packer](https://github.com/wbthomason/packer.nvim)

```lua
-- Lua
use {
  "narutoxy/silicon.lua",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    require('silicon').setup({})
  end
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
" Vim Script
Plug 'nvim-lua/plenary.nvim'
Plug 'narutoxy/silicon.lua'

lua require('silicon').setup({})
```

## ⚙️ Configuration

silicon comes with the following defaults:

```lua
{
  theme = nil, -- silicon's default theme is Dracula
  output = "SILICON_${year}-${month}-${date}_${time}.png", -- auto generate file name based on time (absolute or relative to cwd)
  gobble = false, -- enable lsautogobble like feature
  debug = false, -- enable debug output
  silicon_args = nil, -- pass additional arguments to silicon
}
```

## 🚀 Usage

### Keymaps

```lua
-- Generate image of lines in a visual selection
vim.keymap.set('v', '<Leader>s',  function() silicon.visualise_api({}) end )
-- Generate image of a whole buffer, with lines in a visual selection highlighted
vim.keymap.set('v', '<Leader>bs', function() silicon.visualise_api({to_clip = true, show_buf = true}) end )
-- Generate visible portion of a buffer
vim.keymap.set('n', '<Leader>s',  function() silicon.visualise_api({to_clip = true, visible = true}) end )
-- Generate current buffer line in normal mode
vim.keymap.set('n', '<Leader>s',  function() silicon.visualise_api({to_clip = true}) end )
```

### Command line

Calling `silicon.visualise_api` with `lua` in command line doesn't work due to `lua` not supporting ranges.
This means that the moment you hit enter, you leave visual mode before lua function is called. While this populates two registers, using them doesn't work with "v" mode maps.
A workaround has been implemented, and a shorthand that forces it is available as `.visualise_cmdline`:

- Generate image of lines in a visual selection

  ```lua
  lua require('silicon').visualise_cmdline({})
  ```

- Generate image of a whole buffer, with lines in a visual selection highlighted

  ```lua
  lua require('silicon').visualise_cmdline({to_clip = true, show_buf = true})
  ```

- Generate visible portion of a buffer

  ```lua
  lua require('silicon').visualise_cmdline({to_clip = true, visible = true})
  ```

## Notes

- The default path of image is the current working directory of the editor, but you can change it by

  ```lua
  require("silicon").setup({
          output = "/home/astro/Pictures/SILICON_$year-$month-$date-$time.png"),
  })
  ```
