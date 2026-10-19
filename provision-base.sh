#!/usr/bin/bash
set -euxo pipefail


#
# install rsync.

dnf install -y rsync


#
# install vim.

dnf install -y unzip vim jq

cat >/etc/vimrc <<'EOF'
syntax on
set background=dark
set esckeys
set ruler
set laststatus=2
set nobackup
EOF


#
# configure the shell.

dnf install -y bash-completion

cat >/etc/profile.d/login.sh <<'EOF'
export EDITOR=vim
export PAGER=less
alias l='ls -lF --color'
alias ll='l -a'
alias h='history 25'
alias j='jobs -l'
EOF

cat >/etc/inputrc <<'EOF'
set input-meta on
set output-meta on
set show-all-if-ambiguous on
set completion-ignore-case on
"\e[A": history-search-backward
"\e[B": history-search-forward
"\eOD": backward-word
"\eOC": forward-word
EOF
