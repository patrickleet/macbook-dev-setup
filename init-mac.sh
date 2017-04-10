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

# caskroom https://caskroom.github.io
brew tap caskroom/cask

brew cask install google-chrome
brew cask install docker
brew cask install kitematic
brew cask install hyper
brew cask install visual-studio-code
brew install terraform
brew install packer
brew install node

npm install -g n
n use latest

npm install -g meta

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

echo "Add zsh-autosuggestions to ~/.zshrc to the plugins list\n"
echo "    plugins=(git zsh-autosuggestions)"

vi ~/.zshrc

# setup dev directory
mkdir ~/dev/

pbcopy < ~/.ssh/id_rsa.pub
echo "Add the generated SSH key to your GitHub account. It has been copied to your clipboard"
echo "https://github.com/settings/keys"
