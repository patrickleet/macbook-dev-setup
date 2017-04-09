# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install git
brew install git

# install ansible
brew install ansible

# setup git
echo "Github requires a few global settings to be configured"
echo "Enter the email address associated with your GitHub account: "
read -r email
echo "Enter your full name (Ex. John Doe): "
read -r username

git config --global --replace-all user.email "$email"
git config --global --replace-all user.name "$username"

# setup dev directory
mkdir ~/dev/
cd ~/dev/
