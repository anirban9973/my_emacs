;; ============================================================================
;; BASIC UI AND STARTUP
;; ============================================================================
;; Disable splash screen and startup message
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; Remove menubar, toolbar, and scrollbar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; ============================================================================
;; PACKAGE MANAGEMENT
;; ============================================================================
;; Initialize package sources
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))

;; Initialize packages
(package-initialize)

;; Refresh package list if not available
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Configure use-package
(require 'use-package)
(setq use-package-always-ensure t)

;; Suppress warnings
(setq byte-compile-warnings '(not docstrings))

;; ============================================================================
;; GENERAL EDITING
;; ============================================================================
;; Enable electric-pair-mode for automatic bracket pairing
(electric-pair-mode 1)

;; Text wrapping setup without hard line breaks
(global-visual-line-mode 1)
(setq-default auto-fill-function nil)
(setq line-move-visual t)

;; Disable tabs for indentation
(setq-default indent-tabs-mode nil)

;; Display settings
(setq-default left-margin-width 2)
(setq-default right-margin-width 2)
(setq-default line-spacing 0.2)

;; Show line numbers in programming modes only
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Remove auto-fill from text modes
(with-eval-after-load 'text-mode
  (remove-hook 'text-mode-hook 'turn-on-auto-fill))
(with-eval-after-load 'org
  (remove-hook 'org-mode-hook 'turn-on-auto-fill))

;; ============================================================================
;; COMPLETION AND SNIPPETS
;; ============================================================================
;; Company mode for autocompletion
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1)
  (setq company-selection-wrap-around t)
  (setq company-tooltip-align-annotations t)
  (setq company-tooltip-limit 15))

;; Yasnippet for code snippets
(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets)

;; ============================================================================
;; SEARCH AND NAVIGATION
;; ============================================================================
;; which-key for keybinding discovery
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode 1)
  (setq which-key-idle-delay 0.3))

;; Ivy, Counsel, Swiper for enhanced completion
(use-package ivy
  :diminish
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-initial-inputs-alist nil))

(use-package counsel
  :after ivy
  :config
  (counsel-mode 1))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)))

;; ============================================================================
;; PROJECT MANAGEMENT AND VERSION CONTROL
;; ============================================================================
;; Projectile for project management
(use-package projectile
  :diminish projectile-mode
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config 
  (projectile-mode +1)
  (projectile-discover-projects-in-search-path)  ; Auto-discover on startup
  :init
  (when (file-directory-p "~/Learning_projects")
    (setq projectile-project-search-path '("~/Learning_projects")))
  (setq projectile-switch-project-action #'projectile-dired))

;; Counsel-projectile integration
(use-package counsel-projectile
  :after (counsel projectile)
  :config
  (counsel-projectile-mode 1))

;; Magit for Git integration
(use-package magit
  :bind (("C-x g" . magit-status)))

;; ============================================================================
;; TERMINAL - INSTALL FIRST AND TEST!
;; ============================================================================
;; vterm - Install this first and test with M-x vterm
(use-package vterm
  :ensure t)
;; Now run `M-x vterm` and make sure it works!

;; ============================================================================
;; PROGRAMMING LANGUAGES
;; ============================================================================
;; Eglot for LSP (optional, for other languages)
(use-package eglot
  :hook ((c-mode . eglot-ensure)
         (c++-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs 
               '((c++-mode c-mode) "clangd"))
  (setq eglot-autoshutdown t)
  (setq eglot-sync-connect nil)
  (setq eglot-extend-to-xref t))

;; C/C++ and CUDA file associations
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cuh\\'" . c++-mode))

;; Julia support with julia-snail - Install AFTER vterm works
(use-package julia-mode
  :mode "\\.jl$")

(use-package julia-snail
  :ensure t
  :hook (julia-mode . julia-snail-mode))

;; ============================================================================
;; SCIENTIFIC WRITING AND DOCUMENTATION
;; ============================================================================
;; AUCTeX for LaTeX
(use-package tex
  :ensure auctex
  :defer t
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (setq reftex-plug-into-AUCTeX t)
  ;; Enable shell-escape for minted support
  (setq TeX-command-extra-options "--shell-escape")
  ;; Alternative: set LaTeX command directly
  (setq LaTeX-command "pdflatex --shell-escape"))

;; Markdown support
(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

;; Bibliography management
(use-package biblio)

;; Reference management
(use-package org-ref
  :after org)

;; Spell checking
(use-package flyspell
  :hook ((text-mode . flyspell-mode)
         (org-mode . flyspell-mode)
         (latex-mode . flyspell-mode)
         (markdown-mode . flyspell-mode)))

;; Writing improvement
(use-package writegood-mode
  :hook (text-mode org-mode latex-mode markdown-mode))

;; Smart quotes in text modes
(add-hook 'text-mode-hook 'electric-quote-mode)

;; ============================================================================
;; ORG-MODE
;; ============================================================================
(use-package org
  :config
  (setq org-startup-indented t)
  (setq org-startup-folded nil)
  (setq org-hide-leading-stars t))

;; ============================================================================
;; APPEARANCE AND THEMES
;; ============================================================================
;; Doom themes
(use-package doom-themes
  :config
  (load-theme 'doom-one t))

;; Page break lines for better navigation
(use-package page-break-lines
  :config
  (global-page-break-lines-mode))

;; ============================================================================
;; KEY BINDINGS
;; ============================================================================
;; General editing keybindings
(global-set-key (kbd "C-c c") 'company-complete)

;; Window navigation
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)

;; LaTeX keybindings
(global-set-key (kbd "C-c l c") 'tex-compile)

;; ============================================================================
;; BUG FIXES AND WORKAROUNDS
;; ============================================================================
;; Fix counsel-projectile warnings
(with-eval-after-load 'counsel-projectile
  (defvar counsel-projectile-find-file-action nil)
  (defvar counsel-projectile-find-dir-action nil)
  (defvar counsel-projectile-switch-to-buffer-action nil)
  (defvar counsel-projectile-switch-project-action nil)
  (defvar counsel-projectile-action nil))

;; Fix biblio-hal timezone warning
(with-eval-after-load 'biblio-hal
  (unless (fboundp 'timezone-parse-date)
    (defalias 'timezone-parse-date 'parse-time-string)))

;; ============================================================================
;; CUSTOM VARIABLES (Let Emacs manage this section)
;; ============================================================================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(julia-snail multi-vterm vterm which-key julia-repl julia-mode magit page-break-lines org-ref biblio doom-themes counsel-projectile yasnippet-snippets writegood-mode projectile markdown-mode eglot-inactive-regions counsel company auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
