;;; init.el --- My Emacs initialisation file.

;; Copyright (C) 2014  Dominic Charlesworth <dgc336@gmail.com>

;; Author: Dominic Charlesworth <dgc336@gmail.com>
;; Keywords: internal

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; When setting up from scratch, there are a couple of external
;; packages that you'll require, here is a list of things to install

;; npm install -g livedown
;; npm install -g n_
;; npm install -g ramda-repl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Code:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defconst base-path (file-name-directory load-file-name))

(setq custom-file (concat base-path "init/custom.el"))

(require 'package)
(setq-default package-user-dir (concat base-path "packages/elpa"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize nil)

(require 'benchmark-init)
(add-hook
 'benchmark-init/tree-mode-hook
 '(lambda ()
    (local-set-key "i" '(lambda () (interactive) (find-file user-init-file)))
    (local-set-key "s" '(lambda () (interactive) (switch-to-buffer "*scratch*")))
    (local-set-key "t" 'load-theme)
    (local-set-key "f" 'set-font)
    (local-set-key "p" 'jpop-change)
    (local-set-key "P" 'jpop-change-and-find-file)))

(require 'use-package)

(use-package functions :load-path "init")

(use-package linum-off)

(use-package drag-stuff
  :config (drag-stuff-global-mode 1)
  :bind ("s-N" . drag-stuff-down)
        ("s-P" . drag-stuff-up))

(use-package mon-css-color
  :load-path "elisp"
  :init (autoload 'css-color-mode "mon-css-color" "" t)
  :config (css-color-global-mode))

(use-package rainbow-delimiters)
(use-package paren)

(use-package multiple-cursors
  :bind ("H-n" . mc/mark-next-like-this)
        ("s-n" . mc/skip-to-next-like-this)
        ("H-p" . mc/mark-previous-like-this)
        ("s-p" . mc/skip-to-previous-like-this)
        ("H-l" . mc/mark-all-symbols-like-this)
        ("M-<mouse-1>" . mc/add-cursor-on-click))

(use-package multi-line
  :bind ("C-c [" . multi-line-single-line)
        ("C-c ]" . multi-line))

(use-package expand-region
  :bind ("M-q" . er/expand-region))

(use-package ibuffer
  :defer t
  :config
  (use-package ibuf-ext
    :config (add-to-list 'ibuffer-never-show-predicates "^\\*"))
  (bind-keys :map ibuffer-mode-map
             ("G" . ibuffer-vc-set-filter-groups-by-vc-root)
             ("M-u" . ibuffer-unmark-all)))

(use-package smart-forward
  :bind ("s-." . forward-sexp)
        ("s-," . backward-sexp)
        ("C-." . smart-forward)
        ("C-," . smart-backward))

(use-package smart-newline
  :bind ("RET" . smart-newline))

(use-package smartparens
  :demand
  :config (smartparens-global-mode)
          (sp-local-pair
           '(minibuffer-inactive-mode snippet-mode lisp-mode emacs-lisp-mode slack-mode text-mode)
           "'" nil :actions nil)
          (sp-with-modes sp-lisp-modes (sp-local-pair "(" nil :bind "s-("))
  :bind ("C-)" . sp-slurp-hybrid-sexp)
        ("s-f" . sp-slurp-hybrid-sexp)
        ("s-b" . sp-forward-barf-sexp))

(use-package operate-on-number
  :bind ("s-@" . operate-on-number-at-point))

(use-package command-log-mode
  :defer t
  :config (global-command-log-mode)
  :bind ("C-c o" . clm/toggle-command-log-buffer))

(use-package popup :defer t)
(use-package popwin
  :demand
  :config (popwin-mode 1)
          (setq popwin:close-popup-window-timer-interval 0.1)
          (setq popwin:close-popup-window-timer nil)
  :bind ("C-x m" . popwin:messages))

(use-package darkroom
  :config (setq darkroom-fringes-outside-margins nil)
          (setq darkroom-margins 0.0)
          (setq darkroom-text-scale-increase 1.0))

(use-package org-mode
  :mode ("\\.org" . org-mode)
  :init
  (add-hook 'org-mode-hook 'darkroom-mode)
  :config
  (org-beamer-mode)
  (bind-keys :map org-mode-map ("s-p" . fill-paragraph)))

(use-package doc-view
  :mode ("\\.pdf" . doc-view-mode)
  :init (add-hook 'doc-view-mode-hook 'darkroom-mode))

(use-package undo-tree
  :config (global-undo-tree-mode)
  :bind ("s-z" . undo-tree-undo)
        ("s-Z" . undo-tree-redo)
        ("s-y" . undo-tree-redo)
        ("C-+" . undo-tree-redo))

(use-package etags-select :after (lisp-mode)
  :bind ("H-." . etags-select-find-tag-at-point)
        ("H->" . etags-select-find-tag))

(use-package git-gutter-fringe
  :if window-system
  :config (global-git-gutter-mode))

(use-package image+ :after 'image-mode)
(use-package dired+
  :after 'dired
  :config
  (bind-keys :map dired-mode-map
             ("q" . kill-all-dired-buffers)))

(use-package git-timemachine :bind ("C-x v t" . git-timemachine))
(use-package git-messenger :bind ("C-x v p" . git-messenger:popup-message))

(use-package zoom-window
  :config (setq zoom-window-mode-line-color "#d35400")
  :bind ("C-x C-z" . zoom-window-zoom))

(use-package nameless
  :defer t
  :config (bind-keys :map nameless-mode-map ("C-c c" . nameless-insert-name)))

(use-package window-layout
  :config
  (defun wlf:trip-split-layout ()
    (wlf:show (wlf:no-layout
               '(| (:left-size-ratio 0.6) file
                   (- (:upper-size-ratio 0.4) runner compilation))
               '((:name file :buffer "file buffer")
                 (:name runner :buffer "*runner*")
                 (:name compilation :buffer "*compilation*")))))
  (defun wlf:ert-layout ()
    (let* ((test-buffer (format "%s-test.el" (file-name-base (buffer-file-name)))))
      (wlf:show (wlf:no-layout
                '(| (:left-size-ratio 0.6)
                    (- (:upper-size-ratio 0.5) file test)
                    (- (:upper-size-ratio 0.7) ert messages))
                '((:name file :buffer "file buffer")
                  (:name test :buffer test-buffer)
                  (:name messages :buffer "*Messages*")
                  (:name ert :buffer "*ert*"))))))
  (defun wlf:codepen-layout ()
    (let ((scss-buf (get-buffer-create "codepen.scss"))
          (html-buf (get-buffer-create "codepen.html"))
          (js-buf (get-buffer-create "codepen.js")))
      (wlf:show (wlf:no-layout
                 '(| (:left-size-ratio 0.3) html
                     (| (:left-size-ratio 0.3) scss js))
                 '((:name html :buffer html-buf)
                   (:name scss :buffer scss-buf)
                   (:name js :buffer js-buf))))))
  (defun wlf:layout (&optional pfx)
    (interactive "P")
    (let ((layouts '(("Codepen" wlf:codepen-layout) ("ERT" wlf:ert-layout) ("Triple Split" wlf:trip-split-layout))))
      (if pfx
          (funcall (cadr (assoc (completing-read "Layout: " layouts) layouts)))
        (wlf:trip-split-layout)) t))

  :bind ("C-c C-w" . wlf:layout))


(use-package flycheck-status-emoji
  :load-path "eslip"
  :after flycheck)
(use-package flycheck
  :config (global-flycheck-mode)
  (setq flycheck-javascript-standard-executable "standard")
  (setq flycheck-javascript-eslint-executable "eslint")
  (bind-keys :map flycheck-mode-map
             ("C-c C-e" . flycheck-list-errors)
             ("C-c C-n" . flycheck-next-error)
             ("C-c C-p" . flycheck-previous-error))
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  :bind ("M-}" . flycheck-mode))

(use-package eslint-reader
  :load-path "elisp/eslint-reader"
  :after js2-mode)

(use-package flyspell
  :init (setq flyspell-mode-map (make-sparse-keymap))
  (defun flyspell-toggle ()
    (interactive)
    (if flyspell-mode (flyspell-mode-off) (flyspell-mode)))
  (use-package flyspell-popup :defer t)
  :config (bind-keys :map flyspell-mode-map
                     ("s-]" . flyspell-goto-next-error)
                     ("M-/" . flyspell-popup-correct))
          (advice-add 'flyspell-mode-on :before 'flyspell-buffer)
  :bind ("M-{" . flyspell-toggle))

(use-package jpop
  :load-path "elisp/projectable"
  :config
  (jpop-global-mode)
  (add-hook 'jpop-toggle-test-fallback-hook 'jpop-find-test)
  :bind
  ([C-tab] . jpop-find-file)
  ("C-S-<tab>" . jpop-git-find-file)
  ("C-x p f c" . jpop-change-and-find-file)
  ("C-x p c" . jpop-change)
  ("C-x C-b" . jpop-switch-buffer)
  ("C-x C-p" . jpop-switch-and-find-file))

(use-package visual-regexp
  :bind ("C-c r" . vr/replace)
        ("C-c q" . vr/query-replace)
        ("C-c m" . vr/mc-mark)
        ("s-r" . vr/query-replace))

(use-package counsel :after ivy
  :config
  (defun counsel-git-grep-from-isearch ()
    "Invoke `counsel-git-grep' from isearch."
    (interactive)
    (let ((input (if isearch-regexp
                     isearch-string
                   (regexp-quote isearch-string))))
        (isearch-exit)
        (counsel-git-grep nil input)))
  :bind ([f2]      . counsel-git-grep)
        ("<M-f2>"  . counsel-ag)
        ("<H-tab>" . counsel-git)
        ("M-x"     . counsel-M-x)
        ("C-x C-f" . counsel-find-file)
        ("C-h b"   . counsel-descbinds)
        ("C-h v"   . counsel-describe-variable)
        ("C-h f"   . counsel-describe-function)
        ("s-V"     . counsel-yank-pop)
        ("M-y"     . counsel-yank-pop))

(use-package ivy :after avy
  :config
  (ivy-mode)
  (setq ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  (bind-keys :map ivy-mode-map
             ("C-S-j" . ivy-immediate-done))
  :bind ("C-c C-r" . ivy-resume)
        ("M-o"     . swiper))

(use-package isearch
  :bind ("H-s" . isearch-forward-symbol-at-point)
        ("C-s" . isearch-forward-regexp)
        ("C-r" . isearch-backward-regexp)

  :init (bind-keys :map isearch-mode-map
                   ("C-;" . swiper-from-isearch)
                   ("C-'" . avy-isearch)
                   ("C-l" . counsel-git-grep-from-isearch)))

(global-prettify-symbols-mode)
(push '("->" . ?→) prettify-symbols-alist)
(push '("<-" . ?←) prettify-symbols-alist)
(push '("<=" . ?≤) prettify-symbols-alist)
(push '(">=" . ?≥) prettify-symbols-alist)

(use-package avy
  :bind
  ("s-g" . avy-goto-line)
  ("C-c a" . avy-goto-char)
  ("C-c SPC" . avy-goto-char)
  ("C-c C-a" . avy-goto-word-1)
  ("C-'" . avy-goto-word-1)
  :config
  (avy-setup-default)
  (bind-keys ("M-A" . (lambda () (interactive) (call-interactively 'avy-goto-word-1) (forward-word)))))

(use-package avy-zap :after avy
  :bind
  ("M-z" . avy-zap-up-to-char))

(use-package wgrep
  :after 'helm-files
  :init (defun wgrep-end ()
          (interactive)
          (wgrep-finish-edit)
          (wgrep-save-all-buffers))
        (autoload 'wgrep-change-to-wgrep-mode "browse-url")
  :config (define-key wgrep-mode-map (kbd "C-c C-s") 'wgrep-end)
          (define-key helm-grep-mode-map (kbd "C-c C-p") 'wgrep-change-to-wgrep-mode))

(use-package tern
  :after 'js2-mode
  :config
  (bind-keys :map tern-mode-keymap
             ("M-." . jump-to-thing-at-point)
             ("M-," . pop-tag-mark))
  (use-package tern-auto-complete :config (tern-ac-setup)))

(use-package js2-refactor :after js2-mode)
(use-package js2r-extensions :after js2-mode :load-path "elisp")
(use-package js-injector
  :after js2-mode
  :load-path "elisp/js-dependency-injector")
(use-package js2-mode
  :mode ("\\.js$" . js2-mode)
  :config
  (add-hook 'js2-mode-hook 'js-injector-minor-mode)
  (add-hook 'js2-mode-hook 'js2-mode-hide-warnings-and-errors)
  (add-hook 'js2-mode-hook '(lambda () (modify-syntax-entry ?_ "w")))
  (add-hook 'js2-mode-hook '(lambda () (key-combo-common-load-default)))
  (add-hook 'js2-mode-hook '(lambda () (tern-mode t)))
  (add-hook 'js2-mode-hook '(lambda () (flycheck-select-checker (flycheck--guess-checker))))
  (add-hook 'js2-mode-hook
            (lambda () (if (s-contains? "require.def" (buffer-substring (point-min) (point-max)))
                      (add-to-list 'ac-sources 'ac-source-requirejs-files)
                    (add-to-list 'ac-sources 'ac-source-project-files))))
  (add-hook 'js2-mode-hook
            '(lambda ()
               (push '("function" . ?ƒ) prettify-symbols-alist)
               (push '("var" . ?ν) prettify-symbols-alist)
               (push '("const" . ?ς) prettify-symbols-alist)
               (push '("let" . ?γ) prettify-symbols-alist)
               (push '("=>" . ?→) prettify-symbols-alist)
               (push '("R" . ?Λ) prettify-symbols-alist)
               (push '("R.__" . ?ρ) prettify-symbols-alist)
               (push '("_" . ?λ) prettify-symbols-alist)
               (push '("err" . ?ε) prettify-symbols-alist)
               (push '("return" . ?⇐) prettify-symbols-alist)
               (push '("undefined" . ?∅) prettify-symbols-alist)
               (push '("error" . ?Ε) prettify-symbols-alist)
               (push '("_.map" . ?↦) prettify-symbols-alist)
               (push '("R.map" . ?↦) prettify-symbols-alist)
               (push '("_.compose" . ?∘) prettify-symbols-alist)
               (push '("R.compose" . ?∘) prettify-symbols-alist)
               ;; Key words
               (push '("for" . ?↻) prettify-symbols-alist)
               (push '("while" . ?∞) prettify-symbols-alist)
               (push '("module.exports" . ?⇧) prettify-symbols-alist)
               ;; Maths symbols
               (push '("<=" . ?≤) prettify-symbols-alist)
               (push '(">=" . ?≥) prettify-symbols-alist)
               (push '("!=" . ?≠) prettify-symbols-alist)
               (push '("!==" . ?≢) prettify-symbols-alist)
               (push '("===" . ?≡) prettify-symbols-alist)))

  (bind-keys :map js2-mode-map
             ("C-x c" . grunt-exec)

             ;; JS2 Refactor things
             ("C-c C-m" . context-coloring-mode)
             ("C-c m" . prettify-symbols-mode)
             ("s-P" . js2r-drag-stuff-up)
             ("s-N" . js2r-drag-stuff-down)
             ("C-c C-o" . js2r-order-vars-by-length)
             ("C-c C-s" . js2r-toggle-var-declaration)
             ("C-c C-v" . js2r-extract-var)
             ("C-c C-i" . js2r-inline-var)
             ("C-c C-f" . js2r-extract-function)
             ("C-c C-r" . js2r-rename-var)
             ("C-c C-l" . js2r-log-this)
             ("C-c ." . js2-jump-to-definition)
             ("C-k" . js2r-kill)
             ("<C-backspace>" . (lambda () (interactive) (smart-backward) (js2r-kill)))))

(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'web-mode-hook 'skewer-html-mode)

(use-package comint-mode
  :init
  (add-hook
   'comint-mode-hook
   (lambda ()
     (local-set-key (kbd "C-r") 'comint-history-isearch-backward)
     (local-set-key (kbd "<up>") 'comint-previous-input)
     (local-set-key (kbd "<down>") 'comint-next-input))))

(use-package cpp
  :mode ("\\.cpp" . c++-mode)
        ("\\.h" . c++-mode)
  :config
  (bind-keys :map c++-mode-map
             ("M-q" . er/expand-region)
             ("C-c C-p" . flycheck-previous-error)
             ("C-c C-n" . flycheck-next-error)))

(add-hook 'c++-mode-hook
          (lambda () (unless (file-exists-p "makefile")
                  (set (make-local-variable 'compile-command)
                       (let ((file (file-name-sans-extension buffer-file-name)))
                         (format "g++ %s -o %s" buffer-file-name file))))))

(add-hook 'scss-mode-hook
          (lambda () (set (make-local-variable 'compile-command)
                     (let ((file (file-name-sans-extension buffer-file-name)))
                       (format "sass '%s':%s.css" buffer-file-name file)))))

(use-package json-snatcher :after json)
(use-package json
  :mode ("\\.json" . json-mode)
  :config (add-hook 'json-mode-hook '(lambda ()
                                       (jpop-stylise 2 t))))

(use-package eww
  :defer t
  :bind ("<f10>" . eww)
        ("<s-f10>" . eww-list-bookmarks)
  :config (bind-keys :map eww-mode-map
                     ("j" . json-format)
                     ("c" . eww-copy-page-url)))

(use-package goto-addr :after markdown-mode)
(use-package markdown-mode
  :mode ("\\.md" . markdown-mode)
  :config
  (add-hook 'markdown-mode-hook 'ac-emoji-setup)
  (bind-keys* ("M-<left>" . backward-word)
              ("<M-S-left>" . backward-word)
              ("M-<right>" . forward-word)
              ("<M-S-right>" . forward-word))
  (bind-keys :map markdown-mode-map
             ("s-f" . next-link)
             ("s-b" . previous-link)))

(use-package browse-url
  :defer t
  :init (autoload 'browse-url-url-at-point "browse-url"))

(use-package link-hint
  :bind ("H-o" . link-hint-open-link)
        ("H-O" . link-hint-open-multiple-links))

(use-package markdown-toc
  :after markdown-mode
  :config (bind-keys :map markdown-mode-map
                     ("C-c C-t g" . markdown-toc-generate-toc)))

(use-package livedown
  :after markdown-mode
  :load-path "elisp/emacs-livedown"
  :config (bind-keys :map markdown-mode-map
                     ("C-c p" . livedown:preview)))

(use-package coffee-mode :mode ("\\.coffee" . coffee-mode))
(use-package scss-mode :mode ("\\.scss$" . scss-mode))
(use-package css-mode :mode ("\\.css$" . css-mode))

(use-package lisp-mode
  :mode ("\\.el" . emacs-lisp-mode)
  :init
  (add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
  (add-hook 'emacs-lisp-mode-hook
            '(lambda () (ac-lambda 'ac-source-functions
                              'ac-source-symbols
                              'ac-source-variables
                              'ac-source-filepath
                              'ac-source-yasnippet
                              'ac-source-words-in-same-mode-buffers)))
  :config
  (bind-keys :map emacs-lisp-mode-map
             ("C-c C-l" . elisp-debug)
             ("C-c RET" . context-coloring-mode)
             ("M-." . jump-to-find-function)
             ("M-," . pop-tag-mark)))

(use-package context-coloring-mode
  :defer t
  :config (advice-add 'load-theme :after
                      '(lambda (&rest args) (context-coloring-mode 0))))

(use-package key-combo
  :config (add-to-list 'key-combo-common-mode-hooks 'web-mode-hook)
          (key-combo-mode 1)
          (key-combo-load-default))

(use-package yasnippet
  :config
  (setq yas-snippet-dirs (concat base-path "/snippets"))
  (add-hook 'after-init-hook 'yas-global-mode))

(use-package neotree
  :bind ([f1] . neotree-toggle)
  ("<S-f1>" . neotree-find))

(use-package esh-mode
  :defer t
  :init (with-eval-after-load "esh-opt"
          (autoload 'epe-theme-dakrone "eshell-prompt-extras")
          (setq eshell-highlight-prompt nil
                eshell-prompt-function 'epe-theme-dakrone))
  :config (bind-keys :map eshell-mode-map
             ("C-r" . counsel-esh-history)))

(use-package shell-pop
  :bind ("C-`" . shell-pop)
  :config
  (add-hook 'term-mode-hook '(lambda () (yas-minor-mode -1)))
  (custom-set-variables
   '(shell-pop-autocd-to-working-dir nil)
   '(shell-pop-shell-type
     (quote
      ("eshell" "*eshell*"
       (lambda nil
         (eshell shell-pop-term-shell)))))
   '(shell-pop-term-shell "/bin/bash")
   '(shell-pop-window-position "bottom")
   '(shell-pop-window-size 40)))

(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'reverse) ; Used for unique buffer names)
  (setq uniquify-separator "/")              ; including parts of the path
  (setq uniquify-after-kill-buffer-p t)      ; rename after killing uniquified
  (setq uniquify-ignore-buffers-re "^\\*"))  ; don't muck with special buffers

(setenv "PATH" (concat "/usr/texbin:/usr/local/bin:" (getenv "PATH")))
(setq exec-path '("/usr/local/bin" "/usr/bin" "/bin"))

(use-package web-mode
  :load-path "~/.env/elisp/web-mode/"

  :mode
  ("\\.phtml$" . web-mode)
  ("\\.html$" . web-mode)
  ("\\.spv$" . web-mode)
  ("\\.erb$" . web-mode)
  ("\\.mustache$" . web-mode)
  ("\\.hbs$" . web-mode)
  ("\\.partial$" . web-mode)
  ("\\.jsx$" . web-mode)

  :config
  (bind-keys :map web-mode-map
             ("M-;" . semi-colon-end)
             ("s-/" . web-mode-comment-or-uncomment)
             ("M-P" . key-combo-mode)
             ("C-o" . emmet-expand-yas))
  (setq web-mode-ac-sources-alist
        '(("html" . (ac-source-html-tag
                     ac-source-words-in-same-mode-buffers
                     ac-source-html-attr))
          ("css" . (ac-source-css-selector
                    ac-source-css-id
                    ac-source-css-property))
          ("jsx" . (ac-source-yasnippet
                    ac-source-filepath
                    ac-source-words-in-same-mode-buffers
                    ac-source-tern-completion))))

  (defadvice web-mode-highlight-part (around tweak-jsx activate)
    (if (equal web-mode-content-type "jsx")
        (let ((web-mode-enable-part-face nil)) ad-do-it)
      ad-do-it))

  (add-hook 'web-mode-hook
            (lambda () (when (equal web-mode-content-type "jsx") (tern-mode)))))

(use-package emmet-mode :after web-mode
  :config
  (bind-keys :map scss-mode-map
             ("M-P" . key-combo-mode)
             ("C-o" . emmet-expand-yas))
  ;; (advice-add 'emmet-expand-yas :before
  ;;             '(lambda () "Bemify the expression before expanding snippet when using the `|bem` filter"
  ;;                (bemify-emmet-string (emmet-expr-on-line))))
  )

(use-package auto-complete-config :after auto-complete)

;; Custom Auto Complete Sources
(use-package ac-jpop :load-path "~/.env/elisp" :after js2-mode)
(use-package ac-filepath :load-path "~/.env/elisp")
(use-package ac-css :load-path "~/.env/elisp" :after (web-mode scss-mode))

(use-package ac-emmet :after emmet-mode)
(use-package ac-html :after web-mode)

(use-package auto-complete
  :demand t
  :config
  (ac-config-default)
  (set-default 'ac-sources
               '(ac-source-yasnippet
                 ac-source-filepath
                 ac-source-words-in-same-mode-buffers))
  (global-auto-complete-mode t)

  (bind-keys :map ac-completing-map ("\e" . ac-stop))
  (bind-keys :map ac-complete-mode-map
             ([tab] . ac-expand-common)
             ([return] . ac-complete)
             ("C-s" . ac-isearch)
             ("C-n" . ac-next)
             ("C-p" . ac-previous))

  :bind ([S-tab] . auto-complete))

(add-hook 'scss-mode-hook
          '(lambda () (ac-lambda
                  'ac-source-yasnippet
                  'ac-source-css-property
                  'ac-source-css-id
                  'ac-source-css-selector
                  'ac-source-filepath
                  'ac-source-scss-colors)
             (emmet-mode)
             (ac-emmet-css-setup)))

(add-hook 'LaTeX-mode-hook
            '(lambda () (ac-lambda
                    'ac-source-math-unicode
                    'ac-source-math-latex
                    'ac-source-latex-commands)))

(add-hook 'LaTeX-mode-hook
          '(lambda () (local-set-key (kbd "C-x c") 'xelatex-make)))
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'darkroom-mode)

(add-hook 'git-commit-mode-hook '(lambda () (ac-lambda 'ac-source-gh-issues)))
(add-hook 'ghi-comment-mode-hook '(lambda () (ac-lambda 'ac-source-emoji 'ac-source-gh-issues)))

;;---------------
;; Mode Hooks
;;---------------
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.erb" . html-mode))

(setq truncate-lines nil)

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'css-color-mode)
(add-hook 'prog-mode-hook 'yas-minor-mode)

(use-package hideshowvis
  :init (autoload 'hideshowvis-enable "hideshowvis" nil t)
  :config (hideshowvis-symbols)
  :bind ("s-_" . hs-show-all)
        ("s--" . hs-show-block)
        ("s-=" . hs-toggle-hiding)
        ("s-+" . hs-hide-level))
(add-hook 'prog-mode-hook 'hideshowvis-minor-mode)

(use-package grunt
  :load-path "~/code/grunt-el"
  :bind ("C-M-g" . grunt-exec))

(use-package repository-root
  :defer t
  :config
  (add-to-list 'repository-root-matchers repository-root-matcher/svn)
  (add-to-list 'repository-root-matchers repository-root-matcher/git))

(use-package magit-gh-issues
  :disabled t
  :load-path "elisp/magit-gh-issues"
  :after 'magit
  :config (add-hook 'magit-mode-hook 'magit-gh-issues-mode)
          (use-package magit-gh-issues-emoji
            :load-path "elisp/magit-gh-issues-emoji"))

(use-package magit
  :defer t
  :config (bind-keys :map magit-mode-map
                     ("o" . magit-open-file-other-window)
                     ("C-c c" . magit-whitespace-cleanup)
                     ("C-c e" . magit-vc-ediff)
                     ("C-<tab>" . jpop-find-file)))


(use-package yahoo-weather
  :defer t
  :init (setq yahoo-weather-location "Salford Quays")
  :config
  (defvar yahoo-run-id nil)
  (defun yahoo-weather-async-update-info ()
    (interactive)
    (async-start `(lambda ()
                    (require 'yahoo-weather (concat ,package-user-dir "/yahoo-weather-20160111.439/yahoo-weather.el"))
                    (yahoo-weather-update-info))
                 '(lambda (&rest args) (message "Yahoo weather updated [%s]" (format-time-string "%H:%M")))))
  (setq yahoo-run-id (run-at-time "1 sec" 900 'yahoo-weather-async-update-info)))

(use-package mode-icons
  :if window-system
  :load-path "elisp/mode-icons")

(add-hook 'after-init-hook 'update-powerline)
(use-package powerline
  :if window-system
  :load-path "elisp"
  :config
  (advice-add 'load-theme :after 'update-powerline))

(use-package boop :load-path "elisp/boop"
  :defer t
  :init
  (add-hook 'boop-update-hook
            '(lambda () (let ((local-config))
                     (deboop-group 'jpop)
                     (when (and (bound-and-true-p jpop-project-plist)
                                (plist-get jpop-project-plist :boop)
                                (boundp 'jpop-id))
                       (maphash
                        (lambda (key value)
                          (setq local-config (append local-config
                                        (list (list (intern key)
                                                    :script (intern (plist-get value :script))
                                                    :group 'jpop
                                                    :args (plist-get value :args)
                                                    :onselect `(lambda () (interactive) (browse-url (plist-get ,value :onclick))))))))
                        (plist-get jpop-project-plist :boop)))
                     (setq boop-config-alist (append boop-config-alist local-config))
                     (boop--sync-result-and-config))))

  :commands (boop-start))

(use-package window-numbering
  :init
  (add-hook
   'window-numbering-mode-hook
   '(lambda ()
      (let ((map (make-sparse-keymap)))
        (mapc
         (lambda (n) (define-key map (kbd (format "s-%s" n)) `(,(intern (format "select-window-%s" n)))))
         (number-sequence 1 9))
        (setq window-numbering-keymap map))))
  :config
  (window-numbering-mode)
  (window-numbering-clear-mode-line))

(use-package request
  :defer t
  :init
  (use-package json)
  :config
  (defun set-frame-title-yo-momma ()
    (interactive)
    (request
     "http://api.yomomma.info/"
     :parser 'json-read
     :success (function*
               (lambda (&key data &allow-other-keys)
                 (let ((f (format-for-frame-title (cdr (assoc 'joke data)))))
                   (setq frame-title-format f))))))
  :bind ("<s-f8>" . set-frame-title-yo-momma))
(add-hook 'after-init-hook 'set-frame-title-yo-momma)

(add-hook 'magit-mode-hook 'image-minor-mode)

;; Load stuff to do with grep initially
(eval-after-load "grep" '(grep-compute-defaults))

;; change vc-diff to use vc-ediff
(setq ediff-split-window-function (quote split-window-horizontally))
(setq ediff-keep-variants nil)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(add-hook 'ediff-before-setup-hook 'my-ediff-bsh)
(add-hook 'ediff-after-setup-windows-hook 'my-ediff-ash 'append)
(add-hook 'ediff-quit-hook 'my-ediff-qh)

(add-hook 'ediff-startup-hook 'ediff-swap-buffers)

(add-hook 'vc-annotate-mode-hook 'sticky-window-delete-other-windows)
(add-hook 'magit-status-mode-hook 'sticky-window-delete-other-windows)
(add-hook 'magit-branch-manager-mode-hook 'sticky-window-delete-other-windows)

;; Startup variables
(setq shift-select-mode t)                  ; Allow for shift selection mode
(setq inhibit-splash-screen t)              ; disable splash screen
(setq make-backup-files nil)                ; don't make backup files
(setq create-lockfiles nil)                 ; don't make lock files
(setq auto-save-default nil)                ; don't autosave
(setq visible-bell nil)                     ; Disbales beep and use visible bell
(setq ns-function-modifier 'hyper)          ; set Hyper to Mac's Fn key

;; Set mac modifiers to what I'm used to
(setq mac-function-modifier 'hyper)
(setq mac-command-modifier 'super)
(setq mac-option-modifier 'meta)

(delete-selection-mode 1)                    ; Allows for deletion when typing over highlighted text
(fset 'yes-or-no-p 'y-or-n-p)               ; Use y or n instead of yes or no

(setq frame-title-format "Who's hacking %b?")
(setq-default cursor-type 'bar)             ; Change cursor to bar
(setq-default tab-width 2)
(setq js-indent-level 2)

;; Get rid of stupid menu bar and Tool Bar..
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(show-paren-mode t)   ; Show paranthesis matching

;; Global Mode Stuff
(global-linum-mode 1) ; enable line numbers

;;------------------
;; My Load Files
;;------------------

(setq custom-file (concat base-path "init/custom.el"))
(add-to-list 'custom-theme-load-path (concat base-path "/packages/themes"))

(use-package keys :load-path "init")
(load-file (concat base-path "init/custom.elc"))
(load-file (concat base-path "init/advice.elc"))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

(when window-system
  (load-theme 'aurora)
  (server-start)
  (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") nil 'prepend))

(unless window-system
  (load-theme 'spacemacs-dark))

(benchmark-init/show-durations-tree)
;; Local Variables:
;; indent-tabs-mode: nil
;; eval: (flycheck-mode 0)
;; End:

(provide 'init)
;;; init.el ends here
