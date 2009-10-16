package TinyWiki::User;

sub authenticate_user { 
    my ($params) = @_;

    # here should come the real authentication
    return { login => $params->{'login'} };
}

1;
