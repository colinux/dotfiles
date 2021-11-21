# Copy vim/* config
mkdir -p $HOME/.vim
cp -a $HOME/.dotfiles/vim/vim-config/* $HOME/.vim/
cp -a $HOME/.dotfiles/vim/vim-config/.* $HOME/.vim/

# Language support
python3 -m pip install --user --upgrade pynvim
gem install neovim
npm -g install neovim

# Vundle install
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

echo "Now run :PluginInstall in nvim to install plugins"

echo "Also run yarn install in .vim/bundle/coc-vim"
