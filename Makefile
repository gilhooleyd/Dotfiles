.PHONY: all
all: vim tmux git
	echo "DONE"

.PHONY: tmux
tmux:
	ln -s ~/Dotfiles/tmux.conf ~/.tmux.conf

.PHONY: vim
vim:
	ln -s ~/Dotfiles/vimrc ~/.vimrc
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall
	mkdir -p ~/.vim/colors/
	ln -s ~/Dotfiles/david-scheme.vim ~/.vim/colors/david-scheme.vim

git: gitconfig
	ln -s ~/Dotfiles/gitconfig ~/.gitconfig

.PHONY: clean
clean:
	rm -rf ~/.vim
	rm ~/.vimrc
	rm ~/.tmux.conf

