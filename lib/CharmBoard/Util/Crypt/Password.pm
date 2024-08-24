package CharmBoard::Util::Crypt::Password;

use utf8;
use strict;
use warnings;
use experimental qw(try);
no warnings 'experimental::try';
use feature ':5.34';

use Authen::Passphrase::Argon2;
use CharmBoard::Util::Crypt::Seasoning;

use Exporter qw(import);
our @EXPORT = qw(passgen passchk);

sub passgen {
  my $_argon2 = Authen::Passphrase::Argon2->new(
    salt        => seasoning(32),
    passphrase  => $_[0],
    cost        => 17,
    factor      => '32M',
    parallelism => 1,
    size        => 32
  );

  return ($_argon2->salt_hex, $_argon2->hash_hex)
}

sub passchk {
  my $_argon2 = Authen::Passphrase::Argon2->new(
    salt_hex    => $_[0],
    hash_hex    => $_[1],
    cost        => 17,
    factor      => '32M',
    parallelism => 1,
    size        => 32
  );

  return ($_argon2->match($_[2]))
}

1;

__END__
=pod
=head1 NAME
CharmBoard::Util::Crypt::Password - password processing module
=head1 SYNOPSIS
=begin perl
use CharmBoard::Util::Crypt::Password;

($salt, $hash) = passgen($plaintextPassword);
$passwordVerification = passchk($salt, $hash, $plaintextPassword)
=end perl
=head1 DESCRIPTION
CharmBoard::Util::Crypt::Password processes passwords, either processing
new passwords for database storage, or checking passwords entered
when logging in to make sure they're correct.

Currently the only available password hashing scheme is Argon2, but
this might be changed later on.
=head2 passgen
passgen is the function for generating password salts and hashes to
be inserted into the database. It takes the plaintext password you
wish to hash as the only argument, and outputs the salt and
Argon2 hash string in hexadecimal form.
=head2 passchk
passchk is the function for checking plaintext passwords against the
hashed password + salt already stored in the database. It takes the
salt and Argon2 hash string in hex form plus the plaintext password
as inputs, and outputs a true/false value indicating whether or not
the input  password matched. Intended for login authentication or
anywhere else where one may need to verify passwords (i.e. before
changing existing passwords, or for admins confirming they wish to
perform a risky or nonreversible operation.)
=cut
