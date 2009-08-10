TinyWiki: a tiny wiki
=====================


TinyWiki is an quick experimentation on mixing two cool Perl modules:

 * KiokuDB
 * Dancer

It's a ridiculously lame wiki built in 50 lines of clean (hopefully) Perl
code.  I hope you like them.

-- Arnaud.


Dependencies
------------

Well, you need Dancer, and KiokuDB obviously. At some point, you may have
to type these lines :

    $ cpan install Dancer
    $ cpan install KiokuDB
    $ cpan install KiokuDB::Backend::BDB


Running
-------

Just launch app.pl
