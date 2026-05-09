export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="jovial"

# ⚡ Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

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
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

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
alias cat="bat"
alias enable_bluetooth="sudo systemctl enable bluetooth.service"
alias enable_cups="sudo systemctl enable cups.service & sudo systemctl enable cups.socket"
alias enable_avahi="sudo systemctl enable avahi-daemon.service & sudo systemctl enable avahi-daemon.socket"
alias rm_horphans="sudo pacman -Rs $(pacman -Qtdq)"
alias git_ssh_school="git remote set-url origin git@github_school:LupFede/"
alias git_ssh_work="git remote set-url origin git@github_work:FedeLupianez/"
alias gs="git status"
alias gc="git commit -m "
alias ga="git add "


# =========================
# ⚡ Funciones
# =========================
#


function db_ssh(){
    local profile="${1:-dev}"
    local local_port="${2:-3307}"
    . ~/.config/db_ssh_config.sh
    eval "remote_host=\$${profile}_ssh_host"
    eval "remote_port=\$${profile}_port"
    eval "ssh_user=\$${profile}_ssh_user"

    eval "db_user=\$${profile}_db_user"
    eval "db_password=\$${profile}_db_password"
    eval "db_name=\$${profile}_db_name"
    eval "db_motor=\$${profile}_db_motor"

    ssh -N "$ssh_user@$remote_host" -L "$local_port:127.0.0.1:$remote_port" &
    local ssh_pid=$!
    trap "kill $SSH_PID;" EXIT INT TERM

    # local attempts=0
    # while ! nc -z 127.0.0.1 "$local_port" 2>/dev/null; do
    #     sleep 0.5
    #     attempts=$((attempts + 1))
    #     if [ $attempts -ge 10 ]; then
    #         echo "Error: tunnel SSH no pudo establecerse en $local_port"
    #         kill $ssh_pid 2>/dev/null
    #         return 1
    #     fi
    # done

    sleep 2
    echo "Tunnel activo en 127.0.0.1:$local_port (pid $ssh_pid)"
    mycli --host 127.0.0.1 --port "$local_port" --user "$db_user" --pass "$db_password" "$db_name"

    kill $ssh_pid 2>/dev/null
    wait $ssh_pid 2>/dev/null
    echo "Tunnel cerrado"
}
