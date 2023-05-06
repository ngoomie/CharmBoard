package CharmBoard::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use CharmBoard::Crypt::Password;

# initial registration page
sub register ($app) { 
  $app->render(
    template => 'register',
    error    => $app->flash('error'),
    message  => $app->flash('message')
  )};

# process submitted registration form
sub registration_do ($app) { 
  my $username        = $app->param('username');
  my $email           = $app->param('email');
  my $password        = $app->param('password');
  my $confirmPassword = $app->param('confirm-password');

  # check to make sure all required fields are filled
  if ( ! $username || ! $password || ! $confirmPassword ) {
    $app->flash( error => 'All fields required.' );
    $app->redirect_to('register');
  };

  # check to make sure both passwords match
  # TODO: add check on frontend for this for people with JS enabled
  if ( $confirmPassword ne $password ) {
    $app->flash( error => 'Passwords do not match.' );
    $app->redirect_to('register');
  };

  # check to make sure username and/or email isn't already in use;
  # if not, continue with registration
  my $userCheck  = $app->schema->resultset('Users')->search({username => $username})->single;
  my $emailCheck = $app->schema->resultset('Users')->search({email => $email})->single;
  if ( $userCheck || $emailCheck ) {
    if ( $userCheck && $emailCheck ) {
      # notify user that username and email are both already being used
      $app->flash( error => 'Username and email already in use.' );
      $app->redirect_to('register');
    } elsif ( $userCheck ) {
      # notify user that only username is already in use
      $app->flash( error => 'Username is already in use.' );
      $app->redirect_to('register');
    } elsif ( $emailCheck ) {
      # notify user that only email is already in use
      $app->flash( error => 'email is already in use.' );
      $app->redirect_to('register');
    }
  } else {
    $password = $app->pepper . ':' . $password;
    my ($hash, $salt) = pass_gen($password);
    $app->schema->resultset('Users')->create({
      username    => $username,
      email       => $email,
      password    => $hash,
      salt        => $salt,
      signup_date => time
    });
    $app->flash( message => 'User registered successfully!' );
    $app->redirect_to('register');
  }};

sub login ($app) {
  $app->render(
    template => 'login',
    error    => $app->flash('error'),
    message  => $app->flash('message')
  );
}

1;