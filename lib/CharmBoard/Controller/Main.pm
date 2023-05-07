package CharmBoard::Controller::Main;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub index ($app) {
  $app->render(template => 'index')}

1;