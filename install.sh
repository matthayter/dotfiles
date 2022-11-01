#! /bin/zsh
for f in zshrc; do
	ln -s $(pwd)/$f "${HOME}/.${f}";
done
