# Set architecture-specific brew share path.
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
    share_path="/usr/local/share"
elif [ "${arch_name}" = "arm64" ]; then
    share_path="/opt/homebrew/share"
else
    echo "Unknown architecture: ${arch_name}"
fi

### aliases ###

# suffix aliases
alias -s md=subl
alias -s nix=subl

# revert last n commits
grv() {
    git reset --soft HEAD~$1
}

# preview files that would get deleted
clean() {
    git clean -xdn
}

# execute
destroy() {
    git clean -xdf
}

# open current git reopository on github.com
gh() {
    repo_url=$(git config --get remote.origin.url | sed -e 's/\(.*\)git@\(.*\):[0-9\/]*/https:\/\/\2\//g')
    echo $repo_url
    open --url $repo_url
}

# open my repository overview
repos() {
    github_url="https://github.com/$(git config --get user.name)?tab=repositories"
    echo $github_url
    open --url $github_url
}

db() {
    open https://reiseauskunft.bahn.de/
}

# custom greeting
echo Welcome back $(whoami)!
echo Uptime: $(uptime)
echo IP: $(ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2)

### Homebrew ###

# tell homebrew to disable analytics
export HOMEBREW_NO_ANALYTICS=1

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

### Nix ###
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

### ZSH ###

# enable dircolors
export CLICOLOR=1

# enable zsh-autosuggestions
source ${share_path}/zsh-autosuggestions/zsh-autosuggestions.zsh

# enable zsh-syntax-highlighting
source ${share_path}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# add latex to path
eval "$(/usr/libexec/path_helper)"

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  autoload -Uz compinit
  compinit
fi

### GOLANG ###
export GOPATH=$HOME/golang
export GOROOT=/opt/homebrew/Cellar/go/$(go version | { read _ _ v _; echo ${v#go}; })/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# BEGIN - enable yubikey - ANSIBLE MANAGED BLOCK
# enable SSH via gpg-agent
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
# END - enable yubikey - ANSIBLE MANAGED BLOCK

### oh-my-zsh ###

# https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/
ZSH_THEME="agnoster"

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
plugins=()

# Path to oh-my-zsh installation
export ZSH="$HOME/.git/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
