Flycheck-wordlint.el provides flycheck support for the Wordlint program written
in Haskell
[https://github.com/gbgar/Wordlint](https://github.com/gbgar/Wordlint).

#Installation

#Prerequisites

This checker relies on an external tool, `wordlint`, which must be
installed to your system and locatable by Emacs. Installation
instructions may be found on the
[github page](https://github.com/gbgar/Wordlint).

##Manual

Retrieve flycheck-wordlint.el and copy it to your emacs plugin directory, i.e.
~/.emacs.d/plugs/, which is available in your load-path.

Add

	(require 'flycheck-wordlint)

to your Emacs init file.

## Set flycheck-wordlint-custom-modes (Required)
Unlike most flycheck checkers, activation of the `wordlint`
checker is dependent on the user setting the variable
`flycheck-wordlint-custom-modes`. For example,

    (setq flycheck-wordlint-custom-modes '(markdown-mode text-mode))

will activate this checker in those modes. Without this custom
setting, the `wordlint' checker will not be activated.

##Set wordlint-custom-args (Strongly suggested)

IMPORTANT: With its default settings, Wordlint will invariably produce
many errors.  This is due to the output format in which each word--and
not pair of words--is treated as an error, effectively doubling the
amount of data handled by flycheck. Two solutions exist to this
problem.

The recommended solution is, prior to enabling the Wordlint checker,
to increase the strictness of the matching by customizing the variable
`flycheck-wordlint-custom-args'. For example,

	(setq flycheck-wordlint-custom-args
		'("-w" "50" "-m" "8" "-b" "blacklist.txt"))

raises the minimum match length and significantly lowers the
distance threshold in order to find words that are longer and
closer to their match. Likely, the best way to accomplish this is
to create a blacklist file for frequently-used proper names and
other unavoidably-repeated words.

Not recommended, but possible is to set the
`flycheck-checker-error-threshold` variable to `nil` (or a higher
value than 400 if your text documents are of large size). In a ~10,500
word document (~1,100 "errors"), removing the limit severely impacted
Emacs' perfomance.

#Use

Flycheck-wordlint.el is a flycheck syntax checker, and use follows normal
flycheck use, except where noted above.

