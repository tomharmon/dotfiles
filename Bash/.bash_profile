
# Make terminal better with macros
alias ls = 'ls -GAp'                    	     # Better 'ls' command
cd() { builtin cd "$@"; ls; }			     # Always list directory contents on cd

# Networking
#alias myip = 'curl ip.appspot.com'		     # find my IP
#alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
#alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
#alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
#alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
#alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
#alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
#alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
#alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
#alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

# Other utils
#   cleanupDS:  Recursively delete .DS_Store files
#   -------------------------------------------------------------------
alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

#   finderShowHidden:   Show hidden files in Finder
#   finderHideHidden:   Hide hidden files in Finder
#   -------------------------------------------------------------------
alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

#   ---------------------------------------
#   Web Development
#   ---------------------------------------

#alias apacheEdit='sudo edit /etc/httpd/httpd.conf'      # apacheEdit:       Edit httpd.conf
#alias apacheRestart='sudo apachectl graceful'           # apacheRestart:    Restart Apache
#alias editHosts='sudo edit /etc/hosts'                  # editHosts:        Edit /etc/hosts file
#alias herr='tail /var/log/httpd/error_log'              # herr:             Tails HTTP error logs
#alias apacheLogs="less +F /var/log/apache2/error_log"   # Apachelogs:   Shows apache error logs
#httpHeaders () { /usr/bin/curl -I -L $@ ; }             # httpHeaders:      Grabs headers from web page

#   httpDebug:  Download a web page and show info on what took time
#   -------------------------------------------------------------------
#httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }

