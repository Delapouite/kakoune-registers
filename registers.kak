def list-registers -docstring 'populate the *registers* buffer with the content of registers' %{
  declare-option -hidden str-list special_regs "%% %reg{percent}" ". %reg{dot}" "# %reg{hash}"
  edit! -scratch *registers*
  evaluate-commands %sh{
    # empty scratch buffer
    echo 'exec \%d'

    # paste the content of each register on a separate line, first the special registers
    eval set -- "$kak_quoted_opt_special_regs"
    for line; do
      echo "exec 'i${line}<ret><esc>'"
    done

    for reg in '"' '@' '/' '^' '|' \
               a b c d e f g h i j k l m n o p q r s t u v w x y z \
               0 1 2 3 4 5 6 8 9; do
      echo "exec 'i${reg}<space><esc>\"${reg}pGj<a-J>do<esc>'"
    done

    # hide empty registers (lines with less than 4 chars)
    echo 'exec \%<a-s><a-K>.{4,}<ret>d<space>'

    # make sure all registers are easily visible
    echo 'exec gg'
  }
}

def info-registers -docstring 'populate an info box with the content of registers' %{
  list-registers
  try %{ exec '%<a-s>s^.{30}\K[^\n]*<ret>c…<esc>' }
  exec '%'
  info -title registers -- %val{selection}
}

