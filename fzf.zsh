# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/dengxin/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/dengxin/.fzf/bin"
fi

source <(fzf --zsh)

alias fcd='cd "$(find . -type d | fzf --preview="ls -la {}")"'

# alias fvi='vi "$(find . -type f | fzf --preview="cat {}")"'

alias gcb='git branch | fzf | cut -c 3- | xargs git checkout'

# alias fvi='vim "$(find ~/doris -type f | fzf --preview "cat {}")"'


alias fvi='file=$(find ~/doris ~/CLionProjects/ -type f | fzf --preview "cat {}")
if [ $? -eq 0 ] && [ -n "$file" ]; then
    vim "$file"
fi'

# https://blog.freecloud.dev/2024/07/27/An-Introduction-to-FZF/

function fglg() {
    git log --graph --color \
          --format='%C(white)%h - %C(yellow)(%an) - %C(green)%cs - %C(blue)%s%C(red)%d' \
          | fzf \
          --ansi \
          --reverse \
          --no-sort \
          --preview='
            echo {} | grep -o "[a-f0-9]\{7\}" \
            && git show --color $(echo {} | grep -o "[a-f0-9]\{7\}")
          '
}

function fgco() {
    separator=$(printf "\t")
    git_branches="git branch --all --color \
      --format='%(HEAD) %(color:yellow)%(refname:short)$separator%(color:green)%(committerdate:short)$separator%(color:blue)%(subject)'"
#      | column -t -s \\t"
    eval "$git_branches" \
    | fzf \
      --ansi \
      --reverse \
      --no-sort \
      --preview-label='[ Commits ]' \
      --preview='
        git log $(echo {} \
        | sed "s/^[* ]*//" \
        | awk "{print \$1}") \
        --graph --color \
        --format="%C(white)%h - %C(green)%cs - %C(blue)%s%C(red)%d"' \
      --bind='alt-c:execute(
        git checkout $(echo {} \
        | sed "s/^[* ]*//" \
        | awk "{print \$1}")
        )' \
      --bind="alt-c:+reload($git_branches)" \
      --bind='enter:execute(
        branch=$(echo {} \
        | sed "s/^[* ]*//" \
        | awk "{print \$1}") \
        && sh -c "git diff --color $branch \
        | less -R"
        )' \
      --header-first \
      --header '
      > ALT C to checkout the branch
      > ENTER to open the diff with less
      '
}



ff () {
        #!/bin/bash

        ##
        # Interactive search.
        # Usage: `ff` or `ff <folder>`.
        [[ -n $1 ]] && pushd $1 # go to provided folder or noop
        RG_DEFAULT_COMMAND="rg -i -l --hidden --no-ignore-vcs"

        selected=$(
        FZF_DEFAULT_COMMAND="rg --files" fzf \
          -m \
          -e \
          --ansi \
          --disabled \
          --reverse \
          --bind "ctrl-a:select-all" \
          --bind "f12:execute-silent:(subl -b {})" \
          --bind "change:reload:$RG_DEFAULT_COMMAND {q} || true" \
          --preview "rg -i --pretty --context 2 {q} {}" \
          --header-first \
          --header '
          > ctrl-a selected-all
          > f12 subl open file
          '\
          | cut -d":" -f1,2
        )

        [[ -n $selected ]] && subl `echo $selected` # open multiple files in editor
        popd
}


# alternative using ripgrep-all (rga) combined with fzf-tmux preview
# This requires ripgrep-all (rga) installed: https://github.com/phiresky/ripgrep-all
# This implementation below makes use of "open" on macOS, which can be replaced by other commands if needed.
# allows to search in PDFs, E-Books, Office documents, zip, tar.gz, etc. (see https://github.com/phiresky/ripgrep-all)
# find-in-file - usage: fif <searchTerm> or fif "string with spaces" or fif "regex"
fif() {
    if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
    local file
    file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages "$*" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '"$*"' {}")" && echo "opening $file" && open "$file" || return 1;
}
