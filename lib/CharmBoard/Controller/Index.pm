package CharmBoard::Controller::Index;

use utf8;
use strict;
use warnings;
use experimental qw(try);
use feature ':5.20';

use Mojo::Base 'Mojolicious::Controller', -signatures;
use Tree::Simple;

sub index {
  my $self = shift;

  if ($self->session_verify eq undef) {
    $self->redirect_to('/')
  }

  $self->render(
    template      => 'index',
    category_tree => $self->model('forums')->list_full
  )
}

1;
__END__
