package CharmBoard::Schema;
use base qw(DBIx::Class::Schema);

__PACKAGE__->load_namespaces(
  result_namespace => 'Source',
  resultset_namespace => 'Set');

1;