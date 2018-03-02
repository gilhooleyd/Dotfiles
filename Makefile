.PHONY: server
server: vim
	ln -s ~/Dotfiles/server-tmux.conf ~/.tmux.conf

.PHONY: mac
mac: vim
	ln -s ~/Dotfiles/mac-tmux.conf ~/.tmux.conf

.PHONY: vim
vim:
	ln -s ~/Dotfiles/vimrc ~/.vimrc
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall
	mkdir -p ~/.vim/colors/
	ln -s ~/Dotfiles/david-scheme.vim ~/.vim/colors/david-scheme.vim

git: gitconfig
	ln -s ~/Dotfiles/gitconfig ~/.gitconfig

.PHONY: i3
i3: .i3.config
	mkdir -p ~/.i3/
	ln -s ~/Dotfiles/.i3.config ~/.i3/config

.PHONY: clean
clean:
	rm -rf ~/.vim
	rm ~/.vimrc
	rm ~/.tmux.conf

