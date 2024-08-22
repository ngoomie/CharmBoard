package CharmBoard::Controller::Login;

use utf8;
use strict;
use warnings;
use experimental qw(try);
use feature ':5.20';

use Mojo::Base 'Mojolicious::Controller', -signatures;
use CharmBoard::Util::Crypt::Password;
use CharmBoard::Util::Crypt::Seasoning;

sub login {
  my $self = shift;

  $self->render(
    template => 'login',
    error    => $self->flash('error'),
    message  => $self->flash('message')
  )
}

sub login_do {
  my $self     = shift;
  my $username = $self->param('username');
  my $password = $self->pepper . ':' . $self->param('password');

  my $catch_error;

  # declare vars used through multiple try/catch blocks with
  # 'our' so they work throughout the entire subroutine
  our ($user_info, $pass_check, $user_id, $session_key);

  # check user credentials first
  try {
    # check to see if user by entered username exists
    $user_info = $self->schema->resultset('Users')
        ->search({ username => $username });
    $user_info or die;

    # now check password validity
    $pass_check = passchk($user_info->get_column('salt')->first,
      $user_info->get_column('password')->first, $password);
    $pass_check or die;

  } catch ($catch_error) {    # redirect to login page on fail
    print $catch_error;
    $self->flash(error => 'Username or password incorrect.');
    $self->redirect_to('login');
  }

  try {                       # now attempt to create session
                              # get user ID for session creation
    $user_id = $user_info->get_column('user_id')->first;

    $self->session_create($user_id);

    # redirect to index upon success
    $self->redirect_to('/')

  } catch ($catch_error) {    # redirect to login page on fail
    print $catch_error;
    $self->flash(
      error => 'Your username and password were correct, but a server
          error prevented you from logging in. This has been logged
          so the administrator can fix it.'
    );
    $self->redirect_to('login')
  }
}

1;

__END__
=pod
=head1 NAME
CharmBoard::Controller::Login
=cut
