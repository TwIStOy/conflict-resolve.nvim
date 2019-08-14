let s:conflict_syntax_open      = "^<<<<<<< \@="
let s:conflict_syntax_separator = '^=======$'
let s:conflict_syntax_close     = '^>>>>>>> \@='

" This function requires current cursor is inside a block of marked-conflict
" area, and then it will return current conflict block's begin [line, col]
function! conflict_resolve#conflict#find_conflict_block_open() abort
  let begin = searchpos(s:conflict_syntax_open, 'bcnW')
  let backward_end = searchpos(s:conflict_syntax_close, 'bnW')

  if begin == [0, 0] || (backward_end != [0, 0] && backward_end[0] > begin[0])
    " 1. There's no syntax_open before cursor
    " 2. Both syntax_open and syntax_close exist, and syntax close is behind
    " syntax_open. That means cursor is not inside a block of marked-conflict.

    " not inside marked-conflict block:
    " <<<<<<< [begin]
    " >>>>>>> [backward_end]
    " [cur]
    return [0, 0]
  endif

  " normal mode:
  " <<<<<<<
  " >>>>>>> [forward_end]
  " <<<<<<< [begin]
  " [cur]
  " >>>>>>>
  return begin
endfunction

" This function requires current cursor is inside a block of marked-conflict
" area, and then it ill return current conflict block's end [line, col]
function! conflict_resolve#conflict#find_conflict_block_close() abort
  let end = searchpos(s:conflict_syntax_close, 'cnW')
  let forward_begin = searchpos(s:conflict_syntax_open, 'nW')

  if end == [0, 0] || (forward_begin != [0, 0] && forward_begin[0] < begin[0])
    " 1. There's no syntax_close after cursor
    " 2. Both syntax_close and syntax_open exist. And syntax_open is before
    " syntax_close. That means cursor is not inside a block of
    " marked-conflict.

    " not inside marked-conflict block:
    " [cur]
    " <<<<<<< [forward_begin]
    " >>>>>>> [end]
    return [0, 0]
  endif

  " normal mode:
  " <<<<<<<
  " [cur]
  " >>>>>>> [end]
  " <<<<<<< [forward_begin]
  " >>>>>>>
  return end
endfunction

" This function requires current cursor is inside a block of marked-conflict
" area. It will return
function! conflict_resolve#conflict#find_conflict_block() abort
  let block_begin = conflict_resolve#conflict#find_conflict_block_open()
  let block_end = conflict_resolve#conflict#find_conflict_block_close()

  if (block_begin == [0, 0]) || (block_end == [0, 0])
    " is not in a conflict-block
    return conflict_resolve#block#new([0, 0], [0, 0], [0, 0])
  endif

  " try backward search
  let backward_sep = searchpos(s:conflict_syntax_separator, 'bcnW')
  if backward_sep != [0, 0] && block_begin[0] < backward_sep[0] &&
        \ backward_sep[0] < block_end[0]
    return conflict_resolve#block#new(block_begin, block_end, backward_sep)
  endif

  " try forward search
  let forward_sep = searchpos(s:conflict_syntax_separator, 'cnW')
  if forward_sep != [0, 0] && block_begin[0] < forward_sep[0] &&
        \ forward_sep[0] < block_end[0]
    return conflict_resolve#block#new(block_begin, block_end, forward_sep)
  endif

  return conflict_resolve#block#new([0, 0], [0, 0], [0, 0])
endfunction


