(add-to-list 'load-path (expand-file-name "~/site-lisp"))
(add-to-list 'load-path (expand-file-name "~/site-lisp/tuareg-mode"))
(add-to-list 'load-path (expand-file-name "~/site-lisp/lilypond"))

(require 'color-theme)
(color-theme-initialize)
(color-theme-dark-laptop)
(set-frame-parameter nil 'alpha 80)

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

(add-hook 'ruby-mode-hook #'(lambda () (define-key ruby-mode-map "\C-c\C-c" 'compile)))
(add-hook 'prolog-mode-hook #'(lambda () (define-key prolog-mode-map "\C-c\C-c" 'compile)))

;; ハードタブを使わない
;;(setq indent-tabs-mode nil)

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

(defvar navigate-point-list (cons (list) (list)))
(defvar navigate-point-hook-list nil)

(setq navigate-point-list (cons '() '()))

navigate-point-list

(defun navigate-point-go-forward (zip)
  (let* ((prev-list (car zip))
         (next-list (cdr zip)))
    (let ((p (car next-list)))
      (if p
          (progn
            (setcar zip (cons p prev-list))
            (setcdr zip (cdr next-list))))
      p)))

(defun navigate-point-go-prev (zip)
  (let* ((prev-list (car zip))
         (next-list (cdr zip)))
    (let ((p (car prev-list)))
      (if p
          (progn
            (setcar zip (cdr prev-list))
            (setcdr zip (cons p next-list))))
      p)))

(defun navigate-point-add-marker (zip marker)
  (let* ((prev-list (car zip))
         (next-list (cdr zip)))
    (progn
      (setcar zip (cons marker prev-list))
      (dolist (x next-list) (if x (set-marker x nil)))
      (setcdr zip nil))))

(defun navigate-point-insert-point ()
  (interactive)
  (let ((p (point-marker)))
    (unless (equal (caar navigate-point-list) p)
      (navigate-point-add-marker navigate-point-list (point-marker))
      (message "Current saved"))))


(defun navigate-point-jump-next-point ()
  (interactive)
  (let ((next-point (navigate-point-go-forward navigate-point-list)))
    (if next-point
        (progn
          (switch-to-buffer (marker-buffer next-point))
          (goto-char (marker-position next-point)))
      (message "No next point"))))

(defun navigate-point-jump-prev-point ()
  (interactive)
  (progn
    (unless (cdr navigate-point-list) (navigate-point-insert-point))
    (let ((prev-point (navigate-point-go-prev navigate-point-list)))
      (if prev-point
          (progn
            (switch-to-buffer (marker-buffer prev-point))
            (goto-char (marker-position prev-point)))
        (message "No prev point")))))

(defun navigate-point-pre-command-hook ()
  (unless (or (eq this-command 'navigate-point-jump-prev-point)
              (eq this-command 'navigate-point-jump-next-point)
              (eq this-command 'navigate-point-insert-point))
    (if (memq this-command navigate-point-hook-list)
        (navigate-point-insert-point))))

(setq navigate-point-hook-list '(isearch-forward isearch-backward beginning-of-buffer end-of-buffer switch-to-buffer next-error mouse-1))

(global-set-key [f5] 'navigate-point-insert-point)
(global-set-key [M-right] 'navigate-point-jump-next-point)
(global-set-key [M-left] 'navigate-point-jump-prev-point)
(add-hook 'pre-command-hook 'navigate-point-pre-command-hook)


;; Rinari

(require 'ido)
(ido-mode t)

(add-to-list 'load-path "~/site-lisp/rinari")
(require 'rinari)

(add-to-list 'load-path "~/site-lisp/rhtml")
(require 'rhtml-mode)
(add-hook 'rhtml-mode-hook
          (lambda () (rinari-launch)))
