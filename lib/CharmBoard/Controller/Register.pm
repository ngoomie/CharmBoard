package CharmBoard::Controller::Register;

use utf8;
use strict;
use warnings;
use experimental qw(try smartmatch);

use Mojo::Base 'Mojolicious::Controller', -signatures;
use CharmBoard::Model::Crypt::Password;

# initial registration page
sub register {
  my $self = shift;
  $self->render(
    template => 'register',
    error    => $self->flash('error'),
    message  => $self->flash('message')
  )
}

# process submitted registration form
sub register_do {
  my $self = shift;

  my $username        = $self->param('username');
  my $email           = $self->param('email');
  my $password        = $self->param('password');
  my $confirmPassword = $self->param('confirm-password');

  my $catchError;

  # declare vars used through multiple try/catch blocks with
  # 'our' so they work throughout the entire subroutine
  our ($userCheck, $emailCheck, $salt, $hash);

  # make sure registration info is valid
  try {
    # TODO: implement email validation here at some point

    # check to make sure all required fields are filled
    ($username, $email, $password, $confirmPassword)
        or die "Please fill out all required fields.";

    # check to make sure both passwords match
    # TODO: add check on frontend for this for people with JS enabled
    $password eq $confirmPassword
        or die "Passwords do not match";

    # check to make sure username and/or email isn't already in use;
    # if not, continue with registration
    ## search for input username and email in database
    $userCheck = $self->schema->resultset('Users')
        ->search({ username => $username })->single;
    $emailCheck = $self->schema->resultset('Users')
        ->search({ email => $email })->single;

    ($userCheck && $emailCheck) eq undef
        or die "Username already in use.\nemail already in use.";
    ($userCheck) eq undef
        or die "Username already in use.";
    ($emailCheck) eq undef
        or die "email already in use."
  } catch ($catchError) {
    $self->flash(error => $catchError);
    $self->redirect_to('register')
  }

  try {
    $password = $self->pepper . ':' . $password;

    # return hashed result + salt
    ($salt, $hash) = passgen($password) or die;

    # add user info and pw/salt to DB
    $self->schema->resultset('Users')->create({
      username    => $username,
      email       => $email,
      password    => $hash,
      salt        => $salt,
      signup_date => time
    })
        or die;

    $self->flash(message => 'User registered successfully!');
    $self->redirect_to('register')
  } catch ($catchError) {
    print $catchError;
    $self->flash(
      error =>
        'Your registration info was correct, but a server error
         prevented you from registering. This has been logged so the
         administrator can fix it.'
    );
    $self->redirect_to('register')
  }
}

1;
