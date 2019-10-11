[[ $- != *i* ]] && return

# aliases
alias ls='ls --color=auto'
alias ll='ls -lhAF --color=auto'
alias free='free -mht'
alias ps="ps auxf"
alias tgz="tar -xzvf"
alias v='vim'


PS1='[\u@\h \w]\$ '

# run ssh-agent once
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
    eval `ssh-agent`
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add

# git prompt
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    # only alter prompt in git repos
    GIT_PROMPT_ONLY_IN_REPO=1
    # don't fetch remote status
    GIT_PROMPT_FETCH_REMOTE_STATUS=0
    source $HOME/.bash-git-prompt/gitprompt.sh
fi

if [ -f /usr/share/bash-completion/bash_completion ] && ! shopt -oq posix; then
    . /usr/share/bash-completion/completions/git
    . /usr/share/bash-completion/completions/git-extras
fi

# git aliases to bash alias
function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

# copy git aliases to bash as g$alias
for al in `git --list-cmds=alias`; do
    alias g$al="git $al"
    
    complete_func=_git_$(__git_aliased_command $al)
    function_exists $complete_fnc && __git_complete g$al $complete_func
done

