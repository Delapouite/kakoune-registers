def list-registers -docstring 'populate the *registers* buffer with the content of registers' %{
  edit! -scratch *registers*
  evaluate-commands %sh{
    # empty scratch buffer
    echo 'exec \%d'

    # paste the content of each register on a separate line
    for reg in '%' '.' '#' '"' '@' '/' '^' '|' \
               a b c d e f g h i j k l m n o p q r s t u v w x y z \
               0 1 2 3 4 5 6 8 9; do
      echo "exec 'i${reg}<space><esc>\"${reg}pGj<a-j>o<esc>'"
    done

    # hide empty registers (lines with less than 4 chars)
    echo 'exec \%<a-s><a-K>.{4,}<ret>d<space>'

    # make sure all registers are easily visible
    echo 'exec gg'
  }
}

# beware, it wipes the content of reg x
def info-registers -docstring 'populate an info box with the content of registers' %{
  list-registers
  exec -save-regs \%| '%<a-s>|cut<space>-c-30<ret>%"xyga'
  info -title registers -- %reg{x}
  set-register x ''
}

