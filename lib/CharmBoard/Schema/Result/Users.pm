package CharmBoard::Schema::Result::Users;
use base qw(DBIx::Class::Core);

__PACKAGE__->table('users');
__PACKAGE__->add_columns(
  user_id     => {
    data_type         => 'integer',
    is_numeric        => 1,
    is_nullable       => 0,
    is_auto_increment => 1, },
  username    => {
    data_type         => 'text',
    is_numeric        => 0,
    is_nullable       => 0, },
  email       => {
    data_type         => 'text',
    is_numeric        => 0,
    is_nullable       => 0, },
  password    => {
    data_type         => 'text',
    is_numeric        => 0,
    is_nullable       => 0, },
  salt        => {
    data_type         => 'text',
    is_numeric        => 0,
    is_nullable       => 0, },
  signup_date => {
    data_type         => 'integer',
    is_numeric        => 1,
    is_nullable       => 0, });

__PACKAGE__->set_primary_key('user_id');

1