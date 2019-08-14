function! conflict_resolve#ourselves() abort
  let block = conflict_resolve#conflict#find_conflict_block()

  call block.choose_ourselves()

  " vim-repeat integrate
  silent! call repeat#set("\<Plug>(conflict-resolve-ourselves)", v:count)
endfunction

function! conflict_resolve#themselves() abort
  let block = conflict_resolve#conflict#find_conflict_block()

  call block.choose_themselves()

  " vim-repeat integrate
  silent! call repeat#set("\<Plug>(conflict-resolve-themselves)", v:count)
endfunction

function! conflict_resolve#both() abort
  let block = conflict_resolve#conflict#find_conflict_block()

  call block.choose_both()

  " vim-repeat integrate
  silent! call repeat#set("\<Plug>(conflict-resolve-both)", v:count)
endfunction


