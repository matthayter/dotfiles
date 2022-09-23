eval "$(/opt/homebrew/bin/brew shellenv)"

alias la='ls -la'
alias ll='ls -l'
alias v=vim


if [ `uname -s` = 'Darwin' ]; then
  # Mac OSX bash-completion setup
  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
  fi
fi

alias co="git checkout"
alias g=git
alias gl='git l'
alias gs='git st'
alias gd='git diff'
