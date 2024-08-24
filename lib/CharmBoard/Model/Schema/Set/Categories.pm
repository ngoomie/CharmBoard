package CharmBoard::Model::Schema::Set::Categories;

use utf8;
use strict;
use warnings;
use experimental qw(try);
use feature ':5.20';

use base 'DBIx::Class::ResultSet';

sub fetch_all {
  my $set = shift;

  my $_fetch = $set->search({}, { order_by => 'cat_rank' });

  return ($_fetch->get_column('cat_id')->all)
}

sub title_from_id {
  my $set = shift;

  return (
    $set->search({ 'cat_id' => $_[0] })->get_column('cat_name')
        ->first)
}

1;

__END__
=pod
=head1 NAME
CharmBoard::Model::Schema::Set::Categories - DBIC ResultSet for the
categories table

=head1 SYNOPSIS
=head1 DESCRIPTION
=cut
