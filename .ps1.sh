if [ -f ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
elif [ -f /usr/share/git/completion/git-prompt.sh ]; then
    source /usr/share/git/completion/git-prompt.sh
fi

# Configure Git prompt features
GIT_PS1_SHOWDIRTYSTATE=1        # * unstaged, + staged
GIT_PS1_SHOWSTASHSTATE=1        # $ stashed
GIT_PS1_SHOWUNTRACKEDFILES=1    # % untracked
GIT_PS1_SHOWUPSTREAM="auto"     # Show <> for upstream status
GIT_PS1_SHOWCOLORHINTS=1        # Colorize hints

# Define colors
# RESET="\[\e[0m\]"
# RED="\[\e[91m\]"
# GREEN="\[\e[32m\]"
# BLUE="\[\e[34m\]"
# YELLOW="\[\e[33m\]"
CYAN="\[\e[36m\]"
# MAGENTA="\[\e[35m\]"
# Gentoo-inspired colors
RESET="\[\e[0m\]"
PURPLE="\[\e[35m\]"
GREEN="\[\e[32m\]"
BLUE="\[\e[34m\]"
YELLOW="\[\e[33m\]"
RED="\[\e[31m\]"

# Prompt setup
PROMPT_COMMAND='EXIT_CODE=$?;'

# Exit code segment (red if non-zero)
PS1='\[\e[33m\]${EXIT_CODE}\[\e[0m\] '  # Basic version, always shows exit code

# User@Host
PS1+="${GREEN}\u${RESET}:"

# Current directory (trimmed to 2 last directories)
PS1+="${CYAN}\w${RESET}"

# Git branch with status
PS1+="${YELLOW}\$(__git_ps1 ' (%s)')${RESET} $ "

# New line and prompt symbol
# PS1+="\n\$ "

# Optional: Show timestamp
# PS1+="\[$(date +%H:%M:%S)\] "

# Optional: Truncate long paths
PROMPT_DIRTRIM=2

export PS1
#export PS1='$(RETVAL=$?; [ $RETVAL -ne 0 ] && echo "\[\033[0;31m\][$RETVAL]")[\u > \W]\$ \[\033[0m\]'
