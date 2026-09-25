# dotfiles

My personal dotfiles.

## New Mac setup

On an Apple Silicon Mac, run:

```sh
curl -fsSLo /tmp/yohai-mac-bootstrap.sh https://raw.githubusercontent.com/Monkhai/dotfiles/master/bootstrap.sh && bash /tmp/yohai-mac-bootstrap.sh
```

The script installs Homebrew if needed, installs the apps and CLI tools in
`Brewfile`, clones this repo, installs Oh My Zsh, and links Zsh and Zed settings.
It can be run again after an interrupted install. It preserves existing files
by moving them aside before linking.

Shared skills currently live in a separate local repository with no remote.
Once that repository is published, pass its clone URL as `SKILLS_REPO_URL` to
include it in the same run. Until then, the script reports the skills step as
pending and exits with status 2 after installing everything else.

Sign-ins, macOS permissions, and Raycast's `.rayconfig` import remain manual.

## Zsh layers

- `zsh/personal`: public personal aliases, functions, and environment setup.
- `~/.config/zsh/work`: work-only aliases, functions, and generated sessions.
- `~/.config/zsh/private`: personal secrets that must never be committed.

Every `*.zsh` file in those directories is loaded automatically.
