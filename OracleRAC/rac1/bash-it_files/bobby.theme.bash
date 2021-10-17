#!/usr/bin/env bash

SCM_THEME_PROMPT_DIRTY=" ${red}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓"
SCM_THEME_PROMPT_PREFIX=" ${green}|"
SCM_THEME_PROMPT_SUFFIX="${green}|"

GIT_THEME_PROMPT_DIRTY=" ${red}✗"
GIT_THEME_PROMPT_CLEAN=" ${bold_green}✓"
GIT_THEME_PROMPT_PREFIX=" ${green}|"
GIT_THEME_PROMPT_SUFFIX="${green}|"

RVM_THEME_PROMPT_PREFIX="|"
RVM_THEME_PROMPT_SUFFIX="|"

__bobby_clock() {
  printf "$(clock_prompt) "

  if [ "${THEME_SHOW_CLOCK_CHAR}" == "true" ]; then
    printf "$(clock_char) "
  fi
}

function prompt_command() {
    #PS1="${bold_cyan}$(scm_char)${green}$(scm_prompt_info)${purple}$(ruby_version_prompt) ${yellow}\h ${reset_color}in ${green}\w ${reset_color}\n${green}→${reset_color} "
    #PS1="\n$(battery_char) $(__bobby_clock)${yellow}$(ruby_version_prompt) ${purple}\h ${reset_color}in ${green}\w\n${bold_cyan}$(scm_prompt_char_info) ${green}→${reset_color} "
    #PS1="\n$(clock_prompt)$(ruby_version_prompt) ${green}|=| ${red}\h ${reset_color}in ${green}\w ${bold_blue}$(scm_prompt_char_info) ${green}→${reset_color} "
    PS1="\n$(ruby_version_prompt)${green}|=| ${white}\u${white}@${white}\h ${cyan}[\$ORACLE_SID] ${reset_color}in ${green}\w ${bold_blue}$(scm_prompt_char_info) ${green}→${reset_color} "
}

THEME_SHOW_CLOCK_CHAR=${THEME_SHOW_CLOCK_CHAR:-"false"}
THEME_CLOCK_CHAR_COLOR=${THEME_CLOCK_CHAR_COLOR:-"$red"}
THEME_CLOCK_COLOR=${THEME_CLOCK_COLOR:-"$back"}
THEME_CLOCK_FORMAT=${THEME_CLOCK_FORMAT:-"%H:%M:%S"}

safe_append_prompt_command prompt_command
