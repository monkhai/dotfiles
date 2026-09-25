export NVM_DIR="$HOME/.nvm"

lazy_load_nvm() {
  unset -f nvm node npm npx yarn
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}

nvm() { lazy_load_nvm && nvm "$@"; }
node() { lazy_load_nvm && node "$@"; }
npm() { lazy_load_nvm && npm "$@"; }
npx() { lazy_load_nvm && npx "$@"; }
yarn() { lazy_load_nvm && yarn "$@"; }

if [[ -r "$NVM_DIR/alias/default" ]]; then
  _nvm_default="$(<"$NVM_DIR/alias/default")"
  _nvm_dirs=("$NVM_DIR"/versions/node/v${_nvm_default#v}*(N/n))
  (( $#_nvm_dirs )) && export PATH="${_nvm_dirs[-1]}/bin:$PATH"
  unset _nvm_default _nvm_dirs
fi

export PATH="/Applications/WebStorm.app/Contents/MacOS:$PATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"

export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/4.0.0/bin:$PATH"
_try_cli=/opt/homebrew/lib/ruby/gems/4.0.0/gems/try-cli-1.7.1/try.rb
if [[ -r "$_try_cli" ]]; then
  eval "$(ruby "$_try_cli" init "$HOME/src/tries")"
fi
unset _try_cli

export PATH="$HOME/google-cloud-sdk/bin:$PATH"
[[ -s "$HOME/.config/envman/load.sh" ]] && source "$HOME/.config/envman/load.sh"
export PATH="$PATH:$HOME/go/bin"
export PATH="$HOME/.opencode/bin:$PATH"
