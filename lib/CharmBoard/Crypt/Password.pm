package CharmBoard::Crypt::Password;
use Authen::Passphrase::Argon2;

use Exporter qw(import);

our @EXPORT = qw/ pass_gen /;

sub pass_gen ($) {
  my $argon2 = Authen::Passphrase::Argon2->new(
    salt_random => 1,
    passphrase => $_[0],
    cost => 3,
    factor => '16M',
    parallelism => 1,
    size => 32
  ); 

  return ($argon2->salt_hex, $argon2->as_hex);
}

1;