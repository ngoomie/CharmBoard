package CharmBoard::Schema::Result::Session;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('session');
__PACKAGE__->add_columns(
  user_id        => {
    data_type   => 'integer',
    is_nullable => 0,
  },
  session_id     => {
    data_type   => 'text',
    is_nullable => 0
  },
  session_expiry => {
    data_type   => 'integer',
    is_nullable => 0
  });
__PACKAGE__->set_primary_key('user_id');

1