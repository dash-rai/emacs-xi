;; xi.el - (c) munshkr@gmail.com, 2017, based heavily on...
;; tidal.el - (c) alex@slab.org, 2012, based heavily on...
;; hsc3.el - (c) rohan drape, 2006-2008

;; notes from hsc3:
;; This mode is implemented as a derivation of `haskell' mode,
;; indentation and font locking is courtesy that mode.  The
;; inter-process communication is courtesy `comint'.  The symbol at
;; point acquisition is courtesy `thingatpt'.  The directory search
;; facilities are courtesy `find-lisp'.

(require 'scheme)
(require 'comint)
(require 'thingatpt)
(require 'find-lisp)
(require 'pulse)

(defvar xi-buffer
  "*xi*"
  "*The name of the Xi process buffer (default=*xi*)")

(defvar xi-interpreter
  "xi"
  "*The Xi interpeter to use (default=xi)")

(defvar xi-interpreter-arguments
  '()
  "*Arguments to the Xi interpreter (default=none)")

(defun xi-start ()
  "Start Xi"
  (interactive)
  (if (comint-check-proc xi-buffer)
      (error "A Xi process is already running"))
  (apply 'make-comint
         "xi"
         xi-interpreter
         nil
         xi-interpreter-arguments)
  (xi-see-output))

(defun xi-quit ()
  "Quit Xi"
  (interactive)
  (kill-buffer xi-buffer)
  (delete-other-windows))

(defun xi-interrupt ()
  (interactive)
  (unless (comint-check-proc xi-buffer)
    (error "No Xi process running?"))
  (with-current-buffer xi-buffer
    (interrupt-process (get-buffer-process (current-buffer)))))

(defun xi-see-output ()
  "Show Xi output"
  (interactive)
  (unless (comint-check-proc xi-buffer)
    (error "No Xi process running?"))
  (delete-other-windows)
  (split-window-vertically)
  (with-current-buffer xi-buffer
    (let ((window (display-buffer (current-buffer))))
      (select-window window)
      (shrink-window 6)
      (goto-char (point-max))
      (save-selected-window
        (set-window-point window (point-max))))))

;; TODO
(defun xi-help ()
  "Lookup up the name at point in the Help files"
  (interactive)
  (mapc (lambda (filename)
          (find-file-other-window filename))
        (find-lisp-find-files xi-help-directory
                              (concat "^"
                                      (thing-at-point 'symbol)
                                      "\\.help\\.lhs"))))

(defun xi-send-string (s)
  (unless (comint-check-proc xi-buffer)
    (error "No Xi process running?"))
  (comint-send-string xi-buffer (concat s "\n")))

(defun xi-run-line ()
  "Send the current line to the interpreter"
  (interactive)
  (let ((s (buffer-substring (line-beginning-position)
                             (line-end-position))))
    (xi-send-string s))
  (pulse-momentary-highlight-one-line (point)))

(defun xi-run-multiple-lines ()
  "Send the current paragraph to the interpreter"
  (interactive)
  (save-excursion
    (mark-paragraph)
    (let ((s (buffer-substring-no-properties (region-beginning)
                                             (region-end))))
      (xi-send-string s)
      (mark-paragraph)
      (pulse-momentary-highlight-region (mark) (point)))))

(defun xi-run-region ()
  "Send the current region to the interpreter"
  (interactive)
  (xi-send-string
   (buffer-substring-no-properties (region-beginning) (region-end))))

(defun xi-load-buffer ()
  "Load the current buffer"
  (interactive)
  (save-buffer)
  (xi-send-string (format "load \"%s\"" buffer-file-name)))

(defvar xi-mode-map nil
  "Xi keymap")

(defun xi-mode-keybindings (map)
  "Xi keybindings"
  (define-key map [?\C-c ?\C-s] 'xi-start)
  (define-key map [?\C-c ?\C-v] 'xi-see-output)
  (define-key map [?\C-c ?\C-q] 'xi-quit)
  (define-key map [?\C-c ?\C-c] 'xi-run-line)
  (define-key map [?\C-c ?\C-e] 'xi-run-multiple-lines)
  (define-key map (kbd "<C-return>") 'xi-run-multiple-lines)
  (define-key map [?\C-c ?\C-r] 'xi-run-region)
  (define-key map [?\C-c ?\C-l] 'xi-load-buffer)
  (define-key map [?\C-c ?\C-i] 'xi-interrupt)
  (define-key map [?\C-c ?\C-h] 'xi-help))

(defun turn-on-xi-keybindings ()
  "Xi keybindings in the local map"
  (local-set-key [?\C-c ?\C-s] 'xi-start)
  (local-set-key [?\C-c ?\C-v] 'xi-see-output)
  (local-set-key [?\C-c ?\C-q] 'xi-quit)
  (local-set-key [?\C-c ?\C-c] 'xi-run-line)
  (local-set-key [?\C-c ?\C-e] 'xi-run-multiple-lines)
  (local-set-key (kbd "<C-return>") 'xi-run-multiple-lines)
  (local-set-key [?\C-c ?\C-r] 'xi-run-region)
  (local-set-key [?\C-c ?\C-l] 'xi-load-buffer)
  (local-set-key [?\C-c ?\C-i] 'xi-interrupt)
  (local-set-key [?\C-c ?\C-h] 'xi-help))

(defun xi-mode-menu (map)
  "Xi menu"
  (define-key map [menu-bar xi]
    (cons "Xi" (make-sparse-keymap "Xi")))
  (define-key map [menu-bar xi help]
    (cons "Help" (make-sparse-keymap "Help")))
  (define-key map [menu-bar xi expression]
    (cons "Expression" (make-sparse-keymap "Expression")))
  (define-key map [menu-bar xi expression load-buffer]
    '("Load buffer" . xi-load-buffer))
  (define-key map [menu-bar xi expression run-region]
    '("Run region" . xi-run-region))
  (define-key map [menu-bar xi expression run-multiple-lines]
    '("Run multiple lines" . xi-run-multiple-lines))
  (define-key map [menu-bar xi expression run-line]
    '("Run line" . xi-run-line))
  (define-key map [menu-bar xi repl]
    (cons "REPL" (make-sparse-keymap "REPL")))
  (define-key map [menu-bar xi repl quit]
    '("Quit" . xi-quit))
  (define-key map [menu-bar xi repl see-output]
    '("See output" . xi-see-output))
  (define-key map [menu-bar xi repl start]
    '("Start" . xi-start)))

(if xi-mode-map
    ()
  (let ((map (make-sparse-keymap "Xi")))
    (xi-mode-keybindings map)
    (xi-mode-menu map)
    (setq xi-mode-map map)))

(define-derived-mode
  xi-mode
  ruby-mode
  "Xi"
  "Major mode for interacting with a Xi process"
  (set (make-local-variable 'paragraph-start) "\f\\|[ \t]*$")
  (set (make-local-variable 'paragraph-separate) "[ \t\f]*$")
  (turn-on-font-lock))

(add-to-list 'auto-mode-alist '("\\.xi" . xi-mode))

(provide 'xi)
