package CharmBoard::Util::Crypt::Seasoning;

use utf8;
use strict;
use warnings;
use experimental qw(try);
use feature ':5.20';

use Math::Random::Secure qw(irand);

use Exporter qw(import);
our @EXPORT = qw(seasoning);

sub seasoning {
  my @_spices = qw(0 1 2 3 4 5 6 7 8 9 a b c d e f g
      h i j k l m n o p q r s t u v w x y z A B C D E F
      G H I J K L M N O P Q R S T U V W X Y Z ! @ $ % ^
      & * / ? . ; : \ [ ] - _ < > ` ~ + = £ ¥ ¢ §);

  my $_blend;
  while (length($_blend) < $_[0]) {

    # gen num to choose char for $blend
    $_blend = $_blend . $_spices[ irand(@_spices) ]
  }

  return ($_blend)
}

1;
__END__
