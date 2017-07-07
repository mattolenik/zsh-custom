local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
nl=$'\n'

profile() {
  if [[ -v AWS_PROFILE ]]; then
    print -n %{$fg_bold[red]%}$AWS_PROFILE%{$reset_color%}
    if [[ $AWS_DEFAULT_PROFILE != $AWS_PROFILE ]]; then
      print -n " [$AWS_DEFAULT_PROFILE]"
    fi
  else
    print -n "[${AWS_DEFAULT_PROFILE}]"
  fi
}

region() {
  if [ ! -z "$AWS_REGION" ]; then
    print -n in $AWS_REGION
  fi
}

collapsed_wd() {
  wd=$(pwd)
  print -n ${${:-/${(j:/:)${(M)${(s:/:)${(D)wd:h}}#(|.)[^.]}}/${wd:t}}//\/~/\~}
}

icon() {
  if [[ $AWS_PROFILE = "prod" ]]; then
    print -n 🐿️
  else
    print -n ⇪
  fi
}

tab() {
  print "\u0009"
}

PROMPT='%{$fg_bold[red]%}$(icon) %{$reset_color%} $(profile) $(region)$(tab)$(git_prompt_info)${nl}%{$fg_bold[cyan]%}$(collapsed_wd) ${ret_status}%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
