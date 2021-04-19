(require 'package)
(require 'cl-lib)

(add-to-list 'package-archives (cons "melpa" "http://melpa.org/packages/") t)

(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(misterioso))
 '(package-selected-packages
   '(cl-lib-highlight projectile common-lisp-snippets flymd markdown-preview-mode eglot dockerfile-mode cmake-mode find-file-in-project org-journal noaa nov jedi elpy indent-tools yaml-mode multiple-cursors hydra lsp-treemacs company company-lsp flycheck avy lsp-mode lsp-ui slime slime-repl-ansi-color xquery-mode xquery-tool hideshow-org outshine ggtags restart-emacs magit magit-svn nyan-mode zone-nyan paredit)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defadvice package-install-selected-packages (around auto-confirm compile activate)
  (cl-letf (((symbol-function 'yes-or-no-p) (lambda (&rest args) t))
            ((symbol-function 'y-or-n-p) (lambda (&rest args) t)))
           ad-do-it))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install-selected-packages))

(avy-setup-default)
(global-set-key (kbd "C-c C-j") 'avy-resume)

;; It will bind, for example, avy-isearch to C-' in isearch-mode-map, so that you can select one of the currently visible isearch candidates using avy.

(global-set-key (kbd "C-:") 'avy-goto-char)
(global-set-key (kbd "M-g g") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)
(global-set-key (kbd "M-g e") 'avy-goto-word-0)

(load (expand-file-name "~/quicklisp/slime-helper.el"))
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
(setq recentf-max-menu-items 250)
(setq recentf-max-saved-items 250)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(run-at-time nil (* 5 60) 'recentf-save-list)

(setq-default indent-tabs-mode nil)

(setq elpy-rpc-python-command "python3.8")

(defun insert-current-date () (interactive)
  (insert (shell-command-to-string "echo -n $(date +%Y-%m-%d)")))
(defun insert-current-time () (interactive)
  (insert (shell-command-to-string "echo -n $(date +%H:%M)")))
(defun insert-current-time-seconds () (interactive)
  (insert (shell-command-to-string "echo -n $(date +%H:%M:%S)")))

(global-set-key (kbd "C-c d") 'insert-current-date)
(global-set-key (kbd "C-c t") 'insert-current-time)
(global-set-key (kbd "C-c T") 'insert-current-time-seconds)

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

(require 'slime)
(add-hook 'slime-repl-mode-hook 'paredit-mode)
(slime-setup '(slime-fancy slime-company))

(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(add-hook 'lisp-mode-hook 'paredit-mode)
(add-hook 'common-lisp-lisp-mode-hook 'paredit-mode)

(add-hook 'before-save-hook
         'delete-trailing-whitespace)

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
