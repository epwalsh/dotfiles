# Practical dotfiles for (neo)vim OS X hackers

### iTerm2 + tmux + neovim

Tested on Mac OS X Sierra (10.12.5).

![demo](images/demo2.gif)


### Setup

I recommend using iTerm2 instead of the default Terminal app. You can download iTerm2 here:
[https://www.iterm2.com/downloads.html](https://www.iterm2.com/downloads.html).

iTerm2 comes with two default themes that work well this setup: Light and Dark.
You will need to set the theme manually once you install iTerm2 by going to Preferences > Appearance and 
then selecting the theme.

The Neovim colorscheme will adjust itself to match the iTerm2 theme.

After installing iTerm2, just run the following:

```bash
git clone https://github.com/epwalsh/dotfiles.git && cd dotfiles && source bootstrap.sh
```

To personalize headers, make edits to the file `neovim/modules/plugins/NvimAutoheader.vim` and the files in
`neovim/headers/`. See [github.com/epwalsh/NvimAutoheader](https://github.com/epwalsh/NvimAutoheader) for more
information about custom headers.
