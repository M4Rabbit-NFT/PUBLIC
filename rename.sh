//linux one liner.  takes all files names ($f) and moves to new file name ($n) prefix as you like.

ls -v | cat -n | while read n f; do mv -n "$f" "$n.png"; done 

