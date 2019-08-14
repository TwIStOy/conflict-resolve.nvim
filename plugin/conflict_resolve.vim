if exists('g:conflict_resolve_loaded')
  finish
endif

command! -nargs=0 ConflictResolveChooseThemselves call conflict_resolve#themselves()
command! -nargs=0 ConflictResolveChooseOurselves call conflict_resolve#ourselves()
command! -nargs=0 ConflictResolveChooseBoth call conflict_resolve#both()

nnoremap <silent><Plug>(conflict-resolve-ourselves) :<C-u>ConflictResolveChooseThemselves<CR>
nnoremap <silent><Plug>(conflict-resolve-themselves) :<C-u>ConflictResolveChooseOurselves<CR>
nnoremap <silent><Plug>(conflict-resolve-both) :<C-u>ConflictResolveChooseBoth<CR>

let g:conflict_resolve_loaded = 1

