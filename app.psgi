# This is a PSGI application file for Apache+Plack support
use CGI::PSGI;
use lib '/home/sukria/Bureau/Development/tiny_wiki';
use tiny_wiki;

use Dancer::Config 'setting';
setting apphandler  => 'PSGI';
setting environment => 'production';
Dancer::Config->load;

my $handler = sub {
    my $env = shift;
    Dancer->dance(CGI::PSGI->new($env));
};
