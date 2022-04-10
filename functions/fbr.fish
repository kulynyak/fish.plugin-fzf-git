function fbr
    function isGit
        if [ -d .git ]
            echo 1
        else
            set isGit (git rev-parse --git-dir 2> /dev/null)
        end
    end
    if [ -z (isGit) ]
        return
    end
    set -l fn "$TMPDIR/"(random)".fgi"
    git branch --all | grep -v HEAD >$fn
    set -l bcnt (cat $fn | wc -l)
    set -l branch (cat $fn | fzf-tmux -d (math 2 + $bcnt) +m)
    and git checkout (echo "$branch" | sed "s#.* ##" | sed "s#remotes/[^/]*/##")
    command rm $fn
end
