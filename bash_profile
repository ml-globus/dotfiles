for file in $HOME/.bash_profile_includes/*.sh; do
  [[ -r $file ]] && source $file;
done
if [ -d "$HOME/bin" ] ; then
  PATH="$PATH:$HOME/bin"
fi
source ~/.bashrc
