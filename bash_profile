for file in $HOME/.bash_profile_includes/*.sh; do
  [[ -r $file ]] && source $file;
done
if [ -d "$HOME/bin" ] ; then
  PATH="$PATH:$HOME/bin"
fi
source ~/.bashrc

source "${HOME}/globus_repos/aws-token-refresh/profile-additions.sh"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
