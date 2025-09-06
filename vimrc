" Ubuntu 必须先安装vim，不然提示这个脚本有错
" windows的默认vim配置文件位置:  C:\Program Files (x86)\Vim\_vimrc
" linux的全局配置文件位置； /etc/vim/vimrc
" linux的个人配置文件：~/.vim/vimrc
"==============================================================================
" 制定vim的查找插件的目录.
" windows平台默认不加载用户目录下的.vim目录 C:\Users\<用户名>\.vim
" 但好像有些插件却又自动更新到这个目录下，可能program file目录下vimfiles
" 没有写权限？
"==============================================================================
set runtimepath+=~/.vim



let $PATH = 
    \'/usr/local/bin:' .
    \'/usr/bin:' .
    \'/bin:' .
    \'/usr/sbin:' .
    \'/sbin:' .
    \$HOME . '/.local/bin:' .
    \$HOME . '/go/bin:' .
    \$HOME . '/ghm/bin:' .
    \$PATH

behave mswin
if has('clipboard')
    vnoremap <C-c> "+y
    nnoremap <C-v> "+p
    inoremap <C-v> <C-r>+
     nnoremap <C-a> ggVG
endif

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction




" ===============
" 管理 插件的插件
" ===============
" https://github.com/tpope/vim-pathogen
"
"  Install to ~/.vim/autoload/pathogen.vim. Or copy and paste:
"     mkdir -p ~/.vim/autoload ~/.vim/bundle && \
"     curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
"  If you're using Windows, change all occurrences of ~/.vim to ~\vimfiles."
"
"  安装好pathogen 插件后， 其他所有的插件用 git clone 下载到
"  linux系统的 ~/.vim/bundle 目录下就可以了
"  如果是windows 平台就是vim安装目录的 vimfiles/bundle 目录
"  比如
"    cd ~/.vim/bundle
"    git clone https://github.com/terryma/vim-multiple-cursors
execute pathogen#infect()




"=============================================================
set noerrorbells
set visualbell
set t_vb=
autocmd BufReadPost * set vb t_vb=  "禁用响铃
" set nowrap   set wrap   禁止自动换行/启用自动换行  有时候不自动换行看起来更清楚一些
set cindent
"  参考 :help cinoptions-values
" :1s  设置c 缩进风格， switch的case " 语句相对switch语句的缩进为1个shiftwidth
" l1s  设置c 缩进风格， switch的case 里面的语句把case 作为对齐标准，而不是跟上一句语句对齐
" =0  设置c 缩进风格， switch的case 里面的语句按照case 缩进的距离，
" g1s 设置c++类的"pubic"，"private" ，"protected" 声明的 缩进为1个shiftwidth
" N-s 设置c++ namespace的缩进为0
" (0  设置函数参数太多需要换行时的对齐
set cino=:1s,l1s,g1s,N-s,(0

set number        " 显示行号
set tabstop=2     " 一个tab宽度为2
set expandtab     " 把tab自动切换为空格
" set noexpandtab  " 不自动替换tab
set softtabstop=2 " backspace删除时，自动根据tabstop的值删除个空格
set shiftwidth=2  " cindent缩进
" set autoindent  自动缩进
syntax on        " 语法高亮
" set showmatch    " 默认就开启的高亮匹配的括号
set cursorline "突出显示当前行 set nocursorline
set autochdir " 自动切换当前目录为当前文件所在的目录
set hidden " 允许在有未保存的修改时切换缓冲区，此时的修改由 vim负责保存
set ignorecase " 忽略大小写
set smartcase " 如果搜索包含大写字母，那还是不忽略大小写
set hlsearch " 搜索时，高亮显示搜索到的单词
set foldmethod=syntax  " 设置折叠的方法
set foldnestmax=3      " 设置最大折叠深度
set nofoldenable       " 打开文件时默认不要折叠
set exrc  "设置vim加载所有目录下.vimrc文件，这样每个工程目录就可以有自己的自定义设置了。
set secure  "限制上一步设置里面的目录下的vimrc不能使用某些不安全的命令
set nobackup " 不要备份文件
set noundofile

" vim 7.3开始设置这个highlight long line，不过下面那个好像更好看
" 设置 ColorColumn的颜色 highlight ColorColumn ctermbg=7 guibg=Black
" http://vim.wikia.com/wiki/VimTip810
" 超过80长度的字符采用红色背景，这个比， set colorcolum=80 要好看点。
" /\%81v.\+/这个正则表达式匹配大于80个字符的，还可以用范围 /\%<81v.\%>77v/
" 或者只高亮第81个字符 /\%80v./
" match ErrorMsg '\%>80v.\+' 这个直接用内置ErrorMsg红色字体
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength   /\%81v.\+/
set colorcolumn=80

" vim搜索c的+include文件的路径，比如下面 [I   gf 命令等需要打开头文件的时候，就要根据这个path变量去搜索了。
" set path=""

" 设置编码, 参考 正确设置 Vim 的字符编码选项 http://rainux.org/vim-gvimvim-on-win32
" ==========
"  encoding（enc）：encoding是Vim的内部使用编码，encoding的设置会影响Vim内部的Buffer、消息文字等。在Unix环境下，encoding的默认设置等于locale；Windows环境下会和当前代码页相同。在中文Windows环境下encoding的默认设置是cp936（GBK）。
"  fileencodings：Vim在打开文件时会根据fileencodings选项来识别文件编码，fileencodings可以同时设置多个编码，Vim会根据设置的顺序来猜测所打开文件的编码。
"  fileencoding ：Vim在保存新建文件时会根据fileencoding的设置编码来保存。如果是打开已有文件，Vim会根据打开文件时所识别的编码来保存，除非在保存时重新设置fileencoding。
" termencodings（tenc）：在终端环境下使用Vim时，通过termencoding项来告诉Vim终端所使用的编码。
"  termencodings：在终端环境下使用Vim时，通过termencoding项来告诉Vim终端所使用的编码。
" |:help encoding-values|列出Vim支持的所有编码。
set fileencodings=utf-8,gbk2312,gbk,gb18030,cp936
set fileencoding=utf-8
set encoding=utf-8 " vim内部存储使用的编码格式

" 避免设置encoding=utf-8 后菜单乱码
" 避免设置encoding=utf-8 后vim 提示信息乱码
if has("win32")
  let $LANG='zh_CN.UTF-8'
  language message zh_CN.UTF-8
  set langmenu=zh_CN.UTF-8 " 这个选项需要在菜单加载之前设置，不然要像下面这样重新加载，但可能导致自定义菜单失效
  source $VIMRUNTIME/delmenu.vim
	source $VIMRUNTIME/menu.vim
endif

" set nobomb       可以删除UTF-8 文件开始的几个BOM 文件编码标识的字节。
" windows的记事本默认设置BOM，可以用vim打开，执行这个之后再
" :wq 保存就可以删掉了

" set fileformat=unix 进入vim可以修改文件的换行模式为linux的lf 风格或者windows crlf风格
" setlocal fileformat=dos    fileformat 为local变量，也可以在这里一打开就修改?
" set fileformats=auto  自动根据文件的原有换行是windows的 crlf还是
" linux的lf，自动设定文件格式是unix还是dos换行模式。新文件自动采用系统默认黄行
" 可以强制设置所有的文件都用unix换行也可以吧。不过git里面可以设置把源码文件（文
" 本文件，或者某种扩展名的文件）在checkin，checkout时自动转换为某个换行模式。
" 参考 https://git-scm.com/docs/gitattributes

" 设置语法高亮主题
" =================
" monokai主题不支持字符终端，在xshell里面需要事先用gui2term.py
" 处理一下，转换成成支持字符终端的主题
" gui2term.py http://www.vim.org/scripts/script.php?script_id=2778
" 或者 guicolorscheme " 之类的插件来辅助转换一下，
" 不然设置这个主题，颜色效果出不来。参考下面set  t_Co=256的说明
" colorscheme monokai   " sublime text 编辑器风格
" colorscheme flatland
" colorscheme material
"" colorscheme PaperColor
"
" git clone https://github.com/tomasr/molokai
" set background=dark
 colorscheme molokai   " 基于 monokai的修改的主题，比monokai背景要好看一些。


" 切换paste 模式快捷键
set pastetoggle=<leader>z

" 保存文件快捷键
nnoremap <leader>s :w<cr>
inoremap <leader>s <C-c>:w<cr>
" 避免windows 10 里面 tagbar 插件侧边栏显示 tooltip 气球提示时gvim崩溃的bug
if has("win32")
  set noballooneval   " vimrc比插件早加载，后面那些插件里面又打开了，导致设置无效。进入界面再手工设置就可以。用autocmd 设置延时执行？
  set balloondelay=10000000  " 设置一个超长停留时间，鼠标停10000秒才显示 ballon tooltip， 插件里面不改这个，这样基本就禁止tooltip功能了
endif

" 在 xshell或者一个非GUI的字符终端里面，设置这个颜色为 25 color 显示更清楚
" 但要字符终端支持256色才能这么设置，参考下面网站的说明
" Using GUI color settings in a terminal
" http://vim.wikia.com/wiki/Using_GUI_color_settings_in_a_terminal
" 强烈推荐–将GUI配色转化为终端配色的VIM插件–gui2term.py
" http://www.vimer.cn/2010/03/%E5%BC%BA%E7%83%88%E6%8E%A8%E8%8D%90-%E5%B0%86gui%E9%85%8D%E8%89%B2%E8%BD%AC%E5%8C%96%E4%B8%BA%E7%BB%88%E7%AB%AF%E9%85%8D%E8%89%B2%E7%9A%84vim%E6%8F%92%E4%BB%B6-gui2term-py.html
" 让vim在终端下的配色亮起来！
" http://www.vimer.cn/2010/02/%E8%AE%A9vim%E5%9C%A8%E7%BB%88%E7%AB%AF%E4%B8%8B%E7%9A%84%E9%85%8D%E8%89%B2%E4%BA%AE%E8%B5%B7%E6%9D%A5%EF%BC%81.html
if has("gui_running")
else
  set t_Co=256 " 在不是GUI的终端里面，如果像xshell这样的支持256色的话就把这一句注释掉
endif

" 编程字体
" ========
"好像程序员比较喜欢的字体有
"1. Bitstream Vera Sans Mono   （linux默认自带）
"http://www-old.gnome.org/fonts/
"http://ftp.gnome.org/pub/GNOME/sources/ttf-bitstream-vera/1.10/
"2. 微软visual stuido 自带的 Consolas字体
"http://www.microsoft.com/en-us/download/details.aspx?id=17879
"3. adobe 编程字体
"https://github.com/adobe-fonts/source-code-pro
"
"安装完字体，先查看系统字体名字，或者在界面菜单里面手工设置一下再查看
"下面这个设置字体大小为12,
"set guifont=Bitstream_Vera_Sans_Mono:h14:cANSI
"set guifont=Bitstream\ Vera\ Sans\ Mono\ 14
"
" debian/ubuntu上面字体安装，把字体下载回来放到 /usr/share/fonts/truetype/
" 或者 $HOMR/.fonts目录去就可以了，可以自己搜索一下字体安装方法
" 在gvim (apt-get install vim-gtk) 里面可以也可以用这个字体
if has("gui_running")
  if has("win32")
    " 设定 windows 下 gvim 启动时最大化
    autocmd GUIEnter * simalt ~x
    " set guifont=Source_Code_Pro:h14:cANSI
    set guifont=JetBrains_Mono:h14:cANSI:qDRAFT
  else
    " set guifont=Source_Code_Pro:h14:cANSI
    "set guifont=JetBrains_Mono:h14:cANSI:qDRAFT
    " set guifont=Source_Code_Pro:h14:cANSI
    set guifont=Fira\ Code\ 14
  endif
endif

" 记录文件最后一次打开时光标所在的位置
autocmd BufReadPost *
      \ if line("'\"")>0&&line("'\"")<=line("$") |
      \exe "normal g'\"" |
      \ endif

" grep相关的配置
" ==============
" :nmap <F5> :cw<cr>
" :nmap <F4> :cclose<cr>
nmap <F5> :cn<cr>
nmap <F6> :cp<cr>
"把 f3 按键映射为在本目录下文件里面搜索光标下面的单词
if has("win32")
  " grep的设置
  set grepprg=C:/git/usr/bin/grep.exe\ -n
  "windows平台用这个
  nmap <F3> "*yw<cr>:grep <c-v> ./*<cr><esc>:cw<cr>
else
  " linux 平台用这个
  nnoremap <F3> :grep <C-R><C-W> *<CR><esc>:cw<cr>
endif

" 弹出和隐藏quickfix 和locaiton list窗口
" =======================
function! QFixToggle()
  if get(getloclist(0, {'winid':0}), 'winid', 0)
    " the location list window is open
    lwindow
  endif

  if get(getqflist({'winid':0}), 'winid', 0)
    " the quickfix window is open
    cclose
  else
    cwindow
  endif

endfunction
nmap <script> <silent> <F4> :call QFixToggle()<CR>

"  隐藏菜单和工具栏，按F1才显示 Toggle Menu and Toolbar
"  ============================
set guioptions-=m
set guioptions-=T
map <silent> <F1> :if &guioptions =~# 'T' <Bar>
      \set guioptions-=T <Bar>
      \set guioptions-=m <bar>
      \else <Bar>
      \set guioptions +=T <Bar>
      \set guioptions +=m <Bar>
      \endif<CR>

" 编程风格，高亮和去掉行尾的空格
" ==============================
" 这个要放到上面的go语言插件的后面才起作用，go那里好像重设置语法了
" 高亮显示行尾的空格，和空格和TAB键混用的情况
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
" ctermbg 必须用颜色名字，guibg可以用颜色值
highlight default ExtraWhitespace ctermbg=red guibg=#F92672
match ExtraWhitespace /\s\+$\| \+\t\|\t\+ /
" 可以用下面这个删掉所有的行尾空格
" %s/\s\+$//
" 或者像下面这个map <leader>w git stripspace命令，来删掉这个 whitespace error
" 默认的<leader>键是 “\ ” 有的是逗号",”
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" delete all trailing whitespace in current file
if has ("win32")
  map <leader>w :call Preserve(":%!C:/git/bin/git.exe stripspace")<CR>
else
  map <leader>w :call Preserve(":%!git stripspace")<CR>
endif






" C/C++  golang 等语言代码语法错误提示
" ============================
" git clone https://github.com/dense-analysis/ale
" c/c++ 下载安装LLVM https://github.com/llvm/llvm-project/releases
"
"跳转到变量定义
nmap <F7> :ALEGoToDefinition<cr>

" vim-multiple-cursors插件 “True Sublime Text style multiple selections for Vim”
" ========================
" git clone https://github.com/terryma/vim-multiple-cursors
"
" 下面这个更好用？  听说速度快
" https://github.com/mg979/vim-visual-multi
"  ctrl + 上下箭头 多光标， ctrl + n 选择一个单词

" nerdcommenter 快捷注释代码插件
" ===============================
" giut cloen https://github.com/preservim/nerdcommenter
" 映射为空格键注释代码
"
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Set a language to use its alternate delimiters by default
" c语言的注释默认使用 \\  而不是 \* *\
let g:NERDAltDelims_c = 1

:nmap <space> :call nerdcommenter#Comment('n', 'toggle')<CR>
:vmap <space> :call nerdcommenter#Comment('x', 'toggle')<CR>

" 添加commentary注释插件的 cmake文件的注释模式
autocmd FileType cmake set commentstring=#\ %s
autocmd FileType gnuplot set commentstring=#\ %s
autocmd FileType cpp set commentstring=//\ %s
au BufNewFile,BufRead *.sam set filetype=tcl

" vim-expand-region 自动扩展选择区域的插件
" =====================================
" git clone https://github.com/terryma/vim-expand-region
" 自动扩大选择区域的插件，让它只在visual 模式才使用+  _键盘映射
vmap + <Plug>(expand_region_expand)
vmap _ <Plug>(expand_region_shrink

" nerdtree 文件夹目录浏览树
" =========================
" git clone https://github.com/scrooloose/nerdtree
" 把F2映射为显示左侧目录浏览树窗口开关
map <F2> :NERDTreeToggle<CR>

" Buffer Explorer 插件,可以辅助buf的选择
" ==================================
" git clone https://github.com/jlanzarotta/bufexplorer
" 安装完 输入 :BufExplorer  , 就会弹出一个包含所有buffer列表的窗口供选择。
" 用鼠标或者键盘都可以跳转的到对应的buffer去。
" 或者在normal模式直接输入下面这个斜杠开始的命令，都可以打开bufexplorer的窗口。
"   '\be' (normal open)  or
"   '\bs' (force horizontal split open)  or
"   '\bv' (force vertical split open)
"可以把f9映射为这个buffer浏览的快捷键。
noremap <silent> <F9> :BufExplorer<CR>
nmap <F10> :bn<CR>
nmap <F11> :bp<CR>

" 加载 go 语言的插件
" ==================
" git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
" vim-go使用了gopls智能补全工具
" go get golang.org/x/tools/cmd/gopls
" windows平台最新的vim-go和gopls兼容有问题，需要禁用gopls，这样自动保存才会
" 使用gofmt来做格式化. 参见vim-go\autoload\go\fmt.vim和config.vim
let g:go_gopls_enabled = 1
let g:go_fmt_command = 'gofmt'
let g:go_fmt_autosave = 1
let g:go_imports_autosave = 0
" vim-go依赖 gopls的filetype事件才注册自动格式化，参见vim-go\ftplugin\go.vim
" 这里自己注册一下
autocmd BufWritePre *.go call go#auto#fmt_autosave()

" 在golang里面编译安装 https://github.com/jstemmer/gotags
" go get github.com/jstemmer/gotags
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

" tabular 对齐插件
"=======================
" git clone https://github.com/godlygeek/tabular
" 自动对齐插件， 比如可以先用v模式选中几个要对齐的等号赋值语句，
" 然后输入 :Tab /=  就可以多条赋值语句按照等号对齐了
" 后面的写法支持正则表达式的的。
" 比如    :Tab /\S\+   可以对齐结构元素定义
" 比如    :Tab /\w*;   可以对齐结构元素定义
" \S 匹配非空字符。  更多的正则表达式可以  :help pattern-atoms  查看帮组
" 对齐c++注释   :Tab /\/\/
noremap <leader>a :Tab /\S\+;<cr>

" Tagbar 对c++ 的支持比 Taglist 更好
" ====================================
" git clone https://github.com/majutsushi/tagbar
let Tlist_Use_Right_Window = 1   " 显示在右边窗格
" nnoremap <silent> <F8> :TlistToggle<CR>
nnoremap <silent> <F8> :TagbarToggle<CR>

" surround  插件
" ==============
" git clone https://github.com/tpope/vim-surround
" 可以快熟替换字符串两边两边的引号或者括号匹配对
" 常用命令  替换cs'"  删除ds' 整行添加yss)  添加ysiw[  等

" easymotion 插件
" =============
" git clone  https://github.com/Lokaltog/vim-easymotion
" 快速移动插件，两次leader键 \\ +  移动命令，就会把所有的位置用字母表示并高亮起来。
" 然后再敲对应的高亮的字母就快速移动到对应位置。
" 比如  \\w  \\f + 查找的字母  \\e   \\t 等
" 其他的还有多字符匹配等，不过比较复杂。

" vim-textobj-user 插件
" =====================
" git clone https://github.com/kana/vim-textobj-user
" 允许自定义text block块，类似 vi{   vip  vａ(  等自定义块

" 高亮  c/c++ 的函数名和类名
" ===========================
" git clone https://github.com/octol/vim-cpp-enhanced-highlight

" 窗体的透明度插件
" ================
" https://github.com/dbarsam/vim-vimtweak
" autocmd BufReadPost * call libcallnr("vimtweak.dll", "SetAlpha", 255)

" Drwait  绘图ascii图插件
" ===================================================
" http://www.vim.org/scripts/script.php?script_id=40
"    \di to start DrawIt and
"    \ds to stop  DrawIt.

" Alexander Anderson's guifont++
" http://www.vim.org/scripts/script.php?script_id=593
" https://github.com/schmich/vim-guifont
" 把映射键改为  alt + 加减号放大缩小字体


" vim-airline 增强状态栏显示效果的插件
" =====================================
" git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
" 9
" 这个更好用一些？更轻量一些？？
" https://github.com/itchyny/lightline.vim
set laststatus=2   "始终加载 airline 状态栏增强插件，要不然要创建一个split窗口才会加载
let g:lightline = {
                \ 'active': {
                \   'left': [ [ 'mode', 'paste' ],
                \             [ 'filename', 'tagbar' ] ]
                \ },
                \ 'component': {
                \   'tagbar': '%{tagbar#currenttag("[%s]", "", "f" )}',
                \ }
                \ }


" 8c# 的文件缩进
" =================
autocmd FileType cs setlocal shiftwidth=4 tabstop=4 expandtab
autocmd FileType cs setlocal formatoptions+=cro
autocmd FileType cs setlocal cinoptions={0s
