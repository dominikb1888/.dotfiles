# git-blame
# Autogenerated from man page /nix/store/g456faq9v8zmsi3995fj7lsibjibwvz6-git-2.38.1/share/man/man1/git-blame.1.gz
complete -c git-blame -s b -d 'Show blank SHA-1 for boundary commits'
complete -c git-blame -l root -d 'Do not treat root commits as boundaries'
complete -c git-blame -l show-stats -d 'Include additional statistics at the end of blame output'
complete -c git-blame -s L -s L -d 'Annotate only the line range given by <start>,<end>, or by the function name …'
complete -c git-blame -s l -d 'Show long rev (Default: off)'
complete -c git-blame -s t -d 'Show raw timestamp (Default: off)'
complete -c git-blame -s S -d 'Use revisions from revs-file instead of calling git-rev-list(1)'
complete -c git-blame -l reverse -d 'Walk history forward instead of backward'
complete -c git-blame -l first-parent -d 'Follow only the first parent commit upon seeing a merge commit'
complete -c git-blame -s p -l porcelain -d 'Show in a format designed for machine consumption'
complete -c git-blame -l line-porcelain -d 'Show the porcelain format, but output commit information for each line, not j…'
complete -c git-blame -l incremental -d 'Show the result incrementally in a format designed for machine consumption'
complete -c git-blame -l encoding -d 'Specifies the encoding used to output author names and commit summaries'
complete -c git-blame -l contents -d 'When <rev> is not specified, the command annotates the changes starting backw…'
complete -c git-blame -l date -d 'Specifies the format used to output dates'
complete -c git-blame -l progress -d 'Progress status is reported on the standard error stream by default when it i…'
complete -c git-blame -s M -d 'Detect moved or copied lines within a file'
complete -c git-blame -s C -d 'In addition to -M, detect lines moved or copied from other files that were mo…'
complete -c git-blame -l ignore-rev -d 'Ignore changes made by the revision when assigning blame, as if the change ne…'
complete -c git-blame -l ignore-revs-file -d 'Ignore revisions listed in file, which must be in the same format as an fsck'
complete -c git-blame -l color-lines -d 'Color line annotations in the default format differently if they come from th…'
complete -c git-blame -l color-by-age -d 'Color line annotations depending on the age of the line in the default format'
complete -c git-blame -s h -d 'Show help message'
complete -c git-blame -s c -d 'Use the same output mode as git-annotate(1) (Default: off)'
complete -c git-blame -l score-debug -d 'Include debugging information related to the movement of lines between files …'
complete -c git-blame -s f -l show-name -d 'Show the filename in the original commit'
complete -c git-blame -s n -l show-number -d 'Show the line number in the original commit (Default: off)'
complete -c git-blame -s s -d 'Suppress the author name and timestamp from the output'
complete -c git-blame -s e -l show-email -d 'Show the author email instead of author name (Default: off)'
complete -c git-blame -s w -d 'Ignore whitespace when comparing the parent\'s version and the child\'s to find…'
complete -c git-blame -l abbrev -d 'Instead of using the default 7+1 hexadecimal digits as the abbreviated object…'

