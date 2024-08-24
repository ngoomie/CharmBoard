package CharmBoard::Controller::Login;

use utf8;
use strict;
use warnings;
use experimental qw(try);
no warnings 'experimental::try';
use feature ':5.34';

use Mojo::Base 'Mojolicious::Controller', -signatures;
use CharmBoard::Util::Crypt::Password;
use CharmBoard::Util::Crypt::Seasoning;

sub login {
  my $c = shift;

  $c->render(
    template => 'login',
    error    => $c->flash('error'),
    message  => $c->flash('message')
  )
}

sub login_do {
  my $c        = shift;
  my $username = $c->param('username');
  my $password = $c->pepper . ':' . $c->param('password');

  my $catch_error;

  # declare vars used through multiple try/catch blocks with
  # 'our' so they work throughout the entire subroutine
  our ($user_info, $pass_check, $user_id, $session_key);

  # check user credentials first
  try {
    # check to see if user by entered username exists
    $user_info = $c->schema->resultset('Users')
        ->search({ username => $username });
    $user_info or die;

    # now check password validity
    $pass_check = passchk($user_info->get_column('salt')->first,
      $user_info->get_column('password')->first, $password);
    $pass_check or die;

  } catch ($catch_error) {    # redirect to login page on fail
    print $catch_error;
    $c->flash(error => 'Username or password incorrect.');
    $c->redirect_to('login');
  }

  try {                       # now attempt to create session
                              # get user ID for session creation
    $user_id = $user_info->get_column('user_id')->first;

    $c->session_create($user_id);

    # redirect to index upon success
    $c->redirect_to('/')

  } catch ($catch_error) {    # redirect to login page on fail
    print $catch_error;
    $c->flash(
      error =>
          'Your username and password were correct, but a server
          error prevented you from logging in. This has been logged
          so the administrator can fix it.'
    );
    $c->redirect_to('login')
  }
}

1;

__END__
=pod
=head1 NAME
CharmBoard::Controller::Login
=cut
