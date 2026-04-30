export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="jovial"

# ⚡ Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# =========================
# ⚡ Lazy loading helpers
# =========================

# zoxide solo cuando lo usás
_zoxide_lazy_load() {
  unfunction z zi 2>/dev/null
  eval "$(zoxide init zsh)"
}
z()  { _zoxide_lazy_load; z "$@"; }
zi() { _zoxide_lazy_load; zi "$@"; }

# bun lazy load
_bun_lazy_load() {
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
}
alias bun="_bun_lazy_load && bun"

# =========================
# ⚡ Config liviana
# =========================

# dircolors solo si existe
[[ -f ~/.dir_colors ]] && eval "$(dircolors ~/.dir_colors)"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=gray"

# PATHs
export PATH="$HOME/.opencode/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# env externo (esto puede ser lento → opcional lazy)
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

# =========================
# ⚡ Aliases
# =========================

alias ls="exa --icons --oneline"
alias enable_bluetooth="sudo systemctl enable bluetooth.service"
alias enable_cups="sudo systemctl enable cups.service & sudo systemctl enable cups.socket"
alias enable_avahi="sudo systemctl enable avahi-daemon.service & sudo systemctl enable avahi-daemon.socket"
alias rm_horphans="sudo pacman -Rs $(pacman -Qtdq)"
alias git_ssh_school="git remote set-url origin git@github_school:LupFede/"
alias git_ssh_work="git remote set-url origin git@github_work:FedeLupianez/"

# =========================
# ⚡ Funciones
# =========================

function db_school() {
    ssh -L 3307:127.0.0.1:3306 alumno6to@ismdf.dynv6.net -N &
    local ssh_pid=$!
    trap "kill $ssh_pid 2>/dev/null" EXIT
    sleep 1
    mycli --defaults-group-suffix=_school
}

function db_ssh(){
    local profile="${1:-dev}"
    local local_port="${2:-3307}"
    . ~/.config/db_ssh_config.sh
    eval "remote_host=\$profile_${profile}_host"
    eval "remote_port=\$profile_${profile}_port"
    eval "ssh_user=\$profile_${profile}_user"
    eval "mycli_profile=\$profile_${profile}_mycli"

    ssh -L "$local_port:127.0.0.1:$remote_port" "$ssh_user@$remote_host" -N &
    local ssh_pid=$!
    trap "kill $ssh_pid 2>/dev/null" EXIT
    sleep 1
    mycli --defaults-group-suffix="$mycli_profile"
}
