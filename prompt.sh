init() {
    # variable default
    endline=""
    git_branch=""
    git_dirty=""
    git_bash_prompt=""
}
find_git_branch() {
    local branch
    if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
        if [[ "$branch" == "HEAD" ]]; then
            branch='detached*'
        fi
        if [[ "$branch" == dev-develop* ]]; then
            git_branch="$bldcyn  $branch"
        else
            git_branch="$bldgrn  $branch"
        fi
        current_branch="$branch"
    fi
}
find_git_dirty() {
    local status=$(git status --porcelain 2> /dev/null)
    if [[ "$status" != "" ]]; then
        git_dirty="$bldred "
    fi
}
find_git_untrackedfiles() {
    local status=$(git status 2> /dev/null | grep -iw 'Untracked files')
    if [[ "$status" != "" ]]; then
		git_untracked="$txtblu  "
	else
		git_untracked="$bldblk  "
	fi
}
find_git_modifiedfiles() {
    local status=$(git status 2> /dev/null | grep -iw 'Changes not staged for commit')
    if [[ "$status" != "" ]]; then
		git_modified="$txtblu  "
	else
		git_modified="$bldblk  "
	fi
}
find_git_deletedfiles() {
    local status=$(git status 2> /dev/null | grep -iw 'deleted')
    if [[ "$status" != "" ]]; then
		git_deleted="$bldpur  "
	else
		git_deleted="$bldblk  "
	fi
}
find_git_status() {
	local status=$(git status 2> /dev/null | grep -iw 'Changes to be committed')
	if [[ "$status" != "" ]]; then
		git_status_added="$bldpur  "
        ReadyToCommit="$txtblu  "
	else
		git_status_added="$bldblk  "
        ReadyToCommit="$bldblk  "
	fi
}
find_git_push() {
    if [ -d .git ]; then
        if [[ $(git remote show 2> /dev/null | grep -iw 'origin') != "" ]]; then
            if [[ $(git branch -av 2> /dev/null | grep -iw "remotes/origin/$current_branch") != "" ]]; then
                local status=$(git diff --stat --cached origin/$current_branch)
                if [[ "$status" != "" ]]; then
                    if [[ $(git status 2> /dev/null | grep -iw 'Changes to be committed') == "" ]]; then
                        git_push="$bldylw  "
                    else
                        git_push="$txtwht  "
                    fi
            	else
            		git_push="$txtwht  "
            	fi
            else
                git_push="$txtwht  "
            fi
        else
            git_push="$txtwht  "
        fi
    fi
}
find_git() {
    local status=$(git config --get remote.origin.url)
    if [[ "$status" == *github* ]]; then
        git_show="$txtblu"
    elif [[ "$status" == *bitbucket* ]]; then
        git_show="$txtblu"
    else
        git_show="$txtblu"
    fi
}
initmain() {
    if [ -d .git ]; then
        git_bash_prompt="$bakwht $git_show $git_untracked $git_modified $git_status_added $git_deleted $ReadyToCommit $txtreset$txtwht$bakred $git_push $txtreset$txtred$txtreset "
        endline=$'\n'
    fi
}
PROMPT_COMMAND="init;find_git_branch;find_git_dirty;find_git_status;find_git_untrackedfiles;find_git_modifiedfiles;find_git_deletedfiles;find_git_push;find_git;initmain;$PROMPT_COMMAND"
git_bash_prompt="\$git_bash_prompt\$endline"
