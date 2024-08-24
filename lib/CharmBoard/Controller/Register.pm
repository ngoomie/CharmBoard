package CharmBoard::Controller::Register;

use utf8;
use strict;
use warnings;
use experimental qw(try);
use feature ':5.20';

use Mojo::Base 'Mojolicious::Controller', -signatures;
use CharmBoard::Util::Crypt::Password;

# initial registration page
sub register {
  my $c = shift;
  $c->render(
    template => 'register',
    error    => $c->flash('error'),
    message  => $c->flash('message')
  )
}

# process submitted registration form
sub register_do {
  my $c = shift;

  my $username         = $c->param('username');
  my $email            = $c->param('email');
  my $password         = $c->param('password');
  my $confirm_password = $c->param('confirm-password');

  my $catch_error;

  # declare vars used through multiple try/catch blocks with
  # 'our' so they work throughout the entire subroutine
  our ($user_check, $email_check, $salt, $hash);

  # make sure registration info is valid
  try {
    # TODO: implement email validation here at some point

    # check to make sure all required fields are filled
    ($username, $email, $password, $confirm_password)
        or die "Please fill out all required fields.";

    # check to make sure both passwords match
    # TODO: add check on frontend for this for people with JS enabled
    $password eq $confirm_password
        or die "Passwords do not match";

    # check to make sure username and/or email isn't already in use;
    # if not, continue with registration
    ## search for input username and email in database
    $user_check = $c->schema->resultset('Users')
        ->search({ username => $username })->single;
    $email_check = $c->schema->resultset('Users')
        ->search({ email => $email })->single;

    # TODO: compress this into something less redundant
    ($user_check && $email_check) eq undef
        or die "Username already in use.\nemail already in use.";
    ($user_check) eq undef
        or die "Username already in use.";
    ($email_check) eq undef
        or die "email already in use."
  } catch ($catch_error) {
    $c->flash(error => $catch_error);
    $c->redirect_to('register')
  }

  try {
    $password = $c->pepper . ':' . $password;

    # return hashed result + salt
    ($salt, $hash) = passgen($password) or die;

    # add user info and pw/salt to DB
    $c->schema->resultset('Users')->create({
      username    => $username,
      email       => $email,
      password    => $hash,
      salt        => $salt,
      signup_date => time
    })
        or die;

    $c->flash(message => 'User registered successfully!');
    $c->redirect_to('register')
  } catch ($catch_error) {
    print $catch_error;
    $c->flash(
      error =>
        'Your registration info was correct, but a server error
         prevented you from registering. This has been logged so the
         administrator can fix it.'
    );
    $c->redirect_to('register')
  }
}

1;
