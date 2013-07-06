for file in ~/.bash_{path,prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && source "$file"
done
unset file

# No annoying bell or visual bell
set bell-style none

# Dont override files with >, force >|
set -o noclobber

# Enable cyclic tabbing
bind '"\t":menu-complete'

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
# * Case insensitive globbing
# * Append to hist file rather than append, usefull when multiplexing
# * Autocorrect typos in pathnames
for option in autocd globstar nocaseglob histappend cdspell; do
	shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# If possible, add tab completion for many more commands
which brew &>/dev/null
if [ $? -eq 0 ]; then
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi
fi

# Init fasd
eval "$(fasd --init auto)"
_fasd_bash_hook_cmd_complete v

# vim: set ft=sh:
