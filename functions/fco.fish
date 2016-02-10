function fco
	function isGit
		if [ -d .git ]
			echo "1"
		else
			set isGit (git rev-parse --git-dir 2> /dev/null)
		end
	end
	if test -z (isGit)
		echo "Not a git repository"
		return
	end
	set -l cur_branch (git rev-parse --abbrev-ref HEAD)
	set -l content "$TMPDIR/"(random)".fgi"
	git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}' > $content
	git branch --all | grep -v HEAD | sed "s/.* //" | sed "s#remotes/[^/]*/##" | sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}' >> $content
	eval "sed -i -e 's/$cur_branch/* $cur_branch/g' $content"
	set -l target
	if test -z "$TMUX"
		set -l fn "$TMPDIR/"(random)".fgi"
	    cat "$content" | fzf --ansi +m > $fn
		set target (cat $fn | head -1)
		command rm $fn
	else
		set target (cat "$content" | fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2)
	end
	command rm $content
	set -l tur_branch (echo "$target" | awk '{print $2}')
	test "$tur_branch" = "$cur_branch"; and return
	set -l stashName (git stash list | grep -m 1 "On $cur_branch: ==$cur_branch" | sed -E "s/(stash@\{.*\}): .*/\1/g")
	test -n "$stashName"; and git stash drop "$stashName"
    git stash save "==$cur_branch" 2>/dev/null
	git checkout $tur_branch
	set stashName (git stash list | grep -m 1 "On $tur_branch: ==$tur_branch" | sed -E "s/(stash@\{.*\}): .*/\1/g")
	test -n "$stashName"; and git stash apply "$stashName"
end
