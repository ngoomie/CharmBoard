#!/usr/bin/env perl
use warnings;
use strict;
use Math::Random::Secure qw( irand );

my @chars = qw( 0 1 2 3 4 5 6 7 8 9
                a b c d e f g h i j
                k l m n o p q r s t
                u v w x y z A B C D
                E F G H I J K L M N
                O P Q R S T U V W X
                Y Z ! @ $ % ^ & * /
                ? . ; : \ [ ] - _   );

my $pepper = '';
while ( length($pepper) < 25 ) {
  # gen and discard numbers to flush out dupe chance
  irand(255); irand(255); irand(255); irand(255);
  irand(255); irand(255); irand(255); irand(255);
  # gen num for pepper
  $pepper = $pepper . $chars[irand(@chars)];
}

print("Your pepper value is:\n");
print($pepper);