# zsh settings
switch bash to zsh in your shell.

## install zsh via apt and chnage shell

```bash
sudo apt update
sudo apt install zsh
chsh -s $(which zsh)
```

## install zimfw
using [zim](https://zimfw.sh/#install) for my happy zsh life. 

Installation command and successful messages are:
```bash
$ curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

) Using Zsh version 5.9
) ZIM_HOME not set, using the default one.
) Zsh is your default shell.
! You seem to be already calling compinit in /etc/zsh/zshrc. Please remove it, because Zim's completion module will call compinit for you.
) Downloaded the Zim script to /home/<USERNAME>/.zim/zimfw.zsh
) Prepended Zim template to /home/<USERNAME>/.zimrc
) Prepended Zim template to /home/<USERNAME>/.zshrc
) Installed modules.
All done. Enjoy your Zsh IMproved! Restart your terminal for changes to take effect.
```

if you prefer to use `wget`, the alternative command is:
```bash
wget -nv -O - https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
```

After the installation, logout the current session and login again.

## customize zim
### install other packages via apt

```bash
sudo apt install bat fzf safe-rm
```

### install `eza` (fork from `exa`)
see the details from: [https://github.com/eza-community/eza/blob/main/INSTALL.md](https://github.com/eza-community/eza/blob/main/INSTALL.md)

make sure `gpg` command is available by executing `which gpg`. if not, install `gpg` first via `apt`.

Then instal eza via:

```bash
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza
```

### write `.zimrc`
add the following commands to the bottom of the `.zimrc`:

```bash
#
# Customized by yosakabe
#
zmodule git-info
zmodule prompt-pwd
zmodule pvenv
zmodule olets/zsh-abbr
# zmodule zsh-users/zsh-completions --fpath src
# zmodule zsh-users/zsh-syntax-highlighting
# zmodule zsh-users/zsh-history-substring-search
# zmodule zsh-users/zsh-autosuggestions

# themes
# zmodule bira
# zmodule eriner
# zmodule biratime
# zmodule sorin
```

then, 
```bash
zimfw install
```

after that, restart your terminal for changes to take effect.

## Customize `.zshrc`

add the following commands to the bottom of the `.zshrc`:

```bash
# ------------------------------
# Customized by yosakabe
# ------------------------------

# PROXY SETTING (if needed)
export http_proxy="http://<USERNAME>:<PASSWD>@<Proxy-address>:<Proxy-port>"
export https_proxy="http://<USERNAME>:<PASSWD>@<Proxy-address>:<Proxy-port>"
export all_proxy="http://<USERNAME>:<PASSWD>@<Proxy-address>:<Proxy-port>"

# enable Japanese
export LANG=ja_JP.UTF-8

# HISTORY SETTING
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000

# share .zshhistory
setopt inc_append_history
setopt share_history

# LS_COLORS
eval `dircolors -b`
eval `dircolors ${HOME}/.dircolors`

# remove file mark
unsetopt list_types

# ONCE IT LOADED, NEXT TIME YOU CAN COMMENT THEM OUT
abbr --force els="exa -1l"
abbr --force ela="exa -1la"
abbr --force ell="exa -1la --tree --icons --level=2"
abbr --force  ls="ls -GF"
abbr --force la="ls -laGF"
abbr --force ll="ls -lGF"
abbr --force gls="gls --color"


#
# PROMPT CUSTOMIZATION
#

# vim:et sts=2 sw=2 ft=zsh
typeset -g VIRTUAL_ENV_DISABLE_PROMPT=1
setopt nopromptbang prompt{cr,percent,sp,subst}
# Depends on git-info module to show git information
typeset -gA git_info
if (( ${+functions[git-info]} )); then
  zstyle ':zim:git-info:branch' format '%b'
  zstyle ':zim:git-info:commit' format '%c'
  zstyle ':zim:git-info:dirty' format '%F{red}●%F{yellow}'
  zstyle ':zim:git-info:keys' format \
      'prompt' ' %F{yellow}‹%b%c%D›'
  add-zsh-hook precmd git-info
fi

# _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
# _/_/_/ OLD-SCHOOL PROMPT SETTING _/_/_/
# _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

PROMPT='%F{cyan}${VIRTUAL_ENV:+(${VIRTUAL_ENV##*/})}[Lif@%n]%F{yellow}[%D %T]%F{green} %(!.#.$) %f'
RPROMPT='  %F{cyan}[%1~]'

#PROMPT='%F{cyan}[Lif@%n]%F{yellow}[%D %T]%F{green} %(!.#.$) %f'
#PROMPT='%F{cyan}[%m]%F{yellow}[%D %T]%F{green}[%n] %(!.#.$) %f'
#PROMPT='%F{cyan}[%m]%F{yellow}[%D %T]%F{green}[%n] %(!.#.$) %f'
#PROMPT='%F{cyan}[Lif@%n]%F{yellow}[%D %T]%F{cyan}[%1~]%F{green} %(!.#.$) %f'

# _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
# _/_/_/ BIRA-Inspired PROMPT SETTING _/_/_/
# _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#   Instead of loading zmodule <zsh-theme> in .zimrc,
#   here I define bira-theme manually.
#   see the details at;
#   https://github.com/zimfw/bira/blob/master/bira.zsh-theme

# Type-No.1
#PS1='╭─%B%(!.%F{red]}.%F{yellow}%m:%F{magenta}[%D %T]%F{green})[%n]%F{blue}[%(3~|../%2~|%~)]${[(e)git_info[prompt]]}${VIRTUAL_ENV:+" %F{green}‹${VIRTUAL_ENV:t}›"}%f%b
#╰─%B%(!.#.$)%b '
#RPS1='%B%(?..%F{red}%? ↵%f)%b'

# Type-No.2
#PS1='╭─%B%(!.%F{red]}.%F{yellow}%m:%F{magenta}[%D %T]%F{green})[%n]%F{blue}[%(3~|../%2~|%~)]${[(e)git_info[prompt]]}%f%b
#╰─%B%(!.#.$)%b '
#RPS1='%B%(?..%F{red}%? ↵%f)%b'

 
#
# CUDA SETTINGS (if you needed)
#

# export PATH="/usr/local/cuda-12.1/bin:$PATH"
# export LD_LIBRARY_PATH="/usr/local/cuda-12.1/lib64:$LD_LIBRARY_PATH"

#
# UV and UVX SETTINGS (if needed)
#

. "$HOME/.local/bin/env"
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# EoF
```
