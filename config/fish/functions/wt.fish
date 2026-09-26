# worktrunk replaces this lazy loader with its full shell integration on first use.
function wt
    command wt config shell init fish | source
    set -l wt_status $pipestatus[1]
    set -l source_status $pipestatus[2]
    test $wt_status -eq 0; or return $wt_status
    test $source_status -eq 0; or return $source_status
    wt $argv
end
