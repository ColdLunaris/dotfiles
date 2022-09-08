# Setup fzf
# ---------
if [[ ! "$PATH" == */home/lunaris/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/aiden/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/aiden/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/aiden/.fzf/shell/key-bindings.zsh"
