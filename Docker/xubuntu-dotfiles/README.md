XUbuntu Docker dotfiles
======

These dockerfiles are meant to make using the associated Dockerfile more pleasant as a Mac user.

Dotfiles
======

These dotfiles are meant to make developing on a Mac more pleasant. What follows is an explanation of what each script does and/or what functionality the commands in that file provide.

Aliases
------

#### Navigation
|    Macro   |      Function       |        Explanation    |
|:----------:|:-------------------:|:---------------------:|
| .. | `cd ..` | Switch to the parent directory |
| ... | `cd ../..` | Switch to the grandparent's directory |

#### General Commands
|    Macro   |      Function       |        Explanation    |
|:----------:|:-------------------:|:---------------------:|
|  ll  |  `ls -GAp`      |   Display ALL directory contents, colorized, and mark directories with slashes |
|  cd  |  `cd`             |                         Always list directory contents on cd                   |
| c | `tr -d '\n' | pbcopy` | Trim new lines and copy to clipboard |
| map | `xargs -n1` | An intuitive map function, e.g. to list all directories that contain a certain file:
 `find . -name .gitattributes | map dirname`|
| reload | `exec ${SHELL} -l` | Reload the shell |
| path | `echo -e ${PATH//:/\\n}` | Print each PATH entry on a new line |


#### Networking
|    Macro   |      Function       |        Explanation    |
|:----------:|:-------------------:|:---------------------:|
|    myip    | `dig +short myip.opendns.com @resolver1.opendns.com` | Find my IP          |
| localip | `ipconfig getifaddr en0` | Find my local ip |
|   netCons  | `lsof -i`             | Show open TCP/IP sockets |
|   flushDNS | `dscacheutil -flushcache` | Flush out the DNS Cache |
|  lsock     | `sudo /usr/sbin/lsof -i -P` | Display open sockets  |
|  lsockU    | `sudo /usr/sbin/lsof -nP | grep UDP` | Display only open UDP sockets |
|  lsockT    | `sudo /usr/sbin/lsof -nP | grep TCP` | Display only open TCP sockets |
|  ipInfo0   | `ipconfig getpacket en0`   | Get info on connections for en0 |
|  ipInfo1   | `ipconfig getpacket en1`   | Get info on connections for en1 |
|  openPorts | `sudo lsof -i | grep LISTEN` | List all listening connections |
|  showBlocked | `sudo ipfw list`   | All ipfw rules inc/blocked IPs |
| ifactive | `ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'` | Show active network interfaces |


#### Web Development
|    Macro   |      Function       |        Explanation    |
|:----------:|:-------------------:|:---------------------:|
|  apacheEdit | `sudo edit /etc/httpd/httpd.conf` | Edit httpd.conf |
| apacheRestart | `sudo apachectl graceful`  | Restart Apache |
| editHosts     | `sudo edit /etc/hosts`  | Edit /etc/ hosts file |
| herr | `tail /var/log/httpd/error_log` | Tails HTTP error logs |
| apacheLogs | `less +F /var/log/apache2/error_log` | Show Apache error logs |
| httpHeaders | `/usr/bin/curl -I -L $@ ` | Grabs headers from web page | 
| httpDebug | `/usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n` | Download a web page and show info on how long it takes |



Bash Profile
------

This loads the .path, .exports, .aliases, and .functions files into the shell for use. It also adds cas-insensitive globbing, autocorrecting typos when `cd`ing, and tab completion for Bash commands and SSH hostnames.


Functions
------

#### General Functions
|    Macro   |      Function       |        Explanation    |
|:----------:|:-------------------:|:---------------------:|
| mkd | `mkdir -p "$@" && cd "$_"` | Creates and enters a new directory of the given name |
| cd | `builtin cd "$@"; ll` | Always lists directory contents upon cd |
| cdf | `cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"` | Change the working directory to the most recently open Finder window location |
| targz | `too long to list` | Create a .tar.gz archive with `zopfli`, `pigz` or `gzip` for compression and automatically exclude .DS_Store files |


#### Miscellaneous
|    Macro   |      Function       |        Explanation    |
|:----------:|:-------------------:|:---------------------:|
| json | `too long to list` | Syntax high-lighting JSON Strings or files |
| switch | `tmux switch -t "$@"` | Switches to an exisiting tmux session |
| attach | `tmux attach-session -t "$@"` | Attach a new tmux session |
| list | `tmux list-sessions` | List the current tmux sessions |
| prompt_git | `too long to list` | Show information about the status of the current git repository |
| httpDebug | `/usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n"` | Download a web page and show info on what took the most time |
| httpHeaders | `/usr/bin/curl -I -L $@` | Grab headers from a web page |


Gitconfig & Gitignore
------

#### Gitconfig
|    Macro   |      Function       |        Explanation    |
|:----------:|:-------------------:|:---------------------:|
| l | `log --pretty=oneline -n 20 --graph --abbrev-commit` | View abbreviated SHA, description, and history graph of the latest 20 commits|
| s | `status -s` | View the current working tree status using the short format |
| d | `!"git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat"` | Show the diff between the latest commit and the current state |
| p | `!"git pull; git submodule foreach git pull origin master"` | Pull in remote changes for the current repository and all its submodules |
| c | `clone --recursive` | Clone a repository including all submodules |
| ca | `!git add -A && git commit -av` | Commit all changes |
| go | `"!f() { git checkout -b \"$1\" 2> /dev/null || git checkout \"$1\"; }; f"` | Switch to a branch, creating it if necessary |
| tags | `tag -l ` | Show verbose output about tags |
| branches | `branch -a` | Show verbose output about branches |
| remotes | `remote -v` | Show verbose output about remotes |
| aliases | `config --get-regexp alias` | List the aliases in this file |
| reb | `"!r() { git rebase -i HEAD~$1; }; r"` | Perform an interactive rebase with the given number of latest commits |
| dm | `"!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d"` | Remove branches that have already been merged with master |
| mpr | `too long to list` | Merge a GitHub pull request on top of the current branch or, if a branch name is specified, on top of the specified branch |



#### Gitignore
This will ignore most commonly compiled source file types, Intelli-J files, logs and SQL databases, and macOS generated system files.


Tmux
------
This file remaps the tmux prefix to be control + a. It binds the r key to relaod the tmux config file. It also allows panes to be switch by pressing alt+arrow to the direction of the pane to switch to. It also allows mouse control (clickable windows, panes, and resizeable panes).


Vimrc
------
This file does the following:

- Enables the Solarized Dark Theme
- Enables line numbers
- Colors the 80th column line
- Shows the current mode
- Show the filename in the window titlebar
- Makes tabs two spaces wide
- Uses UTF-8 charset
- Centralizes backups, swapfiles, and undo history to ~/.vim/
- Uses the OS Clipboard by default, if compiled with +clipboard
- Enables the mouse
- Allow the cursor keys in insert mode
- Optimizes for fast terminal connections
- Doesn't reset the cursor to the start of line when moving around
- Starts scrolling three lines before the horizontal window border
- Enhances auto-completion
- Highlights searches dynamically
- Ignores case of searches

