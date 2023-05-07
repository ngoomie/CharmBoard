package CharmBoard::Crypt::Password;
use Authen::Passphrase::Argon2;

use Exporter qw(import);
our @EXPORT = qw(passgen passchk);

# subroutine to generate password salt + hashed pw on pass creation
# outputs the salt and then the hashed pw, so when assigning vars
# from this sub's output, do it like this:
# `my ($salt, $hash) = passgen($password);`
sub passgen ($) {
  my $argon2 = Authen::Passphrase::Argon2->new(
    salt_random => 1,
    passphrase  => $_[0],
    cost        => 3,
    factor      => '32M',
    parallelism => 1,
    size        => 16 ); 

  return ($argon2->salt, $argon2->as_crypt)};

# subroutine to check inputted password against one in DB
# `$_[0]` is the salt, `$_[1]` is the hashed pass, and
# `$_[2]` is the inputted plaintext pepper:password to check
sub passchk ($$$) {
  my $argon2 = Authen::Passphrase::Argon2->new(
    salt    => $_[0],
    hash    => $_[1],
    cost        => 3,
    factor      => '32M',
    parallelism => 1,
    size        => 16 );

  return ($argon2->match($_[2]))}

1;