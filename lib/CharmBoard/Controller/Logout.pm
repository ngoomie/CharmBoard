package CharmBoard::Controller::Logout;

use utf8;
use strict;
use warnings;
use experimental qw(try);
no warnings 'experimental::try';
use feature ':5.34';

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub logout_do {
  my $c = shift;

  $c->session_destroy;

  # redirect to index
  $c->redirect_to('/')
}

1;
__END__
