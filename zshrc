export PATH="/opt/homebrew/opt/curl/bin:$PATH"

export PS1='%F{35}%1~%f %# '

# Lots of history.
export HISTFILESIZE=1000000
export HISTSIZE=1000000
# Add to history immediately.
setopt INC_APPEND_HISTORY
# Allow lines starting with # in the history.
setopt INTERACTIVE_COMMENTS
setopt HIST_IGNORE_DUPS


# Docs on bindkey: https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
# Vim mode
bindkey -v
bindkey '^p' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward

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


# Remove all bindings that start with <escape> to avoid the delay going from insert- to normal-mode.
# Appears after the completions because several keybindings are established by them.
bindkey -rpM viins '^['
# Keep this one: cmd-v (paste) produces this key sequence, so we need to keep it around.
bindkey "^[[200~" bracketed-paste
# Backspace in vim usually doesn't let you delete past the start of the insert. Let's bind backspace to this instead:
bindkey -M viins "^?" backward-delete-char
# option-. produces this funny character. Bind it to "insert the last argument of the previous command"
bindkey -M viins '≥' insert-last-word
# Press '#' in command-mode to toggle a '#' at the start of the line.
bindkey -M vicmd '#' vi-pound-insert
# Press option-m to run the current line but keep the buffer as-is and continue editing.
bindkey -M viins 'µ' accept-and-hold


alias co="git checkout"
alias g=git
alias gl='git l'
alias gs='git st'
alias gd='git diff'
alias glmh='git l master HEAD'
alias grbm='git rebase -i origin/master'
alias gap='git add -p'
alias gfp='git fetch -p'

alias rc='code ~/.zshrc'
alias rrc='source ~/.zshrc'

function take () {
  mkdir $@ && cd ${*[-1]}
}

alias firefox='/Applications/Firefox.app/Contents/MacOS/firefox'

# Functions
# "branch delete"
brd() {
  local branchesCmd="git for-each-ref --format '%(refname:short) %(upstream:track)' refs/heads/ "
  local allBranches=$(eval $branchesCmd)
  local mergedBranches=$(eval $branchesCmd --merged)
  local awkCmd='{ count=$1; $1=""; printf $2 }; { printf (count > 1)? " -" : " [merged]" }; $0 ~ /\[gone\]/ { printf " [gone]" }; { printf "\n" }'
  local allBranchesWithMergeTag=$(print $allBranches'\n'$mergedBranches | sort | uniq -c | awk ${awkCmd} | column -t)

  echo Delete Branches:
  local selectedBranches=($(print $allBranchesWithMergeTag | gum choose --no-limit | awk '{ print $1 }') )

  if [[ -z "${selectedBranches}" ]] return
  # the (F) flag joins array elements with a newline
  gum confirm "$(print "Will delete:\n\n${(F)selectedBranches}\n\n okay?")" && git branch -D ${selectedBranches} || print "Cancelled."
}

# Git change branch
br() {
  git for-each-ref --format '%(if) %(HEAD) %(then)* %(else)| %(end)%(refname:short)' refs/heads/ | gum choose | awk '{ print $2 }' | xargs -t git checkout 

}


gffm() {
  master=${1:-'master'}
  git fetch origin $master:$master && git fetch -p
}
