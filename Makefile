install:
	ln -sf `pwd`/zshrc ~/.zshrc
	ln -sf `pwd`/zsh_env ~/.zsh_env
	ln -sf `pwd`/site-lisp ~/site-lisp
	ln -sf `pwd`/emacs ~/.emacs

rinari:
	cd site-lisp; git clone http://github.com/eschulte/rinari.git
	cd site-lisp/rinari; git submodule init; git submodule update
	cd site-lisp; git clone http://github.com/eschulte/rhtml.git