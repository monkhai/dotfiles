# OpenSpec completions must be on fpath before Oh My Zsh runs compinit.
fpath=("$HOME/.oh-my-zsh/custom/completions" $fpath)

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
ZSH_DISABLE_COMPFIX=true

export LANG=en_US.UTF-8
export LC_TIME=en_US.UTF-8

[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

PROMPT='%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg_bold[green]%}%c%{$reset_color%} $(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Personal config is versioned. Work and private config are local overlays.
for config_dir in \
  "$HOME/.config/zsh/personal" \
  "$HOME/.config/zsh/work" \
  "$HOME/.config/zsh/private"
do
  for config_file in "$config_dir"/*.zsh(N); do
    source "$config_file"
  done
done
unset config_dir config_file

[[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
