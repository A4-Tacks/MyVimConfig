let g:indentLine_enabled = 1 " 使插件生效
let g:indentLine_char = '┆' " 设置缩进线字符
" let g:indentLine_conceallevel = 2 " 使插件运行

" 每个缩进级别不同字符(与设置缩进线字符不兼容)
" let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" 此插件启用"维姆隐藏"功能,该功能根据语法突出显示自动隐藏拉伸文本.
" 此设置将应用于所有语法项目.
" 您可以自定义这些设置,但如果conceallevel未设置为1或2,则插件将无法工作.
" 该选项定义在何时会对行内进行语法隐藏
let g:indentLine_concealcursor = &concealcursor
" 用于覆盖 conceallevel 选项, 1 为不压缩的隐藏
let g:indentLine_conceallevel = &conceallevel

" 如果要保留隐藏设置， 请将此行放入vim点缀:
" let g:indentLine_setConceal = 0
" let g:indentLine_setConceal = 0

" 不进行json的拉伸
" let g:vim_json_conceal=0              "貌似没用
