# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# Mar 2013 Yad Smood

# VCS
YS_VCS_PROMPT_PREFIX1=" %{$reset_color%}on%{$reset_color%} "
YS_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# HG info
local hg_info='$(ys_hg_prompt_info)'
ys_hg_prompt_info() {
	# make sure this is a hg dir
	if [ -d '.hg' ]; then
		echo -n "${YS_VCS_PROMPT_PREFIX1}hg${YS_VCS_PROMPT_PREFIX2}"
		echo -n $(hg branch 2>/dev/null)
		if [ -n "$(hg status 2>/dev/null)" ]; then
			echo -n "$YS_VCS_PROMPT_DIRTY"
		else
			echo -n "$YS_VCS_PROMPT_CLEAN"
		fi
		echo -n "$YS_VCS_PROMPT_SUFFIX"
	fi
}

local exit_code="%(?,, C:%{$fg[red]%}%?%{$reset_color%}) "

function virtualenv_info {
	if [ $CONDA_DEFAULT_ENV ]; then
		echo "$CONDA_DEFAULT_ENV"
	elif [ $VIRTUAL_ENV ]; then
		echo "$(basename $VIRTUAL_ENV)"
	else
		echo "GLOBAL_ENV"
	fi
}


# python version info
local python_version_info='$(python_version_prompt_info)'
python_version_prompt_info() {
  if command -v python > /dev/null 2>&1; then
    PYTHON_VERSION="$(python -V 2>&1)"
    PYTHON_VERSION=${PYTHON_VERSION/Python /Python}
    PYTHON_VERSION=${PYTHON_VERSION/ */}
    echo -n " %{$fg[yellow]%}($(virtualenv_info)::${PYTHON_VERSION})%{$reset_color%}"
  fi
}

# Prompt format:
#
# PRIVILEGES USER @ MACHINE in DIRECTORY on git:BRANCH STATE [TIME] (CONDA_ENV) C:LAST_EXIT_CODE
# $ COMMAND
#
# For example:
#
# ╭ owner in ~ [15:39:08] (GLOBAL_ENV::Python3.10.12)
# ╰

PROMPT="
%{$terminfo[bold]$fg[blue]%}╭%{$reset_color%} \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \
%{$reset_color%}in \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${hg_info}\
${git_info} \
%{$reset_color%}[%*]\
${python_version_info}\
${exit_code}
%{$terminfo[bold]$fg[blue]%}╰ %{$reset_color%}"
