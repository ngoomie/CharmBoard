package CharmBoard::Schema::Result::Posts;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('posts');
__PACKAGE__->add_columns(
  post_id   => {
    data_type         => 'integer',
    is_auto_increment => 1,
    is_nullable       => 0
  },
  user_id   => {
    data_type         => 'integer',
    is_auto_increment => 1,
    is_nullable       => 0
  },
  thread_id => {
    data_type         => 'integer',
    is_auto_increment => 1,
    is_nullable       => 0
  },
  post_date => {
    data_type         => 'integer',
    is_auto_increment => 1,
    is_nullable      => 0
  });
__PACKAGE__->set_primary_key('post_id');

1