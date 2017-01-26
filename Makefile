.PHONY: server
server: vim
	ln -s ~/Dotfiles/server-tmux.conf ~/.tmux.conf

.PHONY: vim
vim:
	ln -s ~/Dotfiles/vimrc ~/.vimrc
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

.PHONY: mac
mac: vim
	ln -s ~/Dotfiles/mac-tmux.conf ~/.tmux.conf

.PHONY: clean
clean:
	rm -rf ~/.vim
	rm ~/.vimrc
	rm ~/.tmux.conf

