package CharmBoard::Schema;
use strict;
use warnings;
use experimental qw(try smartmatch);
use utf8;
use base qw(DBIx::Class::Schema);

__PACKAGE__->load_namespaces(
  result_namespace => 'Source',
  resultset_namespace => 'Set');

1;

__END__