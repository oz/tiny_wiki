#!/usr/bin/env perl

use KiokuDB;
use Dancer;
use Template;

use strict;

layout 'main';

my $k = KiokuDB->connect(
    'bdb:dir=/tmp/kioku-tiny-wiki',
    create => 1
);

# XXX Not sure about this: KiokuDB needs a scope object
#     so this does create at least one per request... but
#     not sure about its scope. :p
before sub { var scope => $k->new_scope; };

get '/' => sub {
    my $document = $k->lookup('home');
    $document ||= { content => 'This is the default homepage' };
    template 'page' => { document => $document, name => 'home' };
};

get '/:name' => sub {
    my $document = $k->lookup( params->{name} );
    $document ||= { content => 'Page does not exist yet... Create it?' };
    template 'page' => { document => $document, name => params->{name} };
};

get '/edit/:name' => sub {
    my $document = $k->lookup( params->{name} );
    template 'edit' => { name => params->{name}, document => $document };
};

post '/update' => sub {
    my $document = $k->lookup( params->{name} );

    if ( $document ) {
        $k->update($document);
    } else {
        $document = { content => params->{content} };
        $k->store( params->{name} => $document );
    }
    template 'page' => { document => $document, name => params->{name} };
};

Dancer->dance;
