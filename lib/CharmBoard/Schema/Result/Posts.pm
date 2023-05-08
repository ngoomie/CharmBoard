package CharmBoard::Schema::Result::Posts;
use base qw(DBIx::Class::Core);

__PACKAGE__->table('posts');
__PACKAGE__->add_columns(
  post_id   => {
    data_type         => 'integer',
    is_auto_increment => 1,
    is_nullable       => 0, },
  user_id   => {
    data_type         => 'integer',
    is_auto_increment => 0,
    is_nullable       => 0, },
  thread_id => {
    data_type         => 'integer',
    is_auto_increment => 0,
    is_nullable       => 0, },
  post_date => {
    data_type         => 'integer',
    is_auto_increment => 0,
    is_nullable       => 0, });

__PACKAGE__->set_primary_key('post_id');

__PACKAGE__->belongs_to(
  user_id =>
    'CharmBoard::Schema::Result::Users',
    'user_id' );
__PACKAGE__->belongs_to(
  thread_id =>
    'CharmBoard::Schema::Result::Threads',
    'thread_id' );

1