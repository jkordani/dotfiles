(require 'package)

(add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/") t)

(package-initialize)

(setq custom-file (expand-file-name "~/.customizations.el"))
(load custom-file)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun auto-ask-install ()
  (interactive)
  (when (yes-or-no-p (format "Try to install %d packages?"
                             (length package-selected-packages)))
    (package-refresh-contents)
    (mapc (lambda (package)
            (unless (package-installed-p package)
              (package-install package)))
          package-selected-packages)))

;; (defadvice package-install-selected-packages (around auto-confirm compile activate)
;;   (cl-letf (((symbol-function 'yes-or-no-p) (lambda (&rest args) t))
;;             ((symbol-function 'y-or-n-p) (lambda (&rest args) t)))
;;            ad-do-it))


;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install-selected-packages))

(avy-setup-default)
(global-set-key (kbd "C-c C-j") 'avy-resume)

;; It will bind, for example, avy-isearch to C-' in isearch-mode-map, so that you can select one of the currently visible isearch candidates using avy.

(global-set-key (kbd "C-:") 'avy-goto-char)
(global-set-key (kbd "M-g g") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)
(global-set-key (kbd "M-g e") 'avy-goto-word-0)

;; (load (expand-file-name "~/quicklisp/slime-helper.el"))
;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "~/Code/ccl-dev/lx86cl64")



(setq query-dbxml-pipeline "/home/jkordani/lib/db-xml/pipeline.pl")

(defun query-dbxml-with-region (beg end)
  "Query dbxml with selected text"
  (interactive "*r")
  (let ((newbuffer nil)
        (buffer (get-buffer "result"))
        (xquery (buffer-substring beg end)))
    (setq dbxml-result
          (cond
           ((buffer-live-p buffer) buffer)
           (t (setq newbuffer t) (generate-new-buffer "result"))))
    (with-current-buffer dbxml-result
      (with-timeout
          (10 (insert "Gave up because query was taking too long."))
        (erase-buffer)
        (insert (query-dbxml xquery t)))
      (nxml-mode)
      (format-xml)
      (goto-char (point-min))
      (when newbuffer (switch-to-buffer (current-buffer))))))

(defun query-dbxml (xquery &optional timed)
                           "Query the Momentum Berkeley DBXML database with an XQuery string"
                           (let ((file (make-temp-file "elisp-dbxml-")))
                             (write-region xquery nil file)
                             (let ((result (shell-command-to-string
                                              (concat "cat " file " | " query-dbxml-pipeline))))
                               (delete-file file)
                               (concat
                                (if timed (format "%.3f seconds\n\n" (car result)) nil)
                                (cadr result)))))

;; (global-set-key (kbd "<C-S-return>") 'query-dbxml-with-region)
(global-set-key (kbd "<C-S-return>") 'set-mark-command)

(load "/home/jkordani/quicklisp/clhs-use-local.el" t)

(recentf-mode 1)

;; Cleanup the recent files list and synchronize it every 60 seconds.
(setq recentf-auto-cleanup 60)
(setq recentf-max-menu-items 250)
(setq recentf-max-saved-items 250)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(setq-default indent-tabs-mode nil)

(setq elpy-rpc-python-command "python3.8")

(defun insert-current-date () (interactive)
       (insert (shell-command-to-string "echo -n $(date +%Y-%m-%d%z)")))
(defun insert-current-time () (interactive)
       (insert (shell-command-to-string "echo -n $(date +%H:%M%z)")))
(defun insert-current-time-seconds () (interactive)
       (insert (shell-command-to-string "echo -n $(date +%H:%M:%S%z)")))
(defun insert-current-time-seconds-utc () (interactive)
       (insert (shell-command-to-string "echo -n $(date -u +%H:%M:%S%z)")))
(defun insert-log-entry-utc () (interactive)
       (let ((datetime (format-time-string "%FT%T%z" nil t)))
         (insert (format "%s %s\n" datetime (read-from-minibuffer (format "%s: " datetime))))))

(global-set-key (kbd "C-c d") 'insert-current-date)
(global-set-key (kbd "C-c t") 'insert-current-time)
(global-set-key (kbd "C-c T") 'insert-current-time-seconds)
;; (global-set-key (kbd "C-c u") 'insert-current-time-seconds-utc)
(global-set-key (kbd "C-c u") 'insert-log-entry-utc)
;; (require 'eglot)
;; (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
;; (add-hook 'c-mode-hook 'eglot-ensure)
;; (add-hook 'c++-mode-hook 'eglot-ensure)

;; (require 'rtags)
;; (require 'company)
;; (require 'flycheck-rtags)

;; (add-hook 'after-init-hook #'global-flycheck-mode)

;; (setq rtags-completions-enabled t)
;; (push 'company-rtags company-backends)
;; (global-company-mode)
;; (define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))

;; (rtags-enable-standard-keybindings)

;; (setq rtags-autostart-diagnostics t)
;; (defun my-flycheck-rtags-setup ()
;;   (flycheck-select-checker 'rtags)
;;   (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
;;   (setq-local flycheck-check-syntax-automatically nil))
;; (add-hook 'c-mode-hook #'my-flycheck-rtags-setup)
;; (add-hook 'c++-mode-hook #'my-flycheck-rtags-setup)
;; (add-hook 'objc-mode-hook #'my-flycheck-rtags-setup)

;; https://emacs-lsp.github.io/lsp-mode/page/performance/
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

;; https://www.reddit.com/r/emacs/comments/l0huvz/how_do_you_solve_merge_conflicts/
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(defun ask-before-closing ()
  "Prompt for confirmation for emacsclient(not daemon) like 'confirm-kill-emacs' for running Emacs without daemon."
  (interactive)
  (if (y-or-n-p (format "Really exit Emacs? "))
          (save-buffers-kill-terminal)
        (message "Canceled frame close!")))

(when (daemonp)
  (global-set-key (kbd "C-x C-c") 'ask-before-closing))

(setq confirm-kill-emacs #'y-or-n-p)

;; (require 'makefile-mode)
(add-to-list 'auto-mode-alist '(".*[Mm]akefile\..*\\'" . makefile-mode))

;; (require 'sh-mode)
(add-to-list 'auto-mode-alist '(".*env\..*\\'" . sh-mode))

;; (require 'octave-mode)
;; (add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))

(require 'cl-lib)

(require 'nxml-mode)
(add-to-list 'auto-mode-alist '("\\.launch\\'" . nxml-mode))

(require 'flymake-shellcheck)
(add-hook 'sh-mode-hook 'flymake-mode)
(add-hook 'sh-mode-hook 'flymake-shellcheck-load)

(require 'yasnippet)
(yas-global-mode 1)

(require 'eglot)
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd" "-j=6" "--header-insertion=iwyu" "--clang-tidy" "--suggest-missing-includes" "--recovery-ast=true"))
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'c-mode-common-hook
          (lambda ()
            (define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))))

(require 're-builder)
(setq reb-re-syntax 'string)

(require 'magit)
(add-hook 'magit-mode-hook 'magit-svn-mode)

;; (require 'slime)
;; (add-hook 'slime-repl-mode-hook 'paredit-mode)
;; (slime-setup '(slime-fancy slime-company))

;; Warning (emacs): To restore SLIME in this session, customize ‘lisp-mode-hook’
;; and replace ‘sly-editing-mode’ with ‘slime-lisp-mode-hook’.
;; Warning (emacs): ‘sly.el’ loaded OK. To use SLY, customize ‘lisp-mode-hook’ and remove ‘slime-lisp-mode-hook’.


(require 'sly)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(add-hook 'lisp-mode-hook 'paredit-mode)
(add-hook 'sly-mode-hook 'paredit-mode)
(add-hook 'common-lisp-lisp-mode-hook 'paredit-mode)

(require 'git-gutter)
(global-git-gutter-mode 1)
(set-face-background 'git-gutter:modified "cyan") ;; background color
(set-face-foreground 'git-gutter:added "green")
(set-face-foreground 'git-gutter:deleted "red")

;; (add-hook 'before-save-hook
;;          'delete-trailing-whitespace)

;; interferes with eldoc in eglot...
;; (require 'which-func)
;; (which-func-mode t)

(setq-default backup-directory-alist `(("." . "~/.saves")))
(setq-default delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  make-backup-files t            ; backup of a file the first time it is saved
  backup-by-copying t            ; don't clobber symblinks
  version-control t              ; version numbers between backup files
  delete-old-versions t          ; delete excess backup files silently
  delete-by-moving-to-trash t
  auto-save-timeout 5            ; number of seconds idletime before auto-save (default 30)
  auto-save-interval 50)

(recentf-mode 1) ; keep a list of recently opened files
(savehist-mode 1) ; keep minibuffer history
(tool-bar-mode -1) ; turns off the toolbar
;;; may or may not allow emacs to scarf environment vars
;; (setq shell-file-name "bash")
;; (setq shell-command-switch "-ic")

;; skip warnings in compilation mode
(setq compilation-skip-threshold 2)

;; Define + active modification to compile that locally sets
;; shell-command-switch to "-ic".
(defadvice compile (around use-bashrc activate)
  "Load .bashrc in any calls to bash (e.g. so we can use aliases)"
  (let ((shell-command-switch "-ic"))
    ad-do-it))

;; Define + active modification to compile that locally sets
;; shell-command-switch to "-ic".
(defadvice recompile (around use-bashrc activate)
  "Load .bashrc in any calls to bash (e.g. so we can use aliases)"
  (let ((shell-command-switch "-ic"))
    ad-do-it))

;; allows for tab completion of aliases and functions in various bash contexts
;; as well as command prompts
(autoload 'bash-completion-dynamic-complete
          "bash-completion"
          "BASH completion hook")
(add-hook 'shell-dynamic-complete-functions
          'bash-completion-dynamic-complete)

(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-use-filename-at-point 'guess)
(setq ido-create-new-buffer 'always)

(ido-mode 1)
