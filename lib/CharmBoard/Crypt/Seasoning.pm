package CharmBoard::Crypt::Seasoning;
use utf8;
use Math::Random::Secure qw(irand);

use Exporter qw(import);
our @EXPORT = qw(seasoning);

sub seasoning ($) {
  my @spices = qw(0 1 2 3 4 5 6 7 8 9 a b c d e f g
  h i j k l m n o p q r s t u v w x y z A B C D E F
  G H I J K L M N O P Q R S T U V W X Y Z ! @ $ % ^
  & * / ? . ; : \ [ ] - _ < > ` ~ + = £ ¥ ¢);

  my $blend;
  while (length($blend) < $_[0]) {
  # gen num to choose char for $blend
  $blend = $blend . $spices[irand(@spices)]};
  
  return ($blend); }

1;