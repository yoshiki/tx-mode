;;; tx-mode.el --- Major mode for editing Text::Xslate syntax

;; Copyright (C) 2010  Yoshiki Kurihara

;; Author: Yoshiki Kurihara <kurihara at cpan.org>
;; Keywords: perl template mode

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This is a major mode for editing files written in Text::Xslate syntax.

;;; Installation:
 
;; To install, just drop this file into a directory in your
;; `load-path' and (optionally) byte-compile it. To automatically
;; handle files ending in `.tx', add something like:
;;
;; (autoload 'tx-mode "tx-mode"
;;          "Major mode for editing Text::Xslate syntax")
;; (add-to-list 'auto-mode-alist '("\\.tx$" . tx-mode))
;;
;; to your .emacs file.
;;
;; To use syntax of Text::Xslate::Syntax::Metakolon '[% ... %]',
;; set `tx-tag-start-char', `tx-tag-end-char' and `tx-line-start-char'
;; to `tx-mode-hook' like following code.
;;
;; (add-hook 'tx-mode-hook
;;           '(lambda ()
;;              (setq tx-tag-start-char "[%")
;;              (setq tx-tag-end-char "%]")
;;              (setq tx-line-start-char "%")))

;;; Code:

(require 'tempo)

(defgroup tx nil  "Support for the Text::Xslate format"
  :group 'languages
  :prefix "tx-")

(defcustom tx-mode-hook nil
  "*Hook run by `tx-mode'."
  :type  'hook
  :group 'tx)

(defcustom tx-tag-start-char "<:"
  "*Text::Xslate default tag start charactor"
  :type  'char
  :group 'tx)

(defcustom tx-tag-end-char ":>"
  "*Text::Xslate default tag end charactor"
  :type  'char
  :group 'tx)

(defcustom tx-line-start-char ":"
  "*Text::Xslate default line start charactor"
  :type  'char
  :group 'tx)

(defcustom tx-highlight-tag-face font-lock-keyword-face
  "*Face to highlight Text::Xslate tag."
  :type  'face
  :group 'tx)

(defcustom tx-highlight-comment-face font-lock-comment-face
  "*Face to highlight Text::Xslate comment."
  :type  'face
  :group 'tx)

(defconst tx-mode-version "0.0.1" "Version of `tx-mode.'")

(run-hooks 'tx-mode-hook)

(defvar tx-font-lock-keywords
  (list
   (list (concat "\\("
                 (regexp-quote tx-tag-start-char)
                 "[^#]*\\(#.*\\)?"
                 (regexp-quote tx-tag-end-char)
                 "\\)")
         '(1 tx-highlight-tag-face nil t)
         '(2 tx-highlight-comment-face t t)))
  "Additional expressions to highlight in Text::Xslate mode.")

(tempo-define-template
 "tx-insert-tag"
 '(tx-tag-start-char " "
   (p "Value: ")
   " " tx-tag-end-char))

(tempo-define-template
 "tx-insert-line-start-char"
 '(tx-line-start-char))

(defvar tx-mode-map ()
  "Keymap used in `tx-mode' buffers.")

(if tx-mode-map
    nil
  (setq tx-mode-map (make-sparse-keymap))
  (define-key tx-mode-map "\C-ci" 'tempo-template-tx-insert-tag)
  (define-key tx-mode-map "\C-cl" 'tempo-template-tx-insert-line-start-char)
  )

(define-derived-mode tx-mode fundamental-mode "Text::Xslate"
  "Simple mode to edit Text::Xslate.

\\{tx-mode-map}"
  (set (make-local-variable 'font-lock-defaults)
       '(tx-font-lock-keywords nil nil nil nil)))

(defun tx-mode-version ()
  "Diplay version of `tx-mode'."
  (interactive)
  (message "tx-mode %s" tx-mode-version)
  tx-mode-version)

(provide 'tx-mode)
;;; tx-mode.el ends here
