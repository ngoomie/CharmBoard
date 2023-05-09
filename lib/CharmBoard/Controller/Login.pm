package CharmBoard::Controller::Login;
use utf8;
use experimental 'try', 'smartmatch';
use Mojo::Base 'Mojolicious::Controller', -signatures;
use CharmBoard::Crypt::Password;
use CharmBoard::Crypt::Seasoning;

=pod
=head1 NAME
CharmBoard::Controller::Login
=cut

sub login ($self) {
  $self->render(
    template => 'login',
    error    => $self->flash('error'),
    message  => $self->flash('message'))};

sub login_do ($self) {
  my $username = $self->param('username');
  my $password = $self->pepper . ':' . $self->param('password');

  my $catchError;

  # declare vars used through multiple try/catch blocks with
  # 'our' so they work throughout the entire subroutine
  our ($userInfo, $passCheck, $userID, $sessionKey);

  try { # check user credentials first
    # check to see if user by entered username exists
    $userInfo = $self->schema->resultset('Users')->search(
      {username => $username});
    $userInfo or die;

    # now check password validity
    $passCheck = passchk($userInfo->get_column('salt')->first,
      $userInfo->get_column('password')->first, $password);
    $passCheck or die;}

  catch ($catchError) { # redirect to login page on fail
    print $catchError;
    $self->flash(error => 'Username or password incorrect.');
    $self->redirect_to('login');}

  try { # now attempt to create session
    # get user ID for session creation
    $userID = $userInfo->get_column('user_id')->first;

    # gen session key
    $sessionKey = seasoning(16);

    # add session to database
    $self->schema->resultset('Session')->create({
      session_key    => $sessionKey,
      user_id        => $userID,
      session_expiry => time + 604800,
      is_ip_bound    => 0,
      bound_ip       => undef }) or die;
    
    # now create session cookie for user
    $self->session(is_auth     => 1);
    $self->session(user_id     => $userID);
    $self->session(session_key => $sessionKey);
    $self->session(expiration  => 604800);
    
    # redirect to index upon success
    $self->redirect_to('/')}
    
  catch ($catchError) { # redirect to login page on fail
    print $catchError;
    $self->flash(error => 'Your username and password were correct,
      but a server error prevented you from logging in. This has been
      logged so the administrator can fix it.');
    $self->redirect_to('login')}}

1;