# Xi mode for Emacs

This is major mode for Emacs that provides a way to start up a Xi REPL.

## Installation

Because Xi is still in alpha stage, this mode is not available on MELPA yet.

You will need to download the repository somewhere (suppose `~/emacs-xi`), and
add the following lines to your `.emacs` or `.emacs.d/init.el` files:

    (add-to-list 'load-path "~/emacs-xi")
    (require 'xi)

## Usage

Enable Xi mode with `M-x xi-mode`.  If you open a file ending with `.xi`
extension, mode will activate automatically.

Then press `C-c C-s` to start Xi REPL.

The default bindings are:

* `C-c C-s`: Start Xi
* `C-c C-q`: Quit Xi
* `C-c C-c`: Run current line
* `C-c C-e` or `C-return`: Run multiple lines
* `C-c C-r`: Run region
* `C-c C-v`: Show output

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/xi-livecode/xi. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The MIT License (MIT)

Copyright (c) 2017 Damián Emiliano Silvani

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
