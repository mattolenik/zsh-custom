local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
nl=$'\n'
prod_symbol=${CURATHEME_SYMBOL_PROD:-"🐿️ "}
other_symbol=${CURATHEME_SYMBOL:-"🎭 "}
missing_symbol=${CURATHEME_SYMBOL_MISSING:-"🤷 "}

icon() {
  local resolved_profile=${AWS_PROFILE:-"$AWS_DEFAULT_PROFILE"}
  print -n %{$fg_bold[red]%}
  if [[ $resolved_profile = "prod" ]]; then
    print -n "$prod_symbol"
  else
    print -n "$other_symbol"
  fi
  print -n %{$reset_color%}
}

profile() {
  if [[ -z "$AWS_PROFILE" ]] && [[ -z "$AWS_DEFAULT_PROFILE" ]]; then return; fi
  if [[ ! -z "$AWS_PROFILE" ]]; then
    print -n %{$fg_bold[red]%}$AWS_PROFILE%{$reset_color%}
    if [[ ! -z "$AWS_DEFAULT_PROFILE" ]] && [[ "$AWS_DEFAULT_PROFILE" != "$AWS_PROFILE" ]]; then
      print -n " [$AWS_DEFAULT_PROFILE]"
    fi
  else
    print -n '['%{$fg_bold[red]%}$AWS_DEFAULT_PROFILE%{$reset_color%}']'
  fi
}

region() {
  if [[ -z "$AWS_REGION" ]] && [[ -z "$AWS_DEFAULT_REGION" ]]; then return; fi
  if [[ ! -z "$AWS_REGION" ]]; then
    print -n "$AWS_REGION"
    if [[ ! -z "$AWS_DEFAULT_REGION" ]] && [[ "$AWS_DEFAULT_REGION" != "$AWS_REGION" ]]; then
      print -n " [$AWS_DEFAULT_REGION]"
    fi
  else
    print -n "[${AWS_DEFAULT_REGION}]"
  fi
}

aws_info() {
  if [[ -z "$AWS_PROFILE" ]] && \
     [[ -z "$AWS_DEFAULT_PROFILE" ]] && \
     [[ -z "$AWS_REGION" ]] && \
     [[ -z "$AWS_DEFAULT_REGION" ]]; then
    return
  fi
  # zsh parameter expansion, trim leading and trailing whitespace
  local prof="${$(profile)/[[:space:]]/ }"
  local reg="${$(region)/[[:space:]]/ }"
  if [[ ! -z "$prof" ]] && [[ ! -z "$reg" ]]; then
    print -n "$(icon) $prof in $reg"
  elif [[ ! -z "$prof" ]]; then
    print -n "$(icon) $prof"
  elif [[ ! -z "$reg" ]]; then
    if [[ ! -z "${missing_symbol// }" ]]; then
      print -n "$missing_symbol "
    fi
    print -n "in $reg"
  fi
  print -n "\n\0" # The null character prevents the shell from stripping the newline when calling $(aws_info)
}

if type shrink_path &> /dev/null; then
  path_string='$(shrink_path -l -t)'
else
  path_string='%c'
fi

setopt prompt_subst
PROMPT='$(aws_info)%{$fg_bold[cyan]%}'$path_string' ${ret_status}%{$reset_color%}$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
