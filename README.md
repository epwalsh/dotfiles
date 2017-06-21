# Practical dotfiles for (neo)vim OS X hackers

### iTerm2 + tmux + neovim

Tested on Mac OS X Sierra (10.12.5).

![demo](images/demo2.gif)


## Setup

To bootstrap this configuration, just enter the following in your terminal:

```bash
git clone https://github.com/epwalsh/dotfiles.git && cd dotfiles && source bootstrap.sh
```

Runtime: about 10 minutes if you install everything.

### iTerm2

I recommend using iTerm2 instead of the default Terminal app. You can download iTerm2 here:
[https://www.iterm2.com/downloads.html](https://www.iterm2.com/downloads.html).

iTerm2 comes with two default themes that work well this setup: Solarized Light and Tango Dark.

#### Configuring iTerm2 themes

You will need to set the theme manually once you install iTerm2 by going to Preferences > Profiles and 
then creating two profiles. Do this by clicking the "+" in the lower left corner and then typing "Light" into
the "Name" field under the "General" tab. Then click the "Colors" tab, then "Color Presets" and choose "Solarized Light".
Then click on the "Text" tab and then "Change Font". The choose "DejaVu Sans Mono for Powerline".
Now repeat this process for a new theme called "Dark" with the color preset "Tango Dark".

The Neovim colorscheme will adjust itself to match the iTerm2 theme.

### Personalizing neovim headers

To personalize headers, make edits to the file `neovim/modules/plugins/NvimAutoheader.vim` and the files in
`neovim/headers/`. See [github.com/epwalsh/NvimAutoheader](https://github.com/epwalsh/NvimAutoheader) for more
information about custom headers.
