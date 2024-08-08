package CharmBoard::Model::Schema::Set::Subforums;

use utf8;
use strict;
use warnings;
use experimental qw(try smartmatch);

use base 'DBIx::Class::ResultSet';

sub fetch_by_cat {
  my $_set = shift;

  my $_fetch = $_set->search({ 'subf_cat' => $_[0] },
    { order_by => 'subf_rank' });

  return ($_fetch->get_column('subf_id')->all)
}

sub cat_from_id {
  my $_set = shift;

  return (
    $_set->search({ 'subf_id' => $_[0] })->get_column('subf_cat')
        ->first)
}

sub title_from_id {
  my $_set = shift;

  return ($_set->search({ 'subf_id' => $_[0] })
        ->get_column('subf_name')->first)
}

1;
__END__
