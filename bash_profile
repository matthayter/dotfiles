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


[[ -s /Users/mhayter/.nvm/nvm.sh ]] && . /Users/mhayter/.nvm/nvm.sh # This loads NVM
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion # This loads completion for NVM

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
export PATH="$PATH:~/bin"
# The haskell installer tool 'stack' uses this to install apps from cabel etc.
export PATH="$PATH:~/.local/bin"
# Cabal install executables from hackage packages here
export PATH="$PATH:~/.cabal/bin"

# Set editor to vim; tmux checks this to set its mode-keys option to vi
export EDITOR=vim
# Bash: don't save consecutive identical commands
export HISTIGNORE="&"
# Bash: Lots of history
export HISTSIZE="1000000"

# Vi-style controls on command line
set -o vi

# Bump the open file limit
ulimit -n 4096

# Set the working directory as the tmux window name
cd ()
{
  builtin cd $@
  eval "$CD_POST_CMD"
}
CD_POST_CMD+='[[ $TMUX ]] && tmux renamew $(basename $PWD);'
# Pretend we cd'd into the starting directory.
eval "$CD_POST_CMD"
