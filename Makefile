install:
	ln -sf `pwd`/zshrc ~/.zshrc
	ln -sf `pwd`/zsh_env ~/.zsh_env
	ln -sf `pwd`/site-lisp ~/site-lisp
	ln -sf `pwd`/emacs ~/.emacs

rinari:
	git clone git@github.com:soutaro/home-search.git
	cd rinari; git submodule init; git submodule update
	git clone http://github.com/eschulte/rhtml.git