package CharmBoard::Schema::Set::Threads;

use utf8;
use strict;
use warnings;
use experimental qw(try smartmatch);

use base 'DBIx::Class::ResultSet';

sub fetch_by_subf {
  my $_set = shift;

  my $_fetch =
      $_set->search({ 'thread_subf' => $_[0] });

  return ($_fetch->get_column('thread_id')->all)
}

sub title_from_id {
  my $_set = shift;

  return ($_set->search({ 'thread_id' => $_[0] })
        ->get_column('thread_title')->first)
}

1;
__END__
