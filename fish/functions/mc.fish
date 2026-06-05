function mc --wraps=mc
	set -l shell (command -s bash)
	if test (uname -s) = Darwin; and test -x /bin/ksh
		set shell /bin/ksh
	end
	set -q shell[1] || set shell /bin/bash
	set -q TMPDIR || set -l TMPDIR /tmp
	set -l vars SHELL="$shell" COLORTERM=truecolor
	set -l t (mktemp -p "$TMPDIR" -d mc.XXXXXXXX ) || return

	if set -q t[1]
		set -l f "$t/dir"

		env $vars mc -P "$f" $argv

		if test -r "$f"
			set -l d (cat "$f")
			if test -n "$d"; and test -d "$d"; and test "$d" != "$PWD"
				builtin cd "$d"
			end
		end

		rm -rf "$t"
	end
end
