Bash
======

This [Bash Profile](./.bash_profile "Bash Profile") will change the preferences and adds macros to your command line interface.

Some credit to @Nathan Landau for macros and the idea

## Commands
|    Macro   |      Function       |        Explanation    |
|:----------:|:-------------------:|:---------------------:|
|  ll  |  `ls -GAp`      |   Display ALL directory contents, colorized, and mark directories with slashes |
|  cd  |  `cd`             |                         Always list directory contents on cd                   |
| cleanupDS  | `find . -type f -name '*.DS_Store' -ls -delete` | Delete .DS_Store files  |
| finderShowHidden | `defaults write com.apple.finder ShowAllFiles TRUE`  | Show hidden files in Finder |
| finderHideHidden | `defaults write com.apple.finder ShowAllFiles FALSE` | Hide hidden files in Finder |


Currently commented out macros:
### Networking
|    Macro   |      Function       |        Explanation    |
|:----------:|:-------------------:|:---------------------:|
|    myip    | `curl ip.appspot.com` | Find my IP          |
|   netCons  | `lsof -i`             | Show open TCP/IP sockets |
|   flushDNS | `dscacheutil -flushcache` | Flush out the DNS Cache |
|  lsock     | `sudo /usr/sbin/lsof -i -P` | Display open sockets  |
|  lsockU    | `sudo /usr/sbin/lsof -nP | grep UDP` | Display only open UDP sockets |
|  lsockT    | `sudo /usr/sbin/lsof -nP | grep TCP` | Display only open TCP sockets |
|  ipInfo0   | `ipconfig getpacket en0`   | Get info on connections for en0 |
|  ipInfo1   | `ipconfig getpacket en1`   | Get info on connections for en1 |
|  openPorts | `sudo lsof -i | grep LISTEN` | List all listening connections |
|  showBlocked | `sudo ipfw list`   | All ipfw rules inc/blocked IPs |


### Web Development
|    Macro   |      Function       |        Explanation    |
|:----------:|:-------------------:|:---------------------:|
|  apacheEdit | `sudo edit /etc/httpd/httpd.conf` | Edit httpd.conf |
| apacheRestart | `sudo apachectl graceful`  | Restart Apache |
| editHosts     | `sudo edit /etc/hosts`  | Edit /etc/ hosts file |
| herr | `tail /var/log/httpd/error_log` | Tails HTTP error logs |
| apacheLogs | `less +F /var/log/apache2/error_log` | Show Apache error logs |
| httpHeaders | `/usr/bin/curl -I -L $@ ` | Grabs headers from web page | 
| httpDebug | `/usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n` | Download a web page and show info on how long it takes |