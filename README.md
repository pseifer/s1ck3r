# `> s1ck3r`

A sleek, transient and smartly-spacious prompt for zsh.

main image here

- Sleek design with minimal indicators for status and working directory.
- Shortened (but distinct) paths in the right prompt.
- Inspired by the s1ck94 'minimal' theme (see this [repo](https://github.com/zimfw/s1ck94) or [reddit post](https://www.reddit.com/r/commandline/comments/2ycc5c/zsh_minimal_theme/))

# Install

Clone this repository and add `source /path/to/s1ck3r.zsh` to your `.zshrc`.

# Features

### Sleek, transient and space-efficient prompt.

The current prompt has higher visibility by being larger, adding an extra newline and colors:

image

If the prompt is on the first line of the terminal, the extra newline is not displayed.
If you want to retain this behaviour even after using the `clear` command, add the following alias to your `.zshrc`:

`alias clear="unset S1CK3R_SPACIOUS_PROMPT && clear"`

### Indicators

s1ck3r has left and right prompt components.

ìmage

The left prompt changes color and the symbol based on various conditions.

1. Uses a different symbol if in NORMAL mode (VI bindings).
2. Uses a different symbol if elevated permissions (and NORMAL mode is not active).
3. Uses a different color if previous command resulted in an error.
4. Uses different color if background jobs exists (and previous command was not an error).

The right prompt shows the current working directory, as well as an indicator for the current branch name and status `*`.
If the previous command returned with a non-zero result, the value of '$?' is shown inline as well.
Path names are abbreviated, as follows.
The last element is always shown in full.
The first element is abbreviated to `~` (if under current users home directory) or `~username` if in usernames home directory (while not being username yourself) - otherwise, it uses `/`.
Any other directory in between is abbreviated to its unique prefix in its parent directory (i.e., what you would have to type for tab completion to autosuggest the full directory name).

Note, that the prompt does not indicate the current user and host names.
The author believes that this information should be displayed by other means, e.g., through tmux -- once per screen, not once per terminal line.

# Customization

### Troubleshooting

- Does your setup not support the prompt icons (nerd font) used by default?
    - Try changing any of the `s1ck3r_prompt_token*` named variables.

- Are parts of the prompt invisible?
    - Try setting `s1ck3r_color_dim` to something else than `bright black`.

### Updating Variables

More generally, s1ck3r can be customized by simply initializing any of the following variables with custom values *before* sourcing `s1cker.zsh`.
There are three sections: First, the prompt symbols can be changed. This is required if your terminal/font/etc. does not support the default symbols used, or if you want to use something different.

Below is an ASCII only example configuration.

```sh
# Symbols:
local s1ck3r_prompt_token=">"
local s1ck3r_prompt_token_vi="-"
local s1ck3r_prompt_token_root="#"
local s1ck3r_prompt_token_t="-"
local s1ck3r_prompt_token_continue="  >"

# Symbols (directories):
local s1ck3r_dir_sep="${s1ck3r_dir_sep:-/}"
local s1ck3r_dir_home="${s1ck3r_dir_home:-~}"
```

Secondly, the easy mode color configuration can be used to change the four colors for "highlights" (default green), "dim" elements (default light black), "errors" (default red) as well as the normal foreground color, e.g., used for paths (default foreground).
See below for the default configuration.

```sh
# Easy mode:
local s1ck3r_color_highlight="2"
local s1ck3r_color_dim="8"
local s1ck3r_color_error="1"
local s1ck3r_color_fg="foreground"
```

It is also possible to change *how* these four colors are used, by changing any of the variables given below. It should be rather obvious what these colors are used for; the suffix `_t` means transient and is used for anything related to the non-active prompt.

```sh
# Full custom mode:
local s1ck3r_c_git_branch="$s1ck3r_color_dim"
local s1ck3r_c_git_dirty="$s1ck3r_color_highlight"
local s1ck3r_c_token_inactive="$s1ck3r_color_dim"
local s1ck3r_c_token_active="$s1ck3r_color_highlight"
local s1ck3r_c_token_t="$s1ck3r_color_dim"
local s1ck3r_c_dir="$s1ck3r_color_fg"
local s1ck3r_c_dir_sep="$s1ck3r_color_dim"
local s1ck3r_c_dir_home="$s1ck3r_color_highlight"
local s1ck3r_c_dir_last="$s1ck3r_color_fg"
local s1ck3r_c_dir_t="$s1ck3r_color_dim"
```

Finally, s1ck3r supports a custom prefix. You can use this, for example, to add username and hostname:

```sh
local s1ck3r_prompt_prefix="%n%F{green}@%f%M " # or
#local s1ck3r_prompt_infix=" %n%F{green}@%f%M " #or
#local s1ck3r_prompt_suffix=" %n%F{green}@%f%M"
```
