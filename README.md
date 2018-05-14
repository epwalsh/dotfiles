# Practical dotfiles for (neo)vim OS X hackers

### iTerm2 + tmux + neovim

This configuration supports two themes, Light and Dark. Here is the Light theme in action:

![demo](images/demo2.gif)

And here is the Dark theme:

![dark](images/screen_shot_dark.png)


## Setup

To bootstrap this configuration, just enter the following in your terminal:

```bash
git clone https://github.com/epwalsh/dotfiles.git && cd dotfiles && source bootstrap.sh
```

Runtime: about 30 minutes to an hour if you install everything (recommended), depending on your internet speed.

### iTerm2

I recommend using iTerm2 instead of the default Terminal app. You can download iTerm2 here:
[https://www.iterm2.com/downloads.html](https://www.iterm2.com/downloads.html).

iTerm2 comes with two default themes that work well this setup: Solarized Light and Tango Dark.

#### Configuring iTerm2 themes

You will need to set the theme manually once you install iTerm2 by going to Preferences > Profiles and 
then creating two profiles by doing the following: 

- Click the "+" in the lower left corner and then type "Light" into
the "Name" field under the "General" tab. 
- Then click the "Colors" tab, then "Color Presets" and choose "Solarized Light".
- Finally, click on the "Text" tab and then "Change Font". Then choose "DejaVu Sans Mono for Powerline".
- Now repeat the above three steps for a new theme called "Dark" with the color preset "Tango Dark".

The Neovim colorscheme will automatically adjust itself to match the iTerm2 theme by looking for the environment variable `ITERM_PROFILE`, which will correspond to the name of the current profile running (either "Light" or "Dark").
