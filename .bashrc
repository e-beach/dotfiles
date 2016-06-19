# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extras}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# vim mode
set -o vi

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

shopt -s globstar


# for screen, ignore input on/off signals that ruin putty
stty -ixon

#########################
# completition boilerplate #
#########################

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi
