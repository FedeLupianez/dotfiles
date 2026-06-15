DISABLE_AUTO_UPDATE="true"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="jovial"

# ⚡ Plugins
plugins=(
  git
  zsh-autosuggestions
  fast-syntax-highlighting
  # zsh-syntax-highlighting
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
alias rm_horphans="sudo pacman -Rns $(pacman -Qtdq)"
alias git_ssh_school="git remote set-url origin git@github_school:LupFede/"
alias git_ssh_work="git remote set-url origin git@github_work:FedeLupianez/"
alias gs="git status"
alias gc="git commit -m "
alias ga="git add "

bindkey '^H' backward-kill-word

openf(){
    eval "dir=\$echo $PWD"
    xdg-open "${dir}"
}

copyfile() {
    [[ -f "$1" ]] || {
        echo "archivo no encontrado: $1"
        return 1
    }

    wl-copy < "$1"
    echo "file copied"
}

# =========================
# ⚡ Funciones
# =========================
#


function db_ssh(){
    local profile="${1:-dev}"
    local tool="${2:-nvim}"
    local local_port="${3:-3307}"

    . ~/.config/db_ssh_config.sh
    local remote_host=${(P)${:-${profile}_ssh_host}}
    local remote_port=${(P)${:-${profile}_ssh_port}}
    local ssh_user=${(P)${:-${profile}_ssh_user}}
    local ssh_password=${(P)${:-${profile}_ssh_password}}

    local db_user=${(P)${:-${profile}_db_user}}
    local db_password=${(P)${:-${profile}_db_password}}
    local db_name=${(P)${:-${profile}_db_name}}
    # ssh "$ssh_user@$remote_host"
    sshpass -p "$ssh_password" ssh -N \
        -o ExitOnForwardFailure=yes \
        -L "$local_port:127.0.0.1:$remote_port" \
        "$ssh_user@$remote_host" &
    local ssh_pid=$!

    sleep 2
    echo "Tunnel activo en 127.0.0.1:$local_port (pid $ssh_pid)"
    if [[ $tool == "nvim" ]]; then 
        nvim -c "DBUI"
    else
        mycli --host 127.0.0.1 --port "$local_port" --user "$db_user" --pass "$db_password" "$db_name"
    fi

    kill $ssh_pid 2>/dev/null
    wait $ssh_pid 2>/dev/null
    trap - EXIT INT TERM
    echo "Tunnel cerrado"
}

# bun completions
[ -s "/home/fede/.bun/_bun" ] && source "/home/fede/.bun/_bun"
