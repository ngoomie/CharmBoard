package CharmBoard::Model::Schema::Set::Session;

use utf8;
use strict;
use warnings;
use experimental qw(try);
no warnings 'experimental::try';
use feature ':5.34';

use base 'DBIx::Class::ResultSet';

sub session_uid {
  my $set = shift;

  return (
    $set->search({ 'session_key' => $_[0] })->get_column('user_id')
      ->first)
}

sub session_expiry {
  my $set = shift;

  return (
    $set->search({ 'session_key' => $_[0] })->get_column('session_expiry')
      ->first)
}

1;
__END__