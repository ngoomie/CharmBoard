package CharmBoard::Crypt::Password;
use utf8;
use Authen::Passphrase::Argon2;
use CharmBoard::Crypt::Seasoning;

use Exporter qw(import);
our @EXPORT = qw(passgen passchk);

=pod
=encoding utf8
=head1 NAME
CharmBoard::Crypt::Password - password processing module
=head1 SYNOPSIS
=begin perl
use CharmBoard::Crypt::Password;

my ($salt, $hash) =
  passgen($plaintextPassword);

$passwordVerification =
  passchk($salt, $hash, $plaintextPassword)
=end perl
=head1 DESCRIPTION
CharmBoard::Crypt::Password processes passwords, either
processing new passwords for database storage, or checking
passwords entered when logging in to make sure they're
correct.

Currently the only available password hashing scheme is
Argon2, but this might be changed later on.
=over
=cut

=pod
=item passgen
passgen is the function for generating password salts and
hashes to be inserted into the database. It takes the
plaintext password you wish to hash as the only argument,
and outputs the salt and Argon2 hash string in hexadecimal
form.
=cut
sub passgen ($) {
  my $argon2 = Authen::Passphrase::Argon2->new(
    salt        => seasoning(32),
    passphrase  => $_[0],
    cost        => 17,
    factor      => '32M',
    parallelism => 1,
    size        => 32 ); 

  return ($argon2->salt_hex, $argon2->hash_hex)};

=pod
=item passchk
passchk is the function for checking plaintext passwords
against the hashed password + salt already stored in the
database. It takes the salt and Argon2 hash string in hex
form plus the plaintext password as inputs, and outputs a
true/false value indicating whether or not the input
password matched. Intended for login authentication or
anywhere else where one may need to verify passwords (i.e.
before changing existing passwords, or for admins
confirming they wish to perform a risky or nonreversible
operation.)
=back
=cut
sub passchk ($$$) {
  my $argon2 = Authen::Passphrase::Argon2->new(
    salt_hex    => $_[0],
    hash_hex    => $_[1],
    cost        => 17,
    factor      => '32M',
    parallelism => 1,
    size        => 32 );

  return ($argon2->match($_[2]))}

1;