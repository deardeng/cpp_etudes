############
技巧1 . 命令

line one 
line two
line three
line four

. 命令是一个微型的宏

什么是宏，就是一些命令组织在一起，作为一个单独命令完成一个特定任务

############
############
技巧2 不要自我重复

var foo = 1;
var bar = 'a';
var foobar = foo + bar;

$a 等于 A
复合命令  等效的长命令
C         c$
s         cl
S         ^C
I         ^i
O         ko
############
############
技巧3 以退为进

var foo = "method("+arguement1+","+argument2+")";

操作方法
f+ 跳转到下一个+号所在的位置
s +  删除光标下的字符，然后进入插入模式
; 带我们到下一个目标字符,在gvim里面按；就变成了：还没搞明白是哪里出了问题，
  用macvim试了一下；是可以跳转的

. 重复上次的修改
############
############
技巧4 执行、重复、回退

u 撤销undo
qx{change}q 执行一系列的修改 @x
############
############
技巧5 查找并手动替换
...We're waiting for copy be fore the site can go live...
...If you are content with this, let's go ahead with it...
...We'll launch as soon as we have the copy...

:%s/content/copy/g 把所有的content替换成copy

* 快速查找光标下的单词 /content
n 跳转到下一个查找的单词

############
############
技巧6 认识.范式

在技巧2中使用.替代A;<Esc> 13G跳转到13行
在技巧3中使用.替代s +     27G跳转到27行
在技巧5中使用.替代cwcopy<Esc> 46G跳转到46行

理想模式：用一键移动，另一键执行

范式：从本质上讲是一种理论体系。该体系框架之内的该范式的理论、法则、定律都被
      人们普遍接受







############
############
技巧7 停顿时请移开画笔

1. 普通模式就是Vim的自然放松状态
2. 在普通模式中也有很多工具可以使用，可以复制，移动，删除

############
############
技巧8 把撤销单元切成块

1. 一次修改 i{insert some text}<Esc>
2. 每次撤销操作删除一个单词而不是一个字符
3. 在Vim中，我们可以控制撤销命令的粒度。从进入插入模式开始，直到返回普通模式为止。
4. 如果在插入模式中使用了<up>、<Down>、<Left>或<Right>这些光标键，将会产生一个新的撤销
   块

############
############
技巧9 构造可重复的修改

1. 在Vim中，要完成一件事，不止一种方式
2. 决胜局：哪种方式最具重复性？

The end is nigh
> db x
> b dw
> daw

############
############
技巧10 用次数做简单的算术运算

ctrl + a 加
ctrl + x 减

20

对比操作
1. f0 i-19<Esc>
2. 180<C-x>

.blog {background-position:-180px 0px}  #如果光标不在数字上会自动跳到第一个数字上加减

############
############
技巧11 能够重复，就别用次数

Delete than one word

d2w
2dw
dw.

I have some more questions.

c3wsome more<Esc>

############
############
技巧12 双剑合璧，天下无敌

操作符+动作命令=操作

d{motion}
dl
daw

Vim的语法只有一条额外规则，即当一个操作符命令被连续调用两次时，它会作用
于当前行
dd
>>

Vim的操作符命令
c 修改
d 删除
y 复制到寄存器
g~ 反转大小写
guu 转换为小写
gUU 转换为大写
>  增加缩进
<  减小缩进
!  使用外部程序过滤{motion}所跨越的行

插件：快速注释
https://github.com/tpope/vim-commentary  

注释命令
gcc 注释当前行
gcap 注释当前段
:141,150Commentary
:g/TODO/Commentary

############
############
技巧13 在插入模式中可即时更正错误

<C-h> 删除前一个字符
<C-w> 删除前一个单词
<C-u> 删至行首

这些组合命令也可以用在bash shell中

############
############
技巧14 返回普通模式

<Esc> 切换到普通模式
<C-[> 切换到普通模式
<C-o> 切换到插入-普通模式

<C-o>zz

############
############
技巧15 不离开插入模式，粘贴寄存器中的文本

Practical Vim, by Drew Neil
Read Drew Neil's Practical Vim.

yt,
jA 
<C-r>0
.<ESC>

############
############
技巧16 随时随地做运算

6 chairs, each costing $35, total $210

操作方法
A
<C-r>=6*35<CR>

############
############
技巧17 用字符编码插入非常用字符

Vim接受的字符编码共包含3位数字。例如，假设想插入大写字母“A”，他的字符编码是65，
因此是需要输入<C-v>065

<C-v>u{1234} 插入Unicode基本多文种平面（注意数字前的u）

############
############
技巧18 用二合字母插入非常用字符

<C-k>{char1}{char2}

<C-k>12 ½

:h digraphs-default
:h digraph-table

############
############
技巧19 用替换模式替换已有文本

Typing in Insert mode extends the line, but in Replace mode 
the line length doesn't change.

R 进入替换模式

############
############
技巧20 深入理解可视模式

March

操作
viw
'c'
April

############
############
技巧21 选择高亮选区

可视模式的3个子模式
1. v 激活面向字符的可视模式
2. V 激活面向行的可视模式
3. <C-v> 激活面向列块的可视模式

gv 重选上次的高亮选区

O 切换高亮选区的活动端

Select from here to here.

vbb
o
e

############
############
技巧22 重复执行面向行的可视命令

def fib(n):
    a, b = 0, 1
    while a < n:
        print(a)
        a, b = b, a+b
fib(42)

缩进设置 ➾ :set shiftwidth=4 softtabstop=4 expandtab

Vj
>>

############
############
技巧23 只要可能，最好用操作符命令，而不是可视命令

<a href="#">ONE</a>
<a href="#">TWO</a>
<a href="#">THRee</a>

vit 选择标签里的内容 # visually select inside the tag

<a href="#">one</a>
<a href="#">two</a>
<a href="#">three</a>

vit
U
j.
j.

gU  参见:h gU
it
j.
j.
链接技巧12，操作符+操作命令=操作
gU{motion}


############
############
技巧24 用面向列块的可视模式编辑表格数据

Chapter        |  Page
Normal mode    |    15
Insert mode    |    31
Visual mode    |    44

<C-v>3j  进入列块的可视模式
x...     删除四次
gv       重选上次的高亮选区
r|       |替换空格
yyp      粘贴一份副本行 
Vr-      替换成--------

############
############
技巧25 修改列文本

li.one   a{ background-image:url('/components/sprite.png');}
li.two   a{ background-image:url('/components/sprite.png');}
li.three a{ background-image:url('/components/sprite.png');}

<C-v>jje
`c
components
<Esc>



############
############
技巧26 在长短不一的高亮块后添加文本

var foo = 1;
var bar = 'a';
var foobar = foo + bar;

<C-v>jj$
A;
<Esc>

############
############
技巧27 认识Vim的命令模式

命令模式：Ex命令

读写文件 :edit :write
创建新建标签页 :tabnew
分割窗口 :split
操作参数列表 :prev/:next
缓冲区列表 :bprev/:bnext

复制一行 :copy :t
指定范围内的行做相同的修改 :normal

删除至上个单词的开头 :<C-w>
删除至行首 :<C-u>

############
############

技巧28 在一行或多个连续行上执行命令

<!DOCTYPE html>
<html>
    <head><title>Practical Vim</title></head>
    <body><h1>Practical Vim</h1></body>
</html>

操作演示
➾:355
➾:print

:{start},{end}
行号可以作为地址

符号.表示当前行的地址
➾.,$p

符号%表示当前文件的所有行
➾%p

:%s/Practical/pragmatic/


用高亮选区指定范围
VG
:
:'<,'>
在可视状态下按:键，命令行上会预先填充一个范围:'<,'>

用模式指定范围
:/<html>/,/<\/html>/p

其中{start}地址是模式/<html>/
{end}地址是/<\/html>/

用偏移对地址进行修正
:{address}+n
:.,.+3p

2G
:2

############
############
技巧29 使用':t' 和 ':m'

:copy(简写形式:t)让我们可以把一行或多行从文档的一部分复制到另一部分
:move 可以让我们把一行或多行移到文档的其他地方

购物清单
    -美容院
        -买指甲油
        -买钉子
    -五金店
        -买钉子
        -买新锤子

为了更好的记忆，可以把该命令想成“复制到（copy to）”
:6t. 把第6行复制到当前行下方
:t6  把当前行复制到第6行下方
:t.  把当前行创建一个副本(类似于普通模式下的yyp)
:t$  把当前行复制到文本结尾
:'<,'>t0 把高亮选中的行复制到文件开头

用':m'命令移动行
:[range]move{address}

dGp

############
############
技巧30 在指定范围上执行普通模式命令

var foo = 1;
var bar = 'a';
var baz = 'z';
var foobar = foo + bar;
var foobarbaz = foo + bar + baz;

操作
A;<Esc>
jVG
:'<,'>normal.

############
############
技巧31 重复上次的Ex命令

.命令可以重复上次的普通模式命令
@: 重复上次的Ex命令
@: 重复上次的Ex命令
@: 重复上次的Ex命令

遍历缓冲区列表条目#inbox,技巧37学习一下
:bnext
:bprevious

<C-o>命令会跳转到列表的上条记录

############
############
技巧32 自动补全Ex命令

如同在shell中一样，在命令行上也可以用<Tab>键自动补全命令。
➾ :col<C-d>
<C-d>命令会让Vim显示可用的补全列表，按<Tab>键切换
反向遍历补全列表可以按<S-Tab>

➾ :colorscheme <C-d>

############
############
技巧33 把当前单词插入命令行

var counter:
for (counter=1; counter <= 10; counter++) {
  // do something with counter
    }

操作步骤
*
cwcounter<Esc> #这样操作完之后光标停留在第二个修改好的counter上，再继续下面的命令行
➾ :%s//<C-r><C-w>/g

############
############
技巧34 回溯历史命令

set history=2000

q: 命令行窗口 

J Join 合并多行到一行

write
!python %

操作演示
A |<Esc>
J
:s/write/update

############
############
技巧35 运行Shell命令

用终端vim演示操作
:!ls

:!python %

:shell
pwd
ls
exit

Ctrl-z 挂起作业状态
jobs 查看作业列表
fg 回复挂起前的状态

first name,last name,email
john,smith,john@example.com
drew,neil,drew@vimcasts.org
jane,doe,jane@example.com

操作演示
➾:508,510!sort -t',' -k2

############
############
技巧36 批处理运行Ex命令

如果要执行一连串Ex命令，可以把它们置于脚本之中，从而节省工作量。
当再想执行那一组命令时，只需加载脚本文件即可，而无需逐条输入这些命令。

############
############
技巧37 用缓冲区列表管理打开的文件

操作演示
➾ cd code/files
➾ vim *.txt
➾ :ls
➾ :bnext
➾ :ls

% 符号指明缓冲区在当前窗口中可见
# 符号则代表轮换文件
<C-^>切换文件

:bprev 反向移动
:bnext 正向移动
:bfirst 跳到开头
:blast 跳到结尾
:buffer {bufname} 直接跳转
:bdelete 删除缓冲区

############
############
技巧38 用参数列表将缓冲区分组

参数列表易于管理，适用于对一批文件进行分组，使其更容易访问。
:argdo 可以在参数列表中的每个文件上执行一条Ex命令

:args {arglist}  {arglist}可以保过文件名、通配符，甚至是一条shell命令的输出结果

[] 字符表示当前活动文件

Glob模式       | 匹配的文件
############
############
:args *.*      |  a.txt b.txt
:args **/*.js  |  lib/framework.js app/controllers/Mailer.js
:args **/*.*   |  app.js index.html lib/framework.js lib/theme.css app/controllers/Mailer.js

############
############
技巧39 管理隐藏缓冲区

Vim对被修改过的缓冲区会给予特殊对待，以防未加保存就意外退出

a active 活动缓冲区
h hidden 隐藏缓冲区

+ 表示缓冲区被修改过了

:write 把缓冲区内容写入磁盘
:edit! 把磁盘文件内容读入缓冲区（即回滚所做修改）
:qall! 关闭所有窗口，摒弃修改而无需警告
:wn 逐个保存
:wall! 把所有改变的缓冲区写入磁盘

运行':*do'命令前，启用'hidden'设置

############
############
技巧40 将工作区切分成窗口

创建分割窗口
<C-w>s 水平切分窗口
<C-w>v 垂直切分窗口
可以重复多次

:edit 把另一个缓冲区载入活动窗口中

:sp[lit] {file} 水平切分当前窗口，并在新窗口中载入{file}

:vsp[lit] {file} 垂直切分当前窗口，并在新窗口中载入{file}

窗口间切换
<C-w>w 在窗口间循环切换
<C-w>h 切换到左边的窗口
<C-w>j 切换到下边的窗口
<C-w>k 切换到上边的窗口
<C-w>l 切换到右边的窗口

关闭窗口
:clo[se] <C-w>c 关闭活动窗口
:on[ly] <C-w>o 只保留活动窗口，关闭其他所有窗口

改变窗口大小及重新排列窗口
<C-w>= 使所有窗口等宽、等高
<C-w>_ 最大化活动窗口的高度
<C-w>| 最大化活动窗口的宽度
[N]<C-w>_ 把活动窗口的高度设为[N]行
[N]<C-w>| 把活动窗口的宽度设为[N]列

############
############
技巧41 用标签页将窗口分组

打开及关闭标签页
:tabe[dit] {filename} 在新标签页中打开{filename}
<C-w>T 把当前窗口移到一个新标签页中
:tabc[lose] 关闭当前标签页及其中的所有窗口
:tabo[nly] 只保留活动标签页，关闭所有其他标签页

标签页间切换

Ex命令         |普通模式命令 |
############
############
:tabn[ext] {N} |{N}gt        | 切换到编号为{N}的标签页
:tabn[ext]     |gt           | 切换到下一标签页
:tabp[revious] |gT           | 切换到上一标签页

重排标签页
:tabmove [N] 当N为0时移到开头，省略[N]移到结尾

############
############
技巧42 用:edit命令打开文件

在Vim中，:edit命令允许通过文件的绝对路径或相对路径来打开文件。另外，我们也将学会如何指定一个相对于活动缓冲区的路径

>>相对于当前工作目录打开一个文件
pwd "print workding directory" "打印工作目录"

:edit lib/framework.js

:edit app/controllers/Navigation.js

:edit a<Tab>c<Tab>N<Tab>

>>相对于活动文件目录打开一个文件
假设我们正在编辑app/controllers/Navigation.js，紧接着要编辑同一目录下的Main.js

:edit %<Tab>

:edit %:h<Tab> ":h修饰符会去除文件名，但保留路径中的其他部分（参见:h ::h）。在此例中，输入的%:h<Tab>会被展开为当前文件所在目录的路径。

:edit app/controllers/

:edit %:h <Tab> M <Tab><Tab>

>>轻松展开当前文件所在的目录
把下面的命令加入到vimrc文件
cnoremap <expr> %% getcmdtype( ) == ':' ? expand('%:h').'/' : '%%'

############
############
技巧43 使用:find 打开文件

:find 命令允许通过文件名打开一个文件，但无需输入该文件的完整路径。要想使用此功能，首先要配置'path'选项

操作演示
1. 打开42文件夹
2. vim index.html
3. :find Main.js
4. 报错：E345: Can't find file "Main.js" in path
5. :set path+=app/**

插件'rails.vim'>> https://github.com/tpope/vim-rails

############
############
技巧44 使用netrw管理文件系统

vimrc配置里需要有
1. set nocompatible
2. filetype plugin on

➾ vim .

打开文件管理器
:edit {path}
符号.代表了当前工作目录
:edit . 打开文件管理器，并显示当前工作目录 :e.
:Explore 打开文件管理器，并显示活动缓冲区所在的目录 :E
:Sexplore 水平切分窗口打开文件管理器
:Vexplore 垂直切分窗口打开文件管理器

与分割窗口协同工作
<C-^> 在调出文件管理器后，又想切回到刚才正在编辑的那个文件

使用netrw完成更多功能
:h netrw-% 创建新文件
:h netrw-d 创建新目录
:h netrw-rename 重命名已有的文件及目录 R
:h netrw-del 删除 D

############
############
技巧45 把文件保存到不存在的目录中
操作演示
➾ :edit 46/what.js
➾ :write
➾ :!mkdir -p %:h
➾ :write

############
############
技巧46 以超级用户权限保存文件
操作演示
➾ vim etc/hosts
➾ 编辑内容
➾ :write
➾ :write!
➾ :w !sudo tee % > /dev/null

############
############
技巧47 让手指保持在本位行上

通常只用H和L键盘来解决“差一错误”(off-by-one errors)，只有在距目标差一两个字符时，才会用到这两个键

############
############
技巧48 区分实际行与屏幕行

当‘wrap’设置被启用时，每个超出窗口宽度的文本行都会被回绕显示，以保证没有文本显示不出来

j  向下移动一个实际行
gj 向下移动一个屏幕行
k  向上移动一个实际行
gk 向上移动一个屏幕行
0  移动到实际行的行首
g0 移动到屏幕行的行首
^  移动到实际行的第一个非空白字符
g^ 移动到屏幕行的第一个非空白字符
$  移动到实际行的行尾
g$ 移动到屏幕行的行尾

############
############
技巧49 基于单词移动

w 正向移动到下一单词的开头 for-word
b 反向移动到当前单词/上一单词的开头 back-word
e 正向移动到当前单词/下一单词的结尾
ge 反向移动到上一单词的结尾

ea 命令连用
Go fast
Go faster

理解单词与字串
e.g we're going too slow

word 单词：字母、数字、下画线，或其他非空白字符的序列组成
WORD 字串：非空白字符序列组成

练习
we 改成 you
we're 改成 it's

############
############
技巧50 对字符进行查找

f{char}命令是在vim中移动的最快方式之一。它会在光标位置与当前行行尾之间查找指定的字符，如果找到了，就会把光标移到此字符上；如果未找到，则保持光标不动。


Find the first occurrence of {char} and move to it.

命令
fx
fo

命令
f{char} 正向移动到下一个{char}所在之处
F{char} 反向移动到上一个{char}所在之处
t{char} 正向移动到下一个{char}所在之处的前一个字符上
T{char} 反向移动到上一个{char}所在之处的后一个字符上
; 重复上次的字符查找命令
, 反转方向查到上次的字符查找命令

I've been expecting you.
命令
f,
dt.

Improve your writing by deleting adjectives.

fe daw
fx daw

############
############
技巧51 通过查找进行移动

search for your target
it only takes a moment
to get where you want

移动到takes上
/ta<CR> 用n查找下一个，用N反向查找
/tak<CR>

用查找动作操作文本

This phrase takes time but eventually gets to the point.

按键操作    
v
/ge<CR>
h
d

d/ge<CR>

############
############
技巧52 用精确的文本对象选择选区

var tpl = [
    '<a href="{url}">{title}</a>'
]


按键操作
vi}
a"
i>
it 标签包围的内容
at 标签包围的内容

i "inside"
a "around"

'<a href="{url}">{title}</a>'
指令
ci"#<Esc>
citclick here<Esc>

先寻找合适的目标，瞄准，然后开火
如果说f{char}和/pattern<CR>命令如同单足飞踹，那么文本对象则像一次攻击两个目标的剪刀腿

############
############
技巧53 删除周边，修改内部

文本对象  选择范围
iw        当前单词
aw        当前单词及一个空格
iW        当前字串
aW        当前字串及一个空格
is        当前句子
as        当前句子及一个空格
ip        当前段落
ap        当前段落及一个空行

Improve your writing by deleting excellent adjectives. iiiii

操作演示daw

Improve your writing by deleting most adjectives.

操作演示 ciwmost<Esc>

Type "help", "copyright", "credits" or "license" for more information.

############
############
技巧54 设置位置标记，以便快速跳回

m{a-zA-Z} 命令会用选定的字母标记当前光标所在位置
'{mark} 跳到位置标记所在行，并把光标置于该行第一个非空白字符上
`{mark} 把光标移动到设置此位置标记时光标所在之处，也就是说，它同时恢复行、列的位置

mm 和`m 命令是一对便于使用的命令，他们分别设置位置标记m，以及跳转到该标记。

位置标记   跳转到
``         当前文件中上次跳转动作之前的位置
`.         上次修改的地方
`^         上次插入的地方 会记录上次退出插入模式时光标所在的位置
`[         上次修改或复制的起始位置
`]         上次修改或复制的结束位置
`<         上次高亮选区的起始位置
`>         上次高亮选区的结束位置

############
############
技巧55 在匹配括号间跳转

按键操作   缓冲区内容
{start}    console.log([{'a':1},{'b':2}])
%          console.log([{'a':1},{'b':2}])

{start}    cities = %w{London Berlin New\ York}
dt{        cities = {London Berlin New\ York}
%          cities = {London Berlin New\ York}
r]         cities = {London Berlin New\ York}
``         cities = {London Berlin New\ York}
r[         cities = [London Berlin New\ York]

cities = [London Berlin New\ York]

插件1: matchit.vim
set nocompatible
filetype plugin on
runtime macros/matchit.vim

在HTML文件里，用%可以在开标签和闭标签间跳转
在Ruby文件里，用%可以在class/end、def/end、if/end间跳转

插件2：https://github.com/tpope/vim-surround
安装方式
1. mkdir -p ~/.vim/pack/tpope/start
2. cd ~/.vim/pack/tpope/start
3. git clone https://tpope.io/vim/surround.git
4. vim -u NONE -c "helptags surround/doc" -c q

cs"'    双引号改为单引号
cs'<q>  单引号改为<q>
cst"    <q>改为双引号
ds"     删除双引号
ysiw]   添加中括号
cs]{    中括号改为大括号
yss)    用圆括号包围
ds{ds)  删除外围的括号
ysiw<em> 
S<p class="important">

<p class="import">
<em>Hello</em> World
</p>

############
############
技巧56 遍历跳转列表

<C-o> 命令像后退按钮
<C-i> 命令像前进按钮

:jumps

如果运行:edit命令打开了一个新文件，那么可以用<C-o>和<C-i>命令在这个新文件以及原本的文件之间来回跳转

大范围的动作命令可能会被当成跳转，但小范围的动作命令只能算移动

命令                用途
[count]G            跳转到指定的行号
/pattern<CR>/?pattern<CR>/n/N  跳转到下一个/上一个模式出现之处
%                   跳转到匹配的括号所在之处
(/)                 跳转到上一句/下一句的开头
{/}                 跳转到上一段/下一段的开头
H/M/L               跳到屏幕最上方/正中间/最下方
gf                  跳转到光标下的文件名 '2222.txt'
<C-]>               跳转到光标下关键字的定义之处
'{mark}/`{mark}     跳转到一个位置标记

############
############
技巧57 遍历改变列表

每当对文档做出修改后，Vim都会记录当时光标所在的位置。遍历改变列表的方法很简单，并且这大概是跳到要去的地方的最快方式。

u<C-r> 回到原来修改过的地方

:changes

g;  反向遍历改变列表
g,  正向遍历改变列表

gi 很好用，相当于用'^标记恢复光标位置，并切换到插入模式。jwdm

############
############
技巧58 跳转到光标下的文件

Vim会把文档中的文件名当成一个超链接。正确配置后，就可以用gf命令跳转到光标下的文件了。

指定文件的扩展名
:set suffixesadd+=.py,.txt

gf "go to file" '2222'  'ff.vim' '50/ff'

gf 和 <C-]> 命令像是“虫洞”,它把我们从代码的一个地方传送到另一个地方。

classes('w-2 h-2 m-auto')

指定要搜寻的目录
:set path?
. 代表当前文件所在的目录
空字符串（由两个连着的逗号界定）则代表工作目录
:h 'path'
############
############
技巧59 用全局位置标记在文件间快速跳转

m{letter} 在当前光标位置创建一个位置标记
'{letter} 快速回到标记所在之处

小写字母会创建局部于缓冲区的标记，大写字母则创建全局标记，总共可以设置26个全局标记
无论何时你看到一个地方，之后有可能会想迅速跳回该处，就在那里设个全局标记吧。

打开vimrc文件
按mV设置一个全局标记（助记词V代表vimrc）
切换到另一个文件中按'V
就可以跳回到原来的全局标记处了

############
############
技巧60 用无名寄存器实现删除、复制与粘贴操作
xp 调换光标之后的两个字符
Practical vim
操作方法
F 
x
p

ddp
1) line one
2) line two
3) line three

p命令知道我们正在处理的是一整行文本，因此，如我们所愿，它把无名寄存器的内容粘贴至当前行的下一行。

yyp
1) line one
1) line one
1) line one

collection = getCollection();
process(collection, target);

############
############
技巧61 深入理解Vim寄存器

delete 剪切 
yank   复制
put    粘贴

cut    剪切
copy   复制
paste  粘贴

系统剪贴板("+) 与选择专用寄存器("*)
到目前为止，我们所讨论的寄存器都是Vim内部的。如果想从Vim复制文本到外部程序(反之亦然)，则必须使用系统剪贴板。

"+p 
<C-r>+
粘贴外部内容到Vim内部

"+
将vim内部的内容复制到系统剪贴

"_d{motion} 真正的删除

"ayiw 把当前单词复制到寄存器a中
"bdd  把当前正行文本剪切至寄存器b中

:delete c 把当前行剪切到寄存器c
:put c    将剪切的行粘贴至当前光标所在行 之下

无名寄存器("")
""p 等于 p

x、s、d{motion}、c{motion}、y{motion} 都会覆盖无名寄存器中的内容
缺省:系统默认的状态

复制专用寄存器("0)
collection = getCollection();
process(collection, target);

y{motion}
按键操作
yiw
jww
diw
"0P

有名寄存器("a-"z)

"ad{motion} 剪切
"ay{motion} 复制
"ap         粘贴

collection = getCollection();
process(somethingInTheWay, target);

按键操作
"ayiw
jww
diw
"aP

黑洞寄存器
Vim将删除该文本且不保存任何副本。只想删除文本且不想覆盖无名寄存器中的内容时，此命令很管用。

collection = getCollection();
process(collection, target);

按键操作
yiw
jww
"_diw
P

表达式寄存器("=)
还没看懂

其他寄存器
寄存器
"%       当前文件名
"#       轮换文件名
".       上次插入的文本
":       上次执行的Ex命令
"/       上次查找的模式

Read-only registers ":, ". and "%
These are '%', ':' and '.'. You can use them only with the "p", "P", and ":put" commands and with CTRL-R.

############
############
技巧62 用寄存器中的内容替换高亮选区的文本

collection = getCollection():
process(collection, target);

按键操作
yiw
jww
ve
p

gv 重选上次高亮选区的内容

交换两个词
I like fish and chips.

按键操作
fc
de
mm
ww
ve
p
'm
P

############
############
技巧63 把寄存器的内容粘贴出来

面向行的复制或者删除操作（如dd、yy或者dap），将创建面向行的寄存器。

面向字符的复制或删除操作（如x、diw或者das），则创建面向字符的寄存器。

collection = getCollection();
process(somethingInTheWay, target);

按键操作
yiw
jww
ciw<C-r>0<Esc>

<C-r> 要在插入模式下用

<table>
  <tr>
    <td>Symbol</td>
    <td>Nmae</td>
  </tr>
</table>

<table>
  <tr>
    <td>Symbol</td>
    <td>Nmae</td>
  </tr>
</table>



P和gP命令都工作的很好，但有一点除外，前者会将光标移到被插入进来的文本上方，而gP命令会将光标移到第二段副本的位置，从而让我们可以方便地根据需要进行修改。

############
############
技巧64 与系统剪贴板进行交互

[1,2,3,4,5,6,7,8,9,10].each do |n|
  if n%5==0
  puts "fizz"
  else
  puts n
  end
end

############
############
技巧65 宏的读取与执行
宏允许把一段修改序列录制下来，用于之后的回访。本节将对其细节进行深度剖析。

q "录制" "停止"
q{register} 指定一个用于保存宏的寄存器

foo = 1
bar = 'a'
var foobar = foo + bar;

按键操作
qa
A;<Esc>
Ivar <Esc>
q

查看寄存器a中的内容
:reg a 

@{register} 执行指定寄存器的内容
@@ 重复最近调用过的宏


############
############
技巧66 规范光标位置、直达目标以及中止宏

黄金法则：在录制一个宏时，要确保每条命令都可被重复执行。

在录制宏的过程中，禁止使用鼠标。

可以设置不要出现错误提示  set novisualbell

############
############
技巧67 加次数回放宏

回顾技巧3
如果遇到大范围的更改要怎么办
x = "("+a+","+b+","+c+","+d+","+e+")"

按键操作
f+
s + <Esc>
qq;.q
22@q

############
############
技巧68 在连续的文本行上重复修改

转换前       转换后
1. one       1) One
2. two       2) Two
3. three     3) Three
4. four      4) Four

按键操作
qa  # 开始录制宏到寄存器a
0f. # 跳到开头，寻找 .
r)  # 把 . 替换成 )
w~  # 跳到下一个单词的开头，并把光标下的字符转换成大写
q

操作演示
1) One      
2) Two     
3) Three  
4) Four  

1) One
2) Two
//break up the monotony
3) Three
4) Four

5@a 并不会执行5遍，宏在执行到第3行的时候停了下来

以并行方式执行宏
按键操作
qa
0f.r)w~
q
jVG
:'<,'>normal @a


############
############
技巧69 给宏追加命令
按键操作  |  缓冲区内容|
qa        |  1. one    |
          |  2. two    |
0f.r)w~   |  1) One    |
          |  2. two    |
q         |  1) One    |
          |  2. two    |

查看
➾:reg a

1) One
2. two
按键操作  |  缓冲区内容|
qA        |  1) One    |
          |  2. two    |
j         |  1) One    |
          |  2. two    |
q         |  1) One    |
          |  2. two    |
查看
➾:reg a

############
############
技巧70 在一组文件中执行宏

1. 把rc.vim的配置放到启动配置中
2. 用vim打开animal.rb
3. 用:args *.rb打开所有后缀是rb的文件

set nocompatible
filetype plugin indent on
set hidden
if has("autocmd")
  autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
endif

操作指令
qa
gg/class<CR>
Omoudle Rank<Esc>
j>G
Goend<Esc>
q

以并行方式执行此宏

➾ :edit!  # 放弃针对第一个缓冲区所做的所有修改
➾ :argdo normal @a # 做所有缓冲区中同时执行宏

以串行方式执行宏
qA
:next
q
22@a

➾ :wall # 保存所有文件的改动

############
############
技巧71 用迭代求值的方式给列表编号

partridge in a pear tree
turtle doves
French hens
calling birds
golden rings

1) partridge in a pear tree
2) turtle doves
3) French hens
4) calling birds
5) golden rings

参考技巧16 表达式寄存器进行简单的求和运算

按键操作
:let i=1
qa
I<C-r>=i<CR>) <Esc>
:let i += 1
q

执行宏
jVG
:'<,'>normal @a

############
############
技巧72 编辑宏的内容

问题: 非标准格式
1) One
2. Two
3. three
4. four

将宏粘贴到文档中
➾ :put a


0f.r)wvUj

编辑宏

开始：0f.r)w~j

按键操作
f~
svU<Esc>

处理后：0f.r)wvUj

将文档复制回寄存器
:d a
"add 

^J 表示换行符

为了保险起见，用面向字符的复制操作把这些字符从文档复制回寄存器更安全
按键操作
0
"ay$
dd


第五部分
模式

############
############
技巧73 调整查找模式的大小写敏感性

全局设置大小写敏感性
➾ :set ignorecase
如果启用'ignorecase'设置，Vim的查找模式将不区分大小写

➾ :set smartcase 如果模式全是由小写字母组成的，就会按照忽略大小写的方式查找，但只要输入一个大写字母，查找方式就会变成区分大小写的了。

\c 会让查找模式忽略大小写
\C 会强制区分大小写

before foo Foo FOO


############
############
技巧74 按正则表达式查找时，使用\v模式开关

body   { color: #3c3c3c; }
a      { color: #0000EE; }
strong { color: #000; }

➾ /#\([0-9a-fA-F]\{6}\|[0-9a-fA-F]\{3}\)

➾ /\v#([0-9a-fA-F]{6}|[0-9a-fA-F]{3})

➾ /\v#(\x{6}|\x{3})

\v模式开关来统一所有特殊符号的规则
即假定除_、大小写字母以及数字0~9之外的所有字符都具有特殊含义

\x 代替完整字符集[0-9a-fA-F] 参考:h /character-classes

############
############
技巧75 按原义查找文本时，实用\V原义开关

\V 可以消除附加在 . \ * ? 等大多数字符号上的特殊含义

. 具有特殊含义，它匹配任意字符


############
############
技巧76 使用圆括号捕获子匹配

专门用来匹配重复单词的正则表达式
➾ /\v<(\w+)\_s+\1>
➾

vipJ 将两行文本连接起来 

############
############
技巧77 界定单词的边界

在very magic搜索模式下，用<与>符号表示单词定界符。
因此，如果将查找命令改为/\v<the><CR>，稳重就只会出现一处匹配了。

查看查找历史 按/<UP>


############
############
技巧78 界定匹配的边界

元字符\zs 标志着一个匹配的起始 zero start
元字符\ze 界定匹配的结束       zero end

############
############
技巧79 转义问题字符

正向查找
"uyi[

/\V<C-r>u<CR>

反向查找用 ? 号

用编程的方式转义字符
:h escape()

输入/
\V
<C-r>=
➾ =escape(@u, getcmdtype().'\')


############
############
技巧80 结识查找命令

如果只想在当前光标位置至文档结尾的范围内查找，而不想绕回文档继续查找的话，可以关闭'wrapscan'选项

/ 正向查找
? 反向查找
n 跳至下一出匹配，保持查找方向与偏移不变
N 跳至上一处匹配，保持查找方向与偏移不变
/<CR> 正向跳转至相同模式的下一出匹配
?<CR> 反向跳转至相同模式的上一处匹配
gn 进入面向字符的可视模式，并选中下一出匹配
gN 进入面向字符的可视模式，并选中上一处匹配
参照技巧84

############
############
技巧81 高亮查找匹配

set hlsearch 高亮显示 high light search 
set nohlsearch 取消高亮显示

############
############
技巧82 在执行查找前预览第一处匹配

incsearch 根据已在查找域中输入的文本，预览第一处匹配

The car was the color of a carrot.

根据预览结果对查找域自动补全
<C-r><C-w>

############
############
技巧83 将光标偏移到查找匹配的结尾

search-offset

aim to learn a new programming lang each year.
which lang did you pick up last year?
which langs would you like to learn?

第一种方法
:%s/lang/language/g

第二种方法
/lang<cr>
eauage<esc>
ne.
这个方法有点问题

第三种方法
/lang/e<CR>
auage<Esc>
n
.
n.



############
############
技巧84 对完整的查找匹配进行操作

gU{motion} 将指定文本转换成大写

gn 对下一处匹配进行操作，动作命令

/\vX(ht)?ml\C<CR> 构造一个正则表达式

gUgn 会把匹配的文本转换为大写

➾ /\vX(ht)?ml\C<CR>
➾ gUgn
➾ n
➾ .
➾ n.
➾ .


############
############
技巧85 利用查找历史，迭代完成复杂的模式
q/ 调出命令行窗口

1. 粗略匹配
➾ /\v'.+'

2.逐步求精
➾ /\v'[^']+'
上面的理解[^'] 是匹配除了'之外的任意字符

3.精益求精
➾ /\v'([^']|'\w)+'
➾ /\v'(([^']|'\w)+)'

4.画上完美句号
➾ :%s//"\1"/g

结论，上面分解的命令等同于如下的命令
➾ :%s/\v'(([^']|'\w)+)'/"\1"/g

修改命令行窗口的按键操作
按键操作            缓冲区内容
{start}             \v'[^']+'
f[                  \v'[^']+'
c%(<C-r>")<Esc>     \v'([^'])+'
i|'\w<Esc>          \v'([^']|'\w)+'

############
############
技巧86 统计当前模式的匹配个数

1. 用':substitute' 命令统计匹配总数
➾ /\<buttons\>
➾ :%s///gn

2. 用':vimgrep'命令统计匹配总数
➾ /\<buttons\>
➾ :vimgrep //g %
➾ :cnext
➾ :cprev

知识点quickfix列表➾第17章会学到 

模式域
替换域

############
############
技巧87 查找当前高亮选区中的文本

在可视模式下查找当前单词
She sells sea shells by the sea shore.
she

############
############
技巧88 认识substitute命令

substitute命令允许先查找一段文本，再用另一段文本将其替换掉。
命令的语法如下：
:[range]s[ubstitute]/{pattern}/{string}/[flags]

标志位
g  全局范围内执行，修改一行内的所有匹配 参考技巧89
c  确认或拒绝每一处修改 参考技巧90
n  抑制正常的替换行为 参考技巧86

符号  描述
\r    插入一个换行符
\t    插入一个制表符
\\    插入一个返斜杠
\1    插入第1个子匹配
\2    插入第2个子匹配
\0    插入匹配模式的所有内容
&     插入匹配模式的所有内容
~     使用上一次调用:substitute时的{string}
\={Vim script}  执行{Vim Script}表达式；并将返回的结果作为替换{string}


############
############
技巧89 在文件范围内查找并替换每一处匹配
:s/going/rolling
:s/going/rolling/g
:%s/going/rolling/g

############
############
技巧90 手动控制每一次替换操作

➾ :%s/content/copy/gc

答案    用途
y       替换此处匹配
n       忽略此处匹配
q       退出替换过

############
############
技巧91 重用上次的查找模式

将substitute命令的查找域留空，意味着Vim将会重用上次的查找模式
<C-r>/ 可以把上次查找的内容粘贴进来

############
############
技巧92 用寄存器的内容替换
➾:%s/Pragmatic Vim/Practical Vim/g
➾:let @/='DDD'
➾:let @a='LLL'
➾:%s//\=@a/g

############
############
技巧93 重复上一次substitute命令

g&
➾ :%s//~/&

1. {start}
2. Vjj
3. yP
4. :%s/Name/Number/g
5. u
6. gv
7. :'<,'>&&

############
############
技巧94 使用子匹配重排CSV文件的字段

last name,first name,email
neil,drew,drew@vimcasts.org
doe,john,john@example.com

➾ /\v^([^,]*),([^,]*),([^,]*)$
➾ :%s//\3,\2,\1

\1表示姓氏
\2表示名字
\3表示电子邮箱


############
############
技巧95 在替换过程中执行算术运算

<h2>Heading number 1</h2>
<h3>Number 2 heading</h3>
<h4>Another heading</h4>

➾ /\v\<\/?h\zs\d
➾ :%s//\=submatch(0)-1/g

############
############
技巧96 交换两个或更多的单词
➾ :let swapper={"dog":"man", "man":"dog"}
➾ :echo swapper["dog"]
➾ :echo swapper["man"]
➾ /\v(<man>|<dog>) #此模式可以匹配单词"man"或单词"dog"
➾ :%s//\={"dog":"man","man":"dog"}[submatch(1)]/g


############
############
技巧97 在多个文件中执行查找与替换

➾ /Pragmatic\ze Vim
➾ :vimgrep // **/*.txt
➾ :cfdo %s//Practical/gc
➾ :cfdo update


############
############
技巧98 认识global命令
:global 命令的作用范围是整个文件


############
############
技巧99 删除所有包含模式的文本行
将:global命令与:delete命令一起组合使用，可以快速裁剪文件内容。

用':g/re/d'删除所有的匹配行
➾ /\v\<\/?\w+>
➾ :g//d

➾ :v/href/d 
############
############
技巧100 将TODO项收集至寄存器
通过把:global和:yank这两条命令结合在一起，可以把所有匹配{pattern}的文本进行收集到某个寄存器中

窍门：用大写字母A引用寄存器。这意味着Vim将把内容附加到指定的寄存器，用小写字母a的话，则会覆盖原有寄存器的内容
➾ :g/TODO
➾ qaq #将a寄存器清空
➾ :reg a
➾ :g/TODO/yank A
➾ :reg a
➾ :g/TODO/t$

############
############
技巧101 将CSS文件中所有规则的属性按照字母排序

操作
➾ vi{
➾ :'<,'>sort
会出错

➾ :g/{/ .+1,/}/-1 sort
############
