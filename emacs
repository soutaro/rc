(add-to-list 'load-path (expand-file-name "~/site-lisp"))
(add-to-list 'load-path (expand-file-name "~/site-lisp/tuareg-mode"))
(add-to-list 'load-path (expand-file-name "~/site-lisp/lilypond"))

(require 'color-theme)
(color-theme-initialize)
(color-theme-dark-laptop)
(set-frame-parameter nil 'alpha 90)

;; auto-save-buffers
(require 'auto-save-buffers)
(run-with-idle-timer 0.5 t 'auto-save-buffers)

;; auto-save-buffersしているので、バックアップファイルは無意味
(setq make-backup-files nil)

;; tuareg-mode
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)

(setq auto-mode-alist 
      (append '(("\\.ml[ily]?$" . tuareg-mode)
		("\\.topml$" . tuareg-mode))
	      auto-mode-alist))

(autoload 'lilypond-mode "lilypond-init" "Lilypond mode" t)
;; (setq auto-mode-alist 
;;       (append '(("\\.ly$" . lilypond-mode)) auto-mode-alist))
(add-to-list 'auto-mode-alist '("\\.ly$" . lilypond-mode))

;; hungry-delete
(defun hungry-backspace (arg)
  "Deletes preceding character or all whitespaces."
  (interactive "*P")
  (let ((here (point)))
    (skip-chars-backward " \t")
    (if (/= (point) here)
        (delete-region (point) here)
      (delete-backward-char 1))))

(defun hungry-delete (arg)
  "Deletes following character or all white spaces."
  (interactive "*P")
  (let ((here (point)))
    (skip-chars-forward " \t\n")
    (if (/= (point) here)
	(delete-region (point) here)
      (delete-char 1))))

(defun hungry-keyboard (map)
  (define-key map [backspace] 'hungry-backspace)
  (define-key map [delete] 'hungry-delete)
  (define-key map "\C-d" 'hungry-delete)
  (setq indent-tabs-mode nil))

;; 適当にhungry-keyboardする
(add-hook 'lisp-mode-hook #'(lambda () (hungry-keyboard lisp-mode-map)))
(add-hook 'emacs-lisp-mode-hook #'(lambda () (hungry-keyboard emacs-lisp-mode-map)))
(add-hook 'tuareg-mode-hook #'(lambda () (hungry-keyboard tuareg-mode-map)))
(add-hook 'ruby-mode-hook #'(lambda () (hungry-keyboard ruby-mode-map)))
(add-hook 'rhtml-mode-hook #'(lambda () (hungry-keyboard rhtml-mode-map)))
(add-hook 'c-mode-hook #'(lambda () (hungry-keyboard c-mode-map)))
(add-hook 'js-mode-hook #'(lambda () (hungry-keyboard js-mode-map)))
(add-hook 'haml-mode-hook #'(lambda () (hungry-keyboard haml-mode-map)))

(add-hook 'ruby-mode-hook #'(lambda () (define-key ruby-mode-map "\C-c\C-c" 'compile)))
(add-hook 'prolog-mode-hook #'(lambda () (define-key prolog-mode-map "\C-c\C-c" 'compile)))

(add-hook 'yaml-mode-hook #'(lambda () (setq indent-tabs-mode nil)))

;; ハードタブを使わない
(setq indent-tabs-mode nil)

;; dabbrevはCtrl-oで
(global-set-key "\C-o" 'dabbrev-expand)

;; 対応する括弧を強調
(show-paren-mode)

;; リージョンを表示
(transient-mark-mode 1)

;; ツールバーを消す
(tool-bar-mode)

;; AUCTeX
;;(setq TeX-default-mode 'japanese-latex-mode)
;;(setq japanese-LaTeX-command-default "pLaTeX")
(setq TeX-default-mode 'japanese-latex-mode)
(setq japanese-TeX-command-default "pTeX")
(setq japanese-LaTeX-command-default "pLaTeX")
(setq japanese-LaTeX-default-style "jsarticle")

;;(TeX-source-specials-mode 1)
;;(setq tex-dvi-view-command "open")
(setq-default TeX-master nil) ; Query for master file.

(server-start)

;; フォント
(require 'carbon-font)
(fixed-width-set-fontset "hiramaru" 10)


;; max-window
;;(mac-toggle-max-window)
(defun toggle-fullscreen()
  (interactive)
  (set-frame-parameter nil
                       'fullscreen
                       (if (frame-parameter nil 'fullscreen)
                           nil 'fullboth)))
(global-set-key [f7] 'toggle-fullscreen)


(require 'ottmode)

(require 'navigate-point)

(setq navigate-point-hook-list '(isearch-forward isearch-backward beginning-of-buffer end-of-buffer switch-to-buffer next-error mouse-1))

(global-set-key [f6] 'navigate-point-clear-points)
(global-set-key [f5] 'navigate-point-insert-point)
(global-set-key [M-right] 'navigate-point-jump-next-point)
(global-set-key [M-left] 'navigate-point-jump-prev-point)



;; Rinari

(require 'ido)
(ido-mode t)

(add-to-list 'load-path "~/site-lisp/rinari")
(require 'rinari)

(add-to-list 'load-path "~/site-lisp/rhtml")
(require 'rhtml-mode)
(add-hook 'rhtml-mode-hook
          (lambda () (rinari-launch)))

;; http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-list/40997

(require 'compile)
(add-to-list 'compilation-error-regexp-alist
             '(".+\\[\\([^ ]+\\):\\([0-9]+\\)\\]:" 1 2))


(require 'haml-mode)

(global-set-key "\C-x\C-i" 'indent-region)