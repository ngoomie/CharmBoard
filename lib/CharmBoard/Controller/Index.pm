package CharmBoard::Controller::Index;
use utf8;
use experimental 'try', 'smartmatch';
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub index ($self) {
  $self->render(template => 'index')
  
  }

1;