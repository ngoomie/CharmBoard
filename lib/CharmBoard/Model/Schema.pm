package CharmBoard::Model::Schema;

use utf8;
use strict;
use warnings;
use experimental qw(try);
no warnings 'experimental::try';
use feature ':5.34';

use base qw(DBIx::Class::Schema);

__PACKAGE__->load_namespaces(
  result_namespace    => 'Source',
  resultset_namespace => 'Set'
);

1;

__END__
