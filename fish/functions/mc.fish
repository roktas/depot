function mc --wraps=mc
	set -q TMPDIR || set -l TMPDIR /tmp
	set -l t (mktemp -p "$TMPDIR" -d mc.XXXXXXXX ) || return

	if set -q t[1]
		set -l f "$t/dir"

		env SHELL=/bin/bash COLORTERM=truecolor /usr/bin/mc -P "$f" $argv

		if test -r "$f"
			set -l d (cat "$f")
			if test -n "$d"; and test -d "$d"; and test "$d" != "$PWD"
				builtin cd "$d"
			end
		end

		rm -rf "$t"
	end
end
