package CharmBoard::Controller::Logout;
use utf8;
use experimental 'try', 'smartmatch';
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub logout_do ($self) {
  # destroy entry for this session in the database
  $self->schema->resultset('Session')->search({
    session_key => $self->session('session_key')})->delete;
  # now nuke the actual session cookie
  $self->session(expires => 1);
  # redirect to index
  $self->redirect_to('/')}

1;