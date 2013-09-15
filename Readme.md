MacNokinpy
==========

A script to (*somewhat*) improve the code formatting in the epub
version of O'Reilly's _Mastering Algorithms with C_ by Kyle
Loudon.

The book itself is good, but the code formatting is so bad as to
cripple the book. This script at least reduces the size of the
block comments, fixes the spacing with `indent`, and runs the
result through Pygments for syntax highlighting.

Dependencies
------------
Requires the following commandline tools:
        * indent
        * zip/unzip
        * pygmentize
        * ruby
        * rake

And the following gems:
        * nokogiri

Uses `open3` from the Ruby Standard Library, which works well on
Linux. I'd imagine it would be fine on OS X, but I've heard it
doesn't work seemlessly on Windows.

Usage
-----
Copy the _Mastering Algorithms with C_ epub to the macnokinpy
folder.

Ensure it is *exactly* named "Mastering Algorithms with C - Kyle Loudon.epub"

From within that folder, run `rake`.

To leave everything open so that you can further modify the css
file ('OEBPS/core.css' after unzipping the epub file), run
`rake reformat`. After modifying core.css, you'll need to manually
zip OEBPS, mimetype, and META-INF into a zipfile and then rename
that file's extension from .zip to .epub.

Disclaimer
----------
Back up your original epub file in an entirely separate directory.
This script could destroy everything, although it's not meant to.

Note
----
`rake fix` is a necessary step in this process for my version of the
book. It's possible that for different version of the book the
code in `rake fix` is either insufficient or incorrect. If the script
successfully reformats a number of html files before crashing, your
version of the file might require a different set of fixes.

