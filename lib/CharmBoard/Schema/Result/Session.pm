package CharmBoard::Schema::Result::Session;
use base qw(DBIx::Class::Core);

__PACKAGE__->table('sessions');
__PACKAGE__->add_columns(
  user_id        => {
    data_type         => 'integer',
    is_auto_increment => 0,
    is_nullable       => 0, },
  session_key    => {
    data_type         => 'text',
    is_auto_increment => 0,
    is_nullable       => 0, },
  session_expiry => {
    data_type         => 'numeric',
    is_auto_increment => 0,
    is_nullable       => 0, },
  is_ip_bound    => {
    data_type         => 'integer',
    is_auto_increment => 0,
    is_nullable       => 0, },
  bound_ip       => {
    data_type         => 'text',
    is_auto_increment => 0,
    is_nullable       => 1, });
__PACKAGE__->set_primary_key('user_id');
__PACKAGE__->belongs_to(
  user_id =>
    'CharmBoard::Schema::Result::Users',
    'user_id');

1