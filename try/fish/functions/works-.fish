function works-
  set -l out (command try exec --path ~/Dropbox/works- $argv 2>/dev/tty | string collect)
  if test $pipestatus[1] -eq 0
    eval $out
  else
    echo $out
  end
end
