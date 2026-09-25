if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Do not inherit pyenv shims from a parent process or an older shell.
path=(${path:#$HOME/.pyenv/shims})
export PATH

export PATH="$HOME/.local/bin:$PATH"
