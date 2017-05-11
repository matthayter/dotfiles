function make-completion-wrapper () {
  local function_name="$2"
  local arg_count=$(($#-3))
  local comp_function_name="$1"
  shift 2
  local function="
    function $function_name {
      ((COMP_CWORD+=$arg_count))
      COMP_WORDS=( "$@" \${COMP_WORDS[@]:1} )
      "$comp_function_name"
      return 0
    }"
  eval "$function" > /dev/null 2>&1
}


# Aliases
if [ `uname -s` = 'Darwin' ]; then
  # MacOSX
  alias l='ls -G'
else
  alias l='ls --color=auto'
fi
alias la='l -la'
alias ll='l -l'
alias v=vim
#alias vim=nvim

alias d=docker
make-completion-wrapper _docker _docker1 docker
complete -F _docker1 d

# Rails aliases
alias bx='bundle exec'

shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# Configure colors, if available.
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    c_reset='\[\e[0m\]'
    c_user='\[\e[0;32m\]'
    c_path='\[\e[1;34m\]'
    c_git_clean='\[\e[0;37m\]'
    c_git_staged='\[\e[0;32m\]'
    c_git_unstaged='\[\e[0;31m\]'
else
    c_reset=
    c_user=
    c_path=
    c_git_clean=
    c_git_staged=
    c_git_unstaged=
fi
 
# Add the titlebar information when it is supported.
case $TERM in
xterm*|rxvt*)
    TITLEBAR='\[\e]0;\u@\h: \w\a\]';
    ;;
*)
    TITLEBAR="";
    ;;
esac
 
if [ `uname -s` = 'Darwin' ]; then
  # Mac OSX bash-completion setup
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi

  # Use a function from git_completion.bash to have completions work with the alias
  alias co="git checkout"
  __git_complete co _git_checkout
  alias g=git
  __git_complete g _git
  alias gl='git l'
  __git_complete gl _git_log
  alias gs='git st'
  alias gd='git diff'
fi


# NVM
[[ -s /Users/mhayter/.nvm/nvm.sh ]] && . /Users/mhayter/.nvm/nvm.sh # This loads NVM
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion # This loads completion for NVM

# Python virtualenvwrapper
if [[ -e /usr/local/bin/virtualenvwrapper_lazy.sh ]]; then
  export WORKON_HOME=$HOME/.virtualenvs
  export PROJECT_HOME=$HOME/dev
  export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
  source /usr/local/bin/virtualenvwrapper_lazy.sh
fi

# Function to assemble the Git parsingart of our prompt.
git_prompt ()
{
    GIT_DIR=`git rev-parse --git-dir 2>/dev/null`
    if [ -z "$GIT_DIR" ]; then
        return 0
    fi
    GIT_HEAD=`cat $GIT_DIR/HEAD`
    GIT_BRANCH=${GIT_HEAD##*/}
    if [ ${#GIT_BRANCH} -eq 40 ]; then
        GIT_BRANCH="(no branch)"
    fi
    STATUS=`git status --porcelain`
    if [ -z "$STATUS" ]; then
        git_color="${c_git_clean}"
    else
        echo -e "$STATUS" | grep -q '^ [A-Z\?]'
        if [ $? -eq 0 ]; then
            git_color="${c_git_unstaged}"
        else
            git_color="${c_git_staged}"
        fi
    fi
    echo "[$git_color$GIT_BRANCH$c_reset]"
}
 
# Thy holy prompt.
PROMPT_COMMAND="$PROMPT_COMMAND PS1=\"${TITLEBAR}${c_path}\w${c_reset}\$(git_prompt)\n\j ${c_user}\u${c_reset} \$ \" ;"
#PS1="${TITLEBAR}${c_path}\w${c_reset}\n\j ${c_user}\u${c_reset} \$ "

# Add personal bin dir.
# The script 'hub' (github defunkt/hub) also installs to ~/bin
export PATH="~/bin:$PATH"
# The haskell installer tool 'stack' uses this to install apps from cabel etc.
localbin=~/.local/bin
export PATH="$PATH:$localbin"
# Cabal install executables from hackage packages here
export PATH="$PATH:~/.cabal/bin"

# Handy tmux scripts I wrote
DOTFILES_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export PATH="$PATH:$DOTFILES_DIR/tmux_scripts"

# Set editor to vim; tmux checks this to set its mode-keys option to vi
export EDITOR=nvim
# Bash: don't save consecutive identical commands
export HISTIGNORE="&"
# Bash: Lots of history
export HISTSIZE="1000000"

# Set java home
if [[ -e /usr/libexec/java_home ]]; then
  export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
fi

# Vi-style controls on command line
set -o vi

# Bump the open file limit
ulimit -n 4096

# Set the git project directory as the tmux window name; if we're not in a git
# project, use the PWD
cd ()
{
  builtin cd $@
  eval "$CD_POST_CMD"
}
CD_POST_CMD+='[[ $TMUX ]] && tmux renamew $(basename $(git rev-parse --show-toplevel 2>/dev/null || pwd));'
# Pretend we cd'd into the starting directory.
eval "$CD_POST_CMD"
