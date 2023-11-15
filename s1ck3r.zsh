#!/bin/zsh
# s1ck3r - A sleek, transient and space-efficient prompt for zsh.
#             _____ __  _____  _   __ ___________ 
#            /  ___/  |/  __ \| | / /|____ | ___ \
#            \ `--.`| || /  \/| |/ /     / / |_/ /
#             `--. \| || |    |    \     \ \    / 
#            /\__/ /| || \__/\| |\  \.___/ / |\ \ 
#            \____/\___/\____/\_| \_/\____/\_| \_|
#
# Inspired by s1ck94 (see https://github.com/zimfw/s1ck94).
# Find s1ck3r @ https://github.com/pseifer/s1ck3r - MIT licence
#
# Troubleshooting:
#   - Does your setup not support the prompt icons used here? 
#       Try changing s1ck3r_prompt_token, s1ck3r_prompt_token_vi and s1ck3r_prompt_token_t to 
#       something else, e.g., ASCII chars like '>'.
#   - Are parts of the prompt invisible?
#       Try setting s1ck3r_color_dim to something else than bright black.
#
# Customizing s1ck3r - set variables *before* (!) sourcing 's1ck3r.zsh'

# Symbols (prompt):
local s1ck3r_prompt_token="${s1ck3r_prompt_token:-❯}"
local s1ck3r_prompt_token_vi="${s1ck3r_prompt_token_vi:-}"
local s1ck3r_prompt_token_root="${s1ck3r_prompt_token_root:- }"
local s1ck3r_prompt_token_t="${s1ck3r_prompt_token_t:-}"
local s1ck3r_prompt_token_continue="${s1ck3r_prompt_token_continue:-  󱞩}"

# Symbols (directories):
local s1ck3r_dir_sep="${s1ck3r_dir_sep:-/}"
local s1ck3r_dir_home="${s1ck3r_dir_home:-~}"

# Colors: Easy mode:
local s1ck3r_color_error="${s1ck3r_color_error:-1}"
local s1ck3r_color_highlight="${s1ck3r_color_highlight:-2}"
local s1ck3r_color_alternative="${s1ck3r_color_alternative:-4}"
local s1ck3r_color_dim="${s1ck3r_color_dim:-8}"
local s1ck3r_color_fg="${s1ck3r_color_fg:-foreground}"

# Colors: Custom mode:
local s1ck3r_c_git_branch="${s1ck3r_c_git_branch:-$s1ck3r_color_dim}"
local s1ck3r_c_git_dirty="${s1ck3r_c_git_dirty:-$s1ck3r_color_highlight}"
local s1ck3r_c_token="${s1ck3r_c_token:-$s1ck3r_color_dim}"
local s1ck3r_c_token_jobs="${s1ck3r_c_token_jobs:-$s1ck3r_color_highlight}"
local s1ck3r_c_token_vinormal="${s1ck3r_c_token_vinormal:-$s1ck3r_color_alternative}"
local s1ck3r_c_token_t="${s1ck3r_c_token_t:-$s1ck3r_color_dim}"
local s1ck3r_c_dir="${s1ck3r_c_dir:-$s1ck3r_color_fg}"
local s1ck3r_c_dir_sep="${s1ck3r_c_dir_sep:-$s1ck3r_color_dim}"
local s1ck3r_c_dir_home="${s1ck3r_c_dir_home:-$s1ck3r_color_highlight}"
local s1ck3r_c_dir_last="${s1ck3r_c_dir_last:-$s1ck3r_color_fg}"
local s1ck3r_c_dir_t="${s1ck3r_c_dir_t:-$s1ck3r_color_dim}"
local s1ck3r_c_error="${s1ck3r_c_error:-$s1ck3r_color_error}"
local s1ck3r_c_fix="${s1ck3r_c_fix:-$s1ck3r_color_fg}"


# Here be dragons.

# Enable substitutions in the prompt.
setopt PROMPT_SUBST

# Provide noop definitions, if no user defined prefix/infix/suffix exists.
if type 's1ck3r_prompt_prefix' 2>/dev/null | grep -vq 'function'; then
    function s1ck3r_prompt_prefix { }
fi

if type 's1ck3r_prompt_infix' 2>/dev/null | grep -vq 'function'; then
    function s1ck3r_prompt_infix { }
fi

if type 's1ck3r_prompt_suffix' 2>/dev/null | grep -vq 'function'; then
    function s1ck3r_prompt_suffix { }
fi

# A function for printing shortended directories.
# Adapted for s1ck3r from https://stackoverflow.com/a/45336078
function _s1ck3r_short_path
{
    # In normal prompt, use highlighting.
    local colorize="${1:-}"
    local paths=(${(s:/:)PWD})

    # First initialize with ~, ~user, or /

    if [[ "${paths[1]}" = 'home' || "${paths[1]}" = 'Users' ]]; then
        if [[ "${paths[2]}" = "${USER}" ]]; then
            # Current user home directory.
            # Add unique prefix to short path.
            if [[ "${colorize}" -eq 1 ]]; then
                cur_short_path="%F{${s1ck3r_c_dir_home}}${s1ck3r_dir_home}%f"
            else
                cur_short_path="${s1ck3r_dir_home}"
            fi
        elif [[ -n "${paths[2]}" ]]; then
            # Other user home directory.
            if [[ "${colorize}" -eq 1 ]]; then
                cur_short_path="%F{${s1ck3r_c_dir_home}}${s1ck3r_dir_home}%f%F{${s1ck3r_c_dir}}${USER}%f"
            else
                cur_short_path="${s1ck3r_dir_home}${USER}"
            fi
        else
            # *the* home directory.
            if [[ "${colorize}" -eq 1 ]]; then
                cur_short_path="%F{${s1ck3r_c_dir}}/home%f"
            else
                cur_short_path="/home"
            fi
        fi
        # First two now already processed.
        cur_path="/${paths[1]}/${paths[2]}/"
        paths=("${paths[@]:2}")
    else
        # Other directory - start from full path.
        cur_short_path=''
        cur_path='/'
    fi

    # Next, get the last element (if any)
    # and remove if from paths.
    local final="${paths[-1]}"
    if [[ -n "${final}" ]]; then
        #unset 'paths[-1]'
        paths=("${paths[@]:0:${#paths[@]}-1}")
    fi

    # Add all intermediate parts.
    for directory in "${paths[@]}"; do
        cur_dir=''
        # Expand until unique.
        for (( i=0; i<${#directory}; i++ )); do
            cur_dir+="${directory:$i:1}"
            matching=("$cur_path"/"$cur_dir"*/)
            if [[ ${#matching[@]} -eq 1 ]]; then
                break
            fi
        done
        # Add unique prefix to short path.
        if [[ "${colorize}" -eq 1 ]]; then
            cur_short_path+="%F{${s1ck3r_c_dir_sep}}${s1ck3r_dir_sep}%f%F{${s1ck3r_c_dir}}$cur_dir%f"
        else
            cur_short_path+="${s1ck3r_dir_sep}$cur_dir"
        fi
        # Update directory for next segment in loop.
        cur_path+="$directory/"
    done

    # Finally, add the last element in full.
    if [[ -n "${final}" ]]; then
        if [[ "${colorize}" -eq 1 ]]; then
            cur_short_path+="%F{${s1ck3r_c_dir_sep}}${s1ck3r_dir_sep}%f%B%F{${s1ck3r_c_dir_last}}${final}%f%b"
        else
            cur_short_path+="${s1ck3r_dir_sep}${final}"
        fi
    fi

    # If short path is empty, must mean we are in root.
    if [[ -z "${cur_short_path}" ]]; then
        echo "${s1ck3r_dir_sep}"
    else
        echo "$cur_short_path"
    fi
}

# Function for git status.
_s1ck3r_git_branch()
{
    local s1ck3r_git_branch
    local s1ck3r_git_dirty

    s1ck3r_git_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [[ "$(git status --porcelain 2> /dev/null)" != "" ]]; then
        s1ck3r_git_dirty+='*'
    else
        s1ck3r_git_dirty+=''
    fi

    if [[ -n "${s1ck3r_git_branch}" ]]; then
        echo " %F{${s1ck3r_c_git_branch}}$s1ck3r_git_branch%f%F{${s1ck3r_c_git_dirty}}${s1ck3r_git_dirty}%f"
    fi
}

# A spacious prompt with (newline) - but not for the first line.
# The tracking variable is unset by the 'clear' alias below (!)
# Adapted for s1ck3r from https://stackoverflow.com/a/50103965
precmd() 
{
    # Put prompt to the bottom of the window - kinda broken.
    # [[ "${s1ck3r_prompt_bottom}" -eq 1 ]] && printf '\033[1000H'

    if [ "${S1CK3R_SPACIOUS_PROMPT}" -eq 0 ]; then
        S1CK3R_SPACIOUS_PROMPT=1
    elif [ "${S1CK3R_SPACIOUS_PROMPT}" -eq 1 ]; then
        local prm_newl=$'\n'
        PS1="${prm_newl}${PS1}"
    fi
}

# Given the current $KEYMAP, assemble the prompt.
_s1ck3r_prompt()
{
    # Set the prompt tokens based on VI mode > root access > normal.
    local token
    case "${1}" in
        (vicmd)      
                     token="%F{${s1ck3r_c_token_vinormal}}${s1ck3r_prompt_token_vi}%f" ;; 
        (*)          token="%(!.${s1ck3r_prompt_token_root}.${s1ck3r_prompt_token})"  ;;
    esac
    
    # Set prompt prefix (if any).
    echo -n '$(s1ck3r_prompt_prefix)'

    # Set the correct color based on current errors > background jobs > normal color.
    echo -n "%(1j.%F{${s1ck3r_c_token_jobs}}.%F{${s1ck3r_c_token}})%(?..%F{${s1ck3r_c_error}})"

    # Output the correct token.
    echo -n "${token}%f "
}

# Set static prompts.

# rprompt: infix
local s1ck3r_rprompt='$(s1ck3r_prompt_infix)'
# rprompt: error
s1ck3r_rprompt+='%(?..%F{${s1ck3r_c_error}}%?%f )'
# rprompt: path + git info
s1ck3r_rprompt+='$(_s1ck3r_short_path 1)$(_s1ck3r_git_branch)'
# rprompt: suffix
s1ck3r_rprompt+='$(s1ck3r_prompt_suffix)'

local s1ck3r_prompt2="%F{${s1ck3r_c_token_t}}${s1ck3r_prompt_token_continue}%f "
local s1ck3r_prompt_transient="%F{${s1ck3r_c_token_t}}${s1ck3r_prompt_token_t}%f "
local s1ck3r_rprompt_transient='%F{${s1ck3r_c_dir_t}}$(_s1ck3r_short_path 0)%f'

# Initialize the prompt variables.

# The main left prompt.
export PS1="$(_s1ck3r_prompt $KEYMAP)"
# The left prompt in multiline mode.
export PS2="${s1ck3r_prompt2}"

# The main right prompt.
export RPS1="${s1ck3r_rprompt}"
# The right prompt in multiline mode.
export RPS2=''

# Make the prompt transient - i.e., change for previous lines.
# Adapted for s1ck3r from https://www.zsh.org/mla/users/2019/msg00633.html
zle-line-init ()
{
    emulate -L zsh

    # Hacks.
    [[ $CONTEXT == start ]] || return 0
    while true; do
        zle .recursive-edit
        local -i ret=$?
        [[ $ret == 0 && $KEYS == $'\4' ]] || break
        [[ -o ignore_eof ]] || exit 0
    done

    # Also catch and update here, to set VI mode correctly.
    # (...most of the time. Does not work for CTRL-C in NORMAL mode).
    PS1="$(_s1ck3r_prompt $KEYMAP)"

    # Store the current prompt config.
    local saved_prompt="${PS1}"
    local saved_rprompt="${RPS1}"

    # Set the prompt to the transient prompt.
    PS1="${s1ck3r_prompt_transient}"
    RPS1="${s1ck3r_rprompt_transient}"
    zle .reset-prompt

    # Reset variables to their previous values.
    PS1="${saved_prompt}"
    RPS1="${saved_rprompt}"

    # More hacks.
    if (( ret )); then
        zle .send-break
    else
        zle .accept-line
    fi
    return ret
}
zle -N zle-line-init

# Update on zle-keymap-select.
# Note: If using zle-line-init here as well,
# CTRL-C works. However, this conflicts
# with transient initialization.
# zle-line-init
function zle-keymap-select
{
    PS1="$(_s1ck3r_prompt "$KEYMAP")"
    # Also add space here; otherwise would reset on
    # entering NORMAL mode. Caveat: Does insert the
    # newline also when prompt is on first line.
    if [ "$S1CK3R_SPACIOUS_PROMPT" -eq 1 ]; then
        local prm_newl=$'\n'
        PS1="$prm_newl$PS1"
    fi
    zle reset-prompt
}

zle -N zle-keymap-select
# zle -N zle-line-init

#             _____ __  _____  _   __ ___________ 
#            /  ___/  |/  __ \| | / /|____ | ___ \
#            \ `--.`| || /  \/| |/ /     / / |_/ /
#             `--. \| || |    |    \     \ \    / 
#            /\__/ /| || \__/\| |\  \.___/ / |\ \ 
#            \____/\___/\____/\_| \_/\____/\_| \_|
#                           /done

