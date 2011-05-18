(defvar navigate-point-list (cons (list) (list)))
(defvar navigate-point-hook-list nil)
(defvar navigate-point-list (cons '() '()))

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

(defun navigate-point-clear-points ()
  (interactive)
  (setq navigate-point-list (cons '() '()))
  )

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
              (eq this-command 'navigate-point-insert-point)
              (eq this-command 'navigate-point-pre-command-hook))
    (if (memq this-command navigate-point-hook-list)
        (progn
          (message ">>> %s" this-command)
          (navigate-point-insert-point)))))

(add-hook 'pre-command-hook 'navigate-point-pre-command-hook)

(provide 'navigate-point)
