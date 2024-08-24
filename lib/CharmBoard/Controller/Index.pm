package CharmBoard::Controller::Index;

use utf8;
use strict;
use warnings;
use experimental qw(try);
no warnings 'experimental::try';
use feature ':5.34';

use Mojo::Base 'Mojolicious::Controller', -signatures;
use Tree::Simple;

sub index {
  my $c = shift;

  if ($c->session_verify eq undef) {
    $c->redirect_to('/')
  }

  $c->render(
    template      => 'index',
    category_tree => $c->model('forums')->list_full
  )
}

1;
__END__
