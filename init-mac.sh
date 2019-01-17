echo "Hello $(whoami),"
sleep 1
echo "I'm going to configure your computer now."
sleep 1
echo "I'll need a couple of things from you throughout the process"
echo "So I'll get them from you now..."
sleep 2

echo "Github requires a few global settings to be configured"
echo "Enter the email address associated with your GitHub account: "
read -r email
echo "Enter your full name (Ex. John Doe): "
read -r username

# check for homebrew
echo "Checking if homebrew exists"
command -v brew >/dev/null 2>&1 || { 
    echo >&2 "I require foo but it's not installed."
    echo "Installing homebrew now..." 
    mkdir -p /usr/local/var/homebrew
    sudo chown -R $(whoami) /usr/local/var/homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

sudo mkdir -p /usr/local/sbin
sudo chown -R $(whoami) /usr/local/sbin

echo "Making sure homebrew is up to date"
brew update --force
brew upgrade --cleanup
brew doctor

#  Configure Git
echo "Installing and configuring git"
brew install git
sleep 1
git config --global --replace-all user.email "$email"
git config --global --replace-all user.name "$username"

# SSH Key
echo "Generating an SSH Key - this will be added to your agent for you"
ssh-keygen -t rsa -b 4096 -C "$email"
sleep 1
echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_rsa" | tee ~/.ssh/config
eval "$(ssh-agent -s)"

#  Configure ZSH
echo "Configuring ZSH"
sleep 1
{ # your 'try' block
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
} || { # your 'catch' block
    echo 'Oh My Zsh like to exit for some reasons so this prevents it'
}

# Configure ZSH  plugins
echo "Configuring ZSH plugins"
sleep 1
{
    git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/Dbz/zsh-kubernetes ~/.oh-my-zsh/custom/plugins/zsh-kubernetes
    sed -i .bak 's/git$/git\'$'\n  zsh-autosuggestions/g' ~/.zshrc
    sed -i .bak 's/zsh-autosuggestions$/zsh-autosuggestions\'$'\n  zsh-syntax-highlighting/g' ~/.zshrc
    sed -i .bak 's/zsh-syntax-highlighting$/zsh-syntax-highlighting\'$'\n  zsh-kubernetes/g' ~/.zshrc
} || {
    echo 'Failed to configure zsh plugins'
}

# caskroom https://caskroom.github.io
echo "Installing Brew apps"
sleep 1
{
    brew tap caskroom/cask
    brew tap jenkins-x/jx
    brew cask install google-chrome
    brew cask install docker
    brew cask install kitematic
    brew cask install hyper
    brew cask install visual-studio-code
    brew cask install vagrant
    brew cask install spotify
    brew cask install minikube
    brew cask install virtualbox
    brew cask install google-cloud-sdk
    brew cask install homebrew/cask-versions/java8
    brew cask install ngrok
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
    brew install kubectx
} || {
    echo "One or more brew formulas failed to install"
}

# Make sure user is owner of homebrew directory
echo "For n to work properly, you need to own homebrew stuff"
sudo chown -R $(whoami) $(brew --prefix)/*

echo "Installing n"
sleep 1
npm install -g n

# Use the latest version of Node
echo "Using latest version of Node"
sleep 1
n use latest

echo "Installing hyper term package manager and meta"
sleep 1
npm i -g hpm-cli meta


# setup dev directory
echo "Creating development directory at ~/dev"
sleep 1
mkdir -p ~/dev

# set up vscode
echo "Configure VS Code extensions"
sleep 1
code --install-extension PeterJausovec.vscode-docker \
     --install-extension marcostazi.VS-code-vagrantfile \
     --install-extension mauve.terraform \
     --install-extension secanis.jenkinsfile-support \
     --install-extension formulahendry.code-runner \
     --install-extension mikestead.dotenv \
     --install-extension oderwat.indent-rainbow \
     --install-extension orta.vscode-jest \
     --install-extension jenkinsxio.vscode-jx-tools \
     --install-extension mathiasfrohlich.kotlin \
     --install-extension christian-kohler.npm-intellisense \
     --install-extension sujan.code-blue

# awscli and invoke - kinda like make for python
echo "installing awscli and invoke"
sleep 1
pip3 install awscli --upgrade --user
pip3 install invoke

echo "Copying your SSH key to your clipboard"
pbcopy < ~/.ssh/id_rsa.pub
sleep 1
echo "Add the generated SSH key to your GitHub account. It has been copied to your clipboard"
echo "https://github.com/settings/keys"
sleep 1
sed -i .bak "s/shell:[[:space:]]'',$/shell: 'zsh',/g" ~/.hyper.js
sleep 1
echo "export PATH=\$HOME/.jx/bin/:\$PATH" >> ~/.zshrc
sleep 1
source ~/.zshrc
