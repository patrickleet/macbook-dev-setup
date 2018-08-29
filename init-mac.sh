echo "Hello $(whoami)"

# install homebrew https://brew.sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install git
brew install git

echo "Github requires a few global settings to be configured"
echo "Enter the email address associated with your GitHub account: "
read -r email
echo "Enter your full name (Ex. John Doe): "
read -r username

git config --global --replace-all user.email "$email"
git config --global --replace-all user.name "$username"

ssh-keygen -t rsa -b 4096 -C "$email"
echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_rsa" | tee ~/.ssh/config
eval "$(ssh-agent -s)"

# zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

sed -i .bak 's/git$/git\'$'\n  zsh-autosuggestions/g' ~/.zshrc

# caskroom https://caskroom.github.io
brew tap caskroom/cask

brew cask install google-chrome
brew cask install docker
brew cask install kitematic
brew cask install hyper
brew cask install visual-studio-code
brew cask install vagrant
brew cask install spotify
brew cask install minikube
brew cask install virtualbox
brew install terraform
brew install packer
brew install node
brew install python
brew install jq
brew install kubernetes-cli
brew install kops
brew install jx
brew install kafka
brew install tmux
brew install tree

echo "For n to work properly, you need to own homebrew stuff"
sudo chown -R $(whoami) $(brew --prefix)/*

npm install -g n hpm-cli meta

n use latest

# setup dev directory
mkdir ~/dev/

# set up vscode
code --install-extension PeterJausovec.vscode-docker --install-extension dbaeumer.vscode-eslint --install-extension dzannotti.vscode-babel-coloring --install-extension ilich8086.classic-asp --install-extension marcostazi.VS-code-vagrantfile --install-extension mauve.terraform --install-extension ms-vscode.PowerShell --install-extension neilding.language-liquid --install-extension secanis.jenkinsfile-support

pip3 install awscli --upgrade --user

pbcopy < ~/.ssh/id_rsa.pub
echo "Add the generated SSH key to your GitHub account. It has been copied to your clipboard"
echo "https://github.com/settings/keys"
echo "You may have to change the shell used in Hyper by modifying ~/.hyper.js to /bin/zsh"
