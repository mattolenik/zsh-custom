local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
nl=$'\n'
function profile() {
  if [ ! -z "$AWS_PROFILE" ]; then
    echo -n %{$fg_bold[red]%}$AWS_PROFILE%{$reset_color%}
  else
    echo -n default
  fi
}
PROMPT='$(profile) [${AWS_DEFAULT_PROFILE}] $(git_prompt_info)${nl}${ret_status} %{$fg[cyan]%}%(5~|%-1~/…/%3~|%4~)%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
