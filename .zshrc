# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install


# ------------------------------
# <by yosakabe>
# Basic customization
# ------------------------------

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

# ------------------------------
# <by yosakabe>
# Customization depending on the machine
# ------------------------------

# PROXY SETTING
# export http_proxy="http://USER:PSW@PROXY:PORT/"
# export https_proxy="http://USER:PSW@PROXY:PORT/"
# export all_proxy="http://USER:PSW@PROXY:PORT/"

# CUDA PATH SETTING
# export PATH="/usr/local/cuda-12.1/bin:$PATH"
# export LD_LIBRARY_PATH="/usr/local/cuda-12.1/lib64:$LD_LIBRARY_PATH"

# ------------------------------
# <by yosakabe>
# Abbreviation Customization
# ------------------------------

# ONLY ACTIVATE FOR THE FIRST TIME
abbr --force els="exa -1l"
abbr --force ela="exa -1la"
abbr --force ell="exa -1la --tree --icons --level=2"
abbr --force ls="ls -GF"
abbr --force la="ls -laGF"
abbr --force ll="ls -lGF"
abbr --force gls="gls --color"

# command memo:
# if you remove the active abbr, type;
# `abbr erase <command>`


# ------------------------------
# <by yosakabe>
# Prompt Customization
# ------------------------------

# _/_/_/_/_/_/_/_/_/_/_/_/_/
# _/_/   bira-theme   _/_/_/
# _/_/_/_/_/_/_/_/_/_/_/_/_/
# # Instead of loading zmodule <zsh-theme> in .zimrc,
# # here I define bira-theme manually.
# # see the details at;
# # https://github.com/zimfw/bira/blob/master/bira.zsh-theme

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
PS1='╭─%B%(!.%F{red]}.%F{cyan}%m:%F{magenta}[%D %T]%F{green})[%n]%F{blue}[%(3~|../%2~|%~)]${[(e)git_info[prompt]]}${VIRTUAL_ENV:+" %F{green}‹${VIRTUAL_ENV:t}›"}%f%b
╰─%B%(!.#.$)%b '
RPS1='%B%(?..%F{red}%? ↵%f)%b'


# _/_/_/_/_/_/_/_/_/_/_/_/_/
# _/_/  minimal-theme _/_/_/
# _/_/_/_/_/_/_/_/_/_/_/_/_/
# Instead of loading zmodule <zsh-theme> in .zimrc,
# here I define minimal-theme manually.
# see the details at;
# https://github.com/zimfw/minimal/blob/master/minimal.zsh-theme

# # Global settings
# if (( ! ${+MNML_OK_COLOR} )) typeset -g MNML_OK_COLOR=green
# if (( ! ${+MNML_ERR_COLOR} )) typeset -g MNML_ERR_COLOR=red
# if (( ! ${+MNML_BGJOB_MODE} )) typeset -g MNML_BGJOB_MODE=4
# if (( ! ${+MNML_USER_CHAR} )) typeset -g MNML_USER_CHAR=λ
# if (( ! ${+MNML_INSERT_CHAR} )) typeset -g MNML_INSERT_CHAR=›
# if (( ! ${+MNML_NORMAL_CHAR} )) typeset -g MNML_NORMAL_CHAR=·
# 
# # Setup
# typeset -g VIRTUAL_ENV_DISABLE_PROMPT=1
# setopt nopromptbang prompt{cr,percent,sp,subst}
# zstyle ':zim:prompt-pwd:tail' length 2
# zstyle ':zim:prompt-pwd:separator' format '%f/%F{244}'
# typeset -gA git_info
# if (( ${+functions[git-info]} )); then
#   zstyle ':zim:git-info:branch' format '%b'
#   zstyle ':zim:git-info:commit' format 'HEAD'
#   zstyle ':zim:git-info:clean' format '%F{${MNML_OK_COLOR}}'
#   zstyle ':zim:git-info:dirty' format '%F{${MNML_ERR_COLOR}}'
#   zstyle ':zim:git-info:keys' format \
#       'rprompt' ' %C%D%b%c'
#   autoload -Uz add-zsh-hook && add-zsh-hook precmd git-info
# fi
# 
# _prompt_mnml_keymap() {
#   case ${KEYMAP} in
#     vicmd) print -n -- ${MNML_NORMAL_CHAR} ;;
#     *) print -n -- ${MNML_INSERT_CHAR} ;;
#   esac
# }
# 
# _prompt_mnml_keymap-select() {
#   zle reset-prompt
# }
# if autoload -Uz is-at-least && is-at-least 5.3; then
#   autoload -Uz add-zle-hook-widget && \
#       add-zle-hook-widget -Uz keymap-select _prompt_mnml_keymap-select
# else
#   zle -N zle-keymap-select _prompt_mnml_keymap-select
# fi
# 
# # <<< Original Prompt >>>
# # PS1=$'${SSH_TTY:+"%m "}${VIRTUAL_ENV:+"${VIRTUAL_ENV:t} # "}%(1j.%{\E[${MNML_BGJOB_MODE}m%}.)%F{%(?.${MNML_OK_COLOR}.${MNML_ERR_COLOR})}%(!.#.${MNML_USER_CHAR})%f%{\E[0m%} $(_prompt_mnml_keymap) '
# # RPS1='%F{244}$(prompt-pwd)${(e)git_info[rprompt]}%f'
# # <<< Customized Prompt >>>
# PS1=$'%F{yellow}${SSH_TTY:+"%m "}${VIRTUAL_ENV:+"${VIRTUAL_ENV:t} "}%(1j.%{\E[${MNML_BGJOB_MODE}m%}.)%F{%(?.${MNML_OK_COLOR}.${MNML_ERR_COLOR})}%(!.#.${MNML_USER_CHAR})%f%{\E[0m%} $(_prompt_mnml_keymap) '
# RPS1='%F{magenta}[%D %T]%F{244}@%(3~|../%2~|%~)${(e)git_info[rprompt]}%f'




# EoF
