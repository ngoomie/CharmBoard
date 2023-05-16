package CharmBoard::Schema::Set::Subforums;

use utf8;
use strict;
use warnings;
use experimental qw(try smartmatch);

use base 'DBIx::Class::ResultSet';

sub fetch_by_cat {
  my $set = shift;

  my $fetch =
    $set->search(
      {'subf_cat' => $_[0]      },
      {order_by   => 'subf_rank'});

  return($fetch->get_column('subf_id')->all)}

sub title_from_id {
  my $set = shift;

  return(
    $set->search({'subf_id' => $_[0]})->
      get_column('subf_name')->first)}

1;
__END__