local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
nl=$'\n'
separator=${CURATHEME_SEPARATOR:-〜}
prod_symbol=${CURATHEME_SYMBOL_PROD:-"🐿️ "}
other_symbol=${CURATHEME_SYMBOL:-"⇪ "}

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
  print -n %{$fg_bold[red]%}
  if [[ $AWS_PROFILE = "prod" ]]; then
    print -n "$prod_symbol"
  else
    print -n "$other_symbol"
  fi
  print -n %{$reset_color%}
}

profile() {
  icon
  print -n ' '
  if [[ ! -z $"AWS_PROFILE" ]]; then
    print -n %{$fg_bold[red]%}$AWS_PROFILE%{$reset_color%}
    if [[ $AWS_DEFAULT_PROFILE != $AWS_PROFILE ]]; then
      print -n "[$AWS_DEFAULT_PROFILE]"
    fi
  else
    print -n "[${AWS_DEFAULT_PROFILE}]"
  fi
}

git_separator() {

  if [[ -d .git ]] || git rev-parse --git-dir > /dev/null 2>&1; then
    print -n " $separator "
  fi
}

aws='$(profile) $(region)'
PROMPT=$aws'$(git_separator)$(git_prompt_info)${nl}%{$fg_bold[cyan]%}$(collapsed_wd) ${ret_status}%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
