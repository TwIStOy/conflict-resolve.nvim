let s:conflict_block_base = {
      \ 'begin': [0, 0],
      \ 'end': [0, 0],
      \ 'sep': [0, 0]
      \ }

" create a new block instance
function! conflict_resolve#block#new(block_begin, block_end, block_seperator) abort
  let l:block = deepcopy(s:conflict_block_base)

  let l:block['begin'] = a:block_begin
  let l:block['end'] = a:block_end
  let l:block['sep'] = a:block_seperator

  return l:block
endfunction

" delete lines between [pos_from, pos_to]
function! s:delete_lines(pos_from, pos_to) abort
  if type(a:pos_from) == v:t_number
    let l:from = a:pos_from
  else
    let l:from = a:pos_from[0]
  endif

  if type(a:pos_to) == v:t_number
    let l:to = a:pos_to
  else
    let l:to = a:pos_to[0]
  endif

  if l:from == l:to
    execute l:from . 'delete'
  else
    execute l:from . ',' . l:to . 'delete'
  endif
endfunction

" check if block is a valid conflict-block
function! s:conflict_block_base.is_valid() abort
  return self.begin != [0, 0] && self.end != [0, 0] && self.sep != [0, 0]
endfunction

function! s:conflict_block_base.choose_themselves() abort
  if !self.is_valid()
    return
  endif

  call s:delete_lines(self.end, self.end)
  call s:delete_lines(self.begin, self.sep)
endfunction

function! s:conflict_block_base.choose_ourselves() abort
  if !self.is_valid()
    return
  endif

  call s:delete_lines(self.begin, self.begin)
  call s:delete_lines(self.sep, self.end)

  " vim-repeat integrate
  silent! call repeat#set("\<Plug>(conflict-resolve-ourselves)", v:count)
endfunction

function! s:conflict_block_base.choose_both() abort
  if !self.is_valid()
    return
  endif

  call s:delete_lines(self.begin, self.begin)
  call s:delete_lines(self.sep, self.sep)
  call s:delete_lines(self.end, self.end)

  " vim-repeat integrate
  silent! call repeat#set("\<Plug>(conflict-resolve-both)", v:count)
endfunction

