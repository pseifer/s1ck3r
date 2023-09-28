# `> s1ck3r`

A sleek, transient and space-efficient prompt for zsh.

![main prompt](https://github.com/pseifer/s1ck3r/blob/main/images/s1ck3r-main.png?raw=true)

- Sleek design with minimal indicators for status and working directory.
- Shortened (but distinct) paths in the right prompt.
- Inspired by the s1ck94 'minimal' theme (see this [repo](https://github.com/zimfw/s1ck94) or [reddit post](https://www.reddit.com/r/commandline/comments/2ycc5c/zsh_minimal_theme/))

# Install

Clone this repository and add `source /path/to/s1ck3r.zsh` to your `.zshrc`.

# Features

### Transient and space-efficient

The current prompt has higher visibility by being larger, adding an extra newline and colors:

![transient prompt](https://github.com/pseifer/s1ck3r/blob/main/images/s1ck3r-large.png?raw=true)

If the prompt is on the first line of the terminal, the extra newline is not displayed.

To reset the prompt after using `clear`, add the following alias to your `.zshrc`:
```sh
alias clear="unset S1CK3R_SPACIOUS_PROMPT && clear"
```

### Minimal indicators

s1ck3r has left and right prompt components.
The left prompt changes color and symbol based on various conditions:

1. Uses a different symbol if in NORMAL mode (VI bindings).
![vi normal mode prompt](https://github.com/pseifer/s1ck3r/blob/main/images/s1ck3r-vi.png?raw=true)
2. Uses a different symbol if elevated permissions (and NORMAL mode is not active).
![root prompt](https://github.com/pseifer/s1ck3r/blob/main/images/s1ck3r-root.png?raw=true)
3. Uses a different color if previous command resulted in an error.
![error prompt](https://github.com/pseifer/s1ck3r/blob/main/images/s1ck3r-err.png?raw=true)
4. Uses different color if background jobs exists (and previous command was not an error).
![background jobs prompt](https://github.com/pseifer/s1ck3r/blob/main/images/s1ck3r-jobs.png?raw=true)

The right prompt shows the current working directory, as well as an indicator for the current branch name and status `*`.
If the previous command returned with a non-zero result, the value of '$?' is shown inline as well.

Path names are abbreviated, as follows:
- The last element is always shown in full.
- The first element is abbreviated to `~` (if under `$HOME`) or `~username` (if in other users home directory).
- Any other directory in between is abbreviated to its *unique* prefix in its parent directory (i.e., what you would have to type for tab completion to autosuggest the full directory name).

Note, that the prompt does not indicate the current user and host names.
The author believes that this information should be displayed by other means, e.g., through tmux -- once per screen, not once per terminal line.
See below for how to add this information using any of the s1ck3r custom prefixes.

# Customization

### Troubleshooting

- Does your setup not support the prompt icons (nerd font) used by default?
    - Try changing any of the `s1ck3r_prompt_token*` named variables.

- Are parts of the prompt invisible?
    - Try setting `s1ck3r_color_dim` to something else than `bright black`.

### Customizing Variables

More generally, s1ck3r can be customized by simply initializing any of the following variables with custom values *before* sourcing `s1ck3r.zsh`.
There are three sections: First, the prompt symbols can be changed.
This is required if your setup does not support the default symbols used -- or if you want to use something else.
Below is an ASCII only example configuration.

```sh
# Symbols:
local s1ck3r_prompt_token=">"                              # basic prompt
local s1ck3r_prompt_token_vi="-"                           # prompt in NORMAL mode
local s1ck3r_prompt_token_root="#"                         # elevated prompt (root)
local s1ck3r_prompt_token_t="-"                            # transient prompt
local s1ck3r_prompt_token_continue="  >"                   # continuation (i.e., multiline)
```

Secondly, the easy mode color configuration can be used to change the five colors for "highlights" (default green), "alternative" (default blue), "dim" elements (default light black), "errors" (default red) as well as the standard foreground color (default foreground).

```sh
# Easy mode:
local s1ck3r_color_highlight="2"                           # highlights in path, prompt with jobs
local s1ck3r_color_alternative="4"                         # highlights vi normal mode
local s1ck3r_color_dim="8"                                 # prompt, transient, branch, separators
local s1ck3r_color_error="1"                               # prompt with errors, return value
local s1ck3r_color_fg="foreground"                         # path elements in right prompt
```

It is also possible to change *how* these five colors are used, by changing any of the variables given below.
It should be rather obvious what these colors are used for; the suffix `_t` means "transient" and is used for anything related to the non-active prompt.
(Of course, these variables can be set to *any* color name, id or hex triplet supported by your setup).

```sh
# Full custom mode:
local s1ck3r_c_git_branch="$s1ck3r_color_dim"              # git branch name
local s1ck3r_c_git_dirty="$s1ck3r_color_highlight"         # star (if branch is dirty)
local s1ck3r_c_token="$s1ck3r_color_dim"                   # standard prompt
local s1ck3r_c_token_jobs="$s1ck3r_color_highlight"        # prompt with active jobs
local s1ck3r_c_token_vinormal="$s1ck3r_color_alternative"  # prompt in normal mode
local s1ck3r_c_token_t="$s1ck3r_color_dim"                 # transient prompt
local s1ck3r_c_dir="$s1ck3r_color_fg"                      # directory names in path
local s1ck3r_c_dir_sep="$s1ck3r_color_dim"                 # separator in path
local s1ck3r_c_dir_home="$s1ck3r_color_highlight"          # shorthand for home (~)
local s1ck3r_c_dir_last="$s1ck3r_color_fg"                 # last element of path
local s1ck3r_c_dir_t="$s1ck3r_color_dim"                   # transient path
local s1ck3r_c_error="$s1ck3r_color_error"                 # error prompt and return value
local s1ck3r_c_fix="$s1ck3r_color_fg"                      # color for custom pre/in/suffix
```

Finally, s1ck3r supports custom prefix functions. You may use them, for example, to add username and hostname to the left of the prompt token:

```sh
s1ck3r_prompt_prefix ()
{ 
    echo "%n%F{$s1ck3r_color_highlight}@%f%M "
}
# or
# function s1ck3r_prompt_infix { ... }
# or
# function s1ck3r_prompt_suffix { ... }
```

Here is another example that I use to add the current virtual environment (parent directory) to the right-hand side of the right prompt;
this is not included in s1ck3r by default, since virtual environment setup is somewhat user and use-case dependent.

```sh
# Function for virtual environment (parent dir).
s1ck3r_prompt_suffix()
{
    if [[ -n "$VIRTUAL_ENV" ]] ; then
        echo -n " %F{$s1ck3r_color_dim}(%f"
        echo -n "%F{$s1ck3r_color_highlight}$(basename $(dirname "$VIRTUAL_ENV"))%f"
        echo -n "%F{$s1ck3r_color_dim})%f"
    fi
}
```

The example images in this repository use the [Dracula](https://draculatheme.com/) color theme (where 'light black' - 008 - is set to the 'comment' color) as well as the [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) plugin.

