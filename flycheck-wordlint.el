;;; flycheck-wordlint.el --- Wordlint support for flycheck.
;;; Author: GB Gardner
;;; Commentary:
;;; 
;;; This package provides an interface to the Wordlint program written
;;; in Haskell (https://github.com/gbgar/Wordlint). As such, the
;;; `wordlint` program must be installed to your system and located in
;;; Emacs' path. Installation instructions may be found on the github
;;; page.
;;;
;;; Notes and Caveats:
;;;
;;; 1) Unlike most flycheck checkers, activation of the `wordlint'
;;; checker is dependent on the user setting the variable
;;; `flycheck-wordlint-custom-modes'. For example,
;;;
;;;     (setq flycheck-wordlint-custom-modes '(markdown-mode text-mode))
;;;
;;; will activate this checker in those modes. Without this custom
;;; setting, the `wordlint' checker will not be activated.
;;;
;;;
;;; 2) WARNING: With its default settings, Wordlint will invariably
;;; produce many errors.  This is due to the output format in which
;;; each word, and not pair of words is treated as an error,
;;; effectively doubling the amount of data handled by flycheck. Two
;;; solutions exist to this problem.
;;;
;;; The recommended solution is, prior to enabling the Wordlint
;;; checker, to increase the strictness of the matching by customizing
;;; the variable `flycheck-wordlint-custom-args'. For example,
;;;
;;; (setq flycheck-wordlint-custom-args
;;;       '("-w" "50" "-m" "8" "-b" "blacklist.txt"))
;;;
;;; raises the minimum match length and significantly lowers the
;;; distance threshold in order to find words that are longer and
;;; closer to their match. Likely, the best way to accomplish this is
;;; to create a blacklist file for frequently-used proper names and
;;; other unavoidably-repeated words.
;;;
;;; Not recommended, but possible is to set the
;;; `flycheck-checker-error-threshold' variable to `nil' (or a higher
;;; value than 400 if your text documents are of large size). In a
;;; ~10,500 word document, removing the limit severely impacted Emacs'
;;; perfomance.
;;;
;;; Code:

(require 'flycheck)

(defgroup flycheck-wordlint nil
  "Prose redundancy linting support for Flycheck."
  :prefix "flycheck-haskell-"
  :group 'flycheck
  :link '(url-link :tag "Github" "https://github.com/gbgar/flycheck-wordlint"))

(defcustom flycheck-wordlint-executable "wordlint"
  "Path to the `wordlint' executable."
  :type `(file :must-match t)
  :group 'flycheck-wordlint)

(defcustom flycheck-wordlint-custom-args nil
  "Custom arguments to use for Wordlint.

This variable accepts a list of strings representing Wordlint
parameters, for example, '("-w" "50" "-m" "-7").

The `--matchlength` flag; up to three linter options (`-w`, `-l`,
and/or `-p`) or the `--all` output flag; and any combination of filter
functions are acceptable arguments.  See `wordlint --help`, the
wordlint man page, or the wordlint README for a full list of available
options."

:group 'flycheck-wordlint :type 'list)

(defcustom flycheck-wordlint-custom-modes '(markdown-mode org-mode)
  "Path to the `wordlint' executable."
  :group 'flycheck-wordlint
  :type  'list)

;; (defvar flycheck-wordlint-args flycheck-wordlint-custom-args
;;   "Variable containing preset arguments for Wordlint.")

;; (defvar flycheck-wordlint-modes flycheck-wordlint-custom-modes
;;    "Variable containing modes in which to activate flychck-wordlint.")

(defun flycheck-wordlint-test-major-mode ()
  "Test `major-mode' against list of Wordlint modes."
  (memq major-mode flycheck-wordlint-custom-modes))

(flycheck-define-checker wordlint
  "A prose redudancy checker written in Haskell.

See URL `https://github.com/gbgar/Wordlint'."
  :command ("wordlint"
	    (eval flycheck-wordlint-custom-args)
            "--sort" "error"
	    "--file" source)
  :error-patterns
  ((warning line-start (file-name) ":" line ":" column ":"
          (message) line-end))
  :predicate (lambda () '(flycheck-wordlint-test-major-mode)))
(add-to-list 'flycheck-checkers 'wordlint)
(provide 'flycheck-wordlint)
;;; flycheck-wordlint.el ends here
