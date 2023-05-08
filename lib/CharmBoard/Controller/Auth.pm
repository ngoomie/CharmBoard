package CharmBoard::Controller::Auth;
use experimental 'try', 'smartmatch';
use Mojo::Base 'Mojolicious::Controller', -signatures;
use CharmBoard::Crypt::Password;
use CharmBoard::Crypt::Seasoning;

# initial registration page
sub register ($app) { 
  $app->render(
    template => 'register',
    error    => $app->flash('error'),
    message  => $app->flash('message'))};

# process submitted registration form
sub register_do ($app) { 
  my $username        = $app->param('username');
  my $email           = $app->param('email');
  my $password        = $app->param('password');
  my $confirmPassword = $app->param('confirm-password');

  my $catchError;

  # declare vars used through multiple try/catch blocks with
  # 'our' so they work throughout the entire subroutine
  our ($userCheck, $emailCheck, $salt, $hash);

  try { # make sure registration info is valid
    # TODO: implement email validation here at some point

    # check to make sure all required fields are filled
    ($username, $email, $password, $confirmPassword) ne undef
      or die "Please fill out all required fields.";

    # check to make sure both passwords match
    # TODO: add check on frontend for this for people with JS enabled
    $password eq $confirmPassword
      or die "Passwords do not match";

    # check to make sure username and/or email isn't already in use;
    # if not, continue with registration
    ## search for input username and email in database
    $userCheck  = $app->schema->resultset('Users')->search({username => $username})->single;
    $emailCheck = $app->schema->resultset('Users')->search({email => $email})->single;

    ($userCheck && $emailCheck) eq undef
      or die "Username already in use.\nemail already in use.";
    ($userCheck) eq undef
      or die  "Username already in use.";
    ($emailCheck) eq undef
      or die "email already in use."}
  catch ($catchError) {
    $app->flash(error => $catchError);
    $app->redirect_to('register');}

  try {
    $password = $app->pepper . ':' . $password;
    # return hashed result + salt
    ($salt, $hash) = passgen($password) or die;

    # add user info and pw/salt to DB
    $app->schema->resultset('Users')->create({
      username    => $username,
      email       => $email,
      password    => $hash,
      salt        => $salt,
      signup_date => time }) or die;

    $app->flash(message => 'User registered successfully!');
    $app->redirect_to('register')}
  catch ($catchError) {
    print $catchError;
    $app->flash(error => 'Your registration info was correct,
      but a server error prevented you from registering.
      This has been logged so your administrator can fix it.');
    $app->redirect_to('register')}};

sub login ($app) {
  $app->render(
    template => 'login',
    error    => $app->flash('error'),
    message  => $app->flash('message'))};

sub login_do ($app) {
  my $username = $app->param('username');
  my $password = $app->pepper . ':' . $app->param('password');

  my $catchError;

  # declare vars used through multiple try/catch blocks with
  # 'our' so they work throughout the entire subroutine
  our ($userInfo, $passCheck, $userID, $sessionKey);

  try { # check user credentials first
    # check to see if user by entered username exists
    $userInfo = $app->schema->resultset('Users')->search({username => $username});
    $userInfo or die;

    # now check password validity
    $passCheck = passchk($userInfo->get_column('salt')->first,
      $userInfo->get_column('password')->first, $password);
    $passCheck or die;}

  catch ($catchError) { # redirect to login page on fail
    print $catchError;
    $app->flash(error => 'Username or password incorrect.');
    $app->redirect_to('login');}

  try { # now attempt to create session
    # get user ID for session creation
    $userID = $userInfo->get_column('user_id')->first;

    # gen session key
    $sessionKey = seasoning(16);

    # add session to database
    $app->schema->resultset('Session')->create({
      session_key    => $sessionKey,
      user_id        => $userID,
      session_expiry => time + 604800,
      is_ip_bound    => 0,
      bound_ip       => undef }) or die;
    
    # now create session cookie for user
    $app->session(is_auth     => 1);
    $app->session(user_id     => $userID);
    $app->session(session_key => $sessionKey);
    $app->session(expiration  => 604800);
    
    # redirect to index upon success
    $app->redirect_to('/')}
    
  catch ($catchError) { # redirect to login page on fail
    print $catchError;
    $app->flash(error => 'Your username and password were correct,
      but a server error prevented you from logging in.
      This has been logged so your administrator can fix it.');
    $app->redirect_to('login')}}

1;