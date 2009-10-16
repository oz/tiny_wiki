package TinyWiki;

use Dancer;
use KiokuDB;
use Template;
use Text::Markdown 'markdown';

use lib 'lib';
use TinyWiki::User;

layout 'main';

my $k = KiokuDB->connect(
    'bdb:dir=/tmp/kioku-tiny-wiki',
    create => 1
);

# XXX Not sure about this: KiokuDB needs a scope object
#     so this does create at least one per request... but
#     not sure about its scope. :p
before sub { var scope => $k->new_scope; };

# Read-only actions 

get '/' => sub {
    my $document = $k->lookup('home');

    $document ||= { content => 'This is the default homepage' };
    template 'page' => {
        document => markdown( $document->{content} ),
        name     => 'home',
        session  => session,
    };
};

# Dumb login action
get  '/login' => sub { template 'login' };
post '/login' => sub {
    my $user = TinyWiki::User::authenticate_user(params);
    if (defined $user) {
        session user => $user->{login};
        "you have signed in as ".$user->{login};
    }
    else {
        template 'login', {error => "bad credentials" };
    }
};

get '/logout' => sub {
    session user => undef;
    "you have signed out"
};

# display a page
get '/:name' => sub {
    my $document = $k->lookup( params->{name} );

    $document ||= { content => 'Page does not exist yet... Create it?' };
    template 'page' => { document => markdown($document->{content}), name => params->{name} };
};

# Write actions (user is mandatory)


get '/edit/:name' => sub {
    my $document = $k->lookup( params->{name} );

    template 'edit' => { name => params->{name}, document => $document };
};

post '/update' => sub {
    my $document = $k->lookup( params->{name} );

    if ( $document ) {
        $document->{content} = params->{content};
        $k->update($document);
    } else {
        $document = { content => params->{content} };
        $k->store( params->{name} => $document );
    }
    template 'page' => { document => markdown($document->{content}), name => params->{name} };
};

1;
