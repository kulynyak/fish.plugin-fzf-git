function fco
    function isGit
        if [ -d .git ]
            echo 1
        else
            set isGit (git rev-parse --git-dir 2> /dev/null)
        end
    end
    if [ -z (isGit) ]
        echo "Not a git repository"
        return
    end
    set -l branchList $(git branch -a | string split0)
    set -l oBranchName $(echo "$branchList" | grep \* | sed 's# *\* *##g')
    set -l nBranch $(echo "$branchList" | fzf-tmux -d30 -- -x --select-1 --exit-0 | sed 's# *##')
    if [ -z "$nBranch" ]
        return
    end
    if string match -r origin $nBranch
        set nBranchName $(echo "$nBranch" | sed "s#.*origin\/##")
        set swCmd "git checkout -b $nBranchName $nBranch"
    else
        set nBranchName $(echo "$nBranch" | sed "s#.* ##")
        set swCmd "git checkout $nBranchName"
    end
    if [ "$nBranchName" = "$oBranchName" ]
        return
    end
    set -l stashName $(git stash list | grep -m 1 "On .*: ==$oBranchName==" | sed -E "s#(stash@\{.*\}): .*#\1#g")
    if [ -n "$stashName" ]
        git stash drop "$stashName"
    end
    git stash save "==$oBranchName==" 2>/dev/null
    eval $swCmd
    set -l stashName $(git stash list | grep -m 1 "On .*: ==$nBranchName==" | sed -E "s#(stash@\{.*\}): .*#\1#g")
    if [ -n "$stashName" ]
        git stash apply "$stashName"
    end
    echo -e "\n"
end
