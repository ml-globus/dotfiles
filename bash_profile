for file in $HOME/.bash_profile_includes/*.sh; do
  [[ -r $file ]] && source $file;
done
