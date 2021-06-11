set pipe pipe_file
set sym_link sym_linked_file
mkfifo $pipe
ln -s $pipe $sym_link

set actual (_fzf_preview_file $sym_link)
@test "follows symbolic links" -n (string match --entire "named pipe" $actual)
rm $sym_link $pipe
