package CharmBoard::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use CharmBoard::Crypt::Password;
use CharmBoard::Crypt::Seasoning;

# initial registration page
sub register ($app) { 
  $app->render(
    template => 'register',
    error    => $app->flash('error'),
    message  => $app->flash('message')
  )};

# process submitted registration form
# TODO: implement email validation here at some point
sub register_do ($app) { 
  my $username        = $app->param('username');
  my $email           = $app->param('email');
  my $password        = $app->param('password');
  my $confirmPassword = $app->param('confirm-password');

  # check to make sure all required fields are filled
  if (! $username || ! $password || ! $confirmPassword) {
    $app->flash(error => 'All fields required.');
    $app->redirect_to('register')};

  # check to make sure both passwords match
  # TODO: add check on frontend for this for people with JS enabled
  if ($confirmPassword ne $password) {
    $app->flash(error => 'Passwords do not match.');
    $app->redirect_to('register')};

  # check to make sure username and/or email isn't already in use;
  # if not, continue with registration
  ## search for input username and email in database
  my $userCheck  = $app->schema->resultset('Users')->search({username => $username})->single;
  my $emailCheck = $app->schema->resultset('Users')->search({email => $email})->single;

  if ($userCheck || $emailCheck) {
    if ($userCheck && $emailCheck) { # notify user that username and email are both already being used
      $app->flash(error => 'Username and email already in use.');
      $app->redirect_to('register')}

    elsif ($userCheck) { # notify user that only username is already in use
      $app->flash(error => 'Username is already in use.');
      $app->redirect_to('register')}

    elsif ($emailCheck) { # notify user that only email is already in use
      $app->flash(error => 'email is already in use.');
      $app->redirect_to('register')}}

    else { # TODO: add more error handling here, in case SQL transact fails
    # append pepper to pass before hashing
    $password = $app->pepper . ':' . $password;
    # return hashed result + salt
    my ($salt, $hash) = passgen($password);

    # add user info and pw/salt to DB
    $app->schema->resultset('Users')->create({
      username    => $username,
      email       => $email,
      password    => $hash,
      salt        => $salt,
      signup_date => time });

    $app->flash(message => 'User registered successfully!');
    $app->redirect_to('register')}};

sub login ($app) {
  $app->render(
    template => 'login',
    error    => $app->flash('error'),
    message  => $app->flash('message'))};

sub login_do ($app) {
  my $username = $app->param('username');
  my $password = $app->pepper . ':' . $app->param('password');

  my $userInfoCheck = $app->schema->resultset('Users')->search({username => $username});

  if ($userInfoCheck) {
    my $passCheckStatus = passchk($userInfoCheck->get_column('salt')->first,
        $userInfoCheck->get_column('password')->first, $password);

    if ($passCheckStatus) {
      my $userID = $userInfoCheck->get_column('user_id')->first;

      # delete old session from DB if exists
      if ($app->schema->resultset('Session')->search({user_id => $userID})) {
        $app->schema->resultset('Session')->search({user_id => $userID})->delete; };

      # gen session key and set expiry time
      my $sessionKey = seasoning(16);
      my $sessionExpiry = time + 604800;

      # add session to database
      $app->schema->resultset('Session')->create({
      user_id        => $userID,
      session_key    => $sessionKey,
      session_expiry => $sessionExpiry,
      is_ip_bound    => 0,
      bound_ip       => undef });

      # now create session cookie for user
      $app->session(is_auth => 1);
      $app->session(user_id => $userID);
      $app->session(session_key => $sessionKey);
      $app->session(expires => $sessionExpiry);

      # redirect to index
      $app->redirect_to('/')}

    else {
      $app->flash(error => 'Password incorrect');
      $app->redirect_to('login')}}

  else {
    $app->flash(error => 'User ' . $username . ' does not exist.');
    $app->redirect_to('login')};

}

1;