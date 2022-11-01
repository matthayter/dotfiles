#! /bin/zsh
for f in zshrc; do
	ln -fs $(pwd)/$f "${HOME}/.${f}";
done
