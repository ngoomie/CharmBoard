package CharmBoard::Model::Schema::Source::Posts;

use utf8;
use strict;
use warnings;
use experimental qw(try);
use feature ':5.20';

use base qw(DBIx::Class::Core);

__PACKAGE__->table('posts');
__PACKAGE__->add_columns(
  post_id   =>
  {     data_type         => 'integer',
        is_auto_increment => 1,
        is_nullable       => 0,
  },
  user_id   =>
  {     data_type         => 'integer',
        is_foreign_key    => 1,
        is_nullable       => 0,
  },
  thread_id =>
  {     data_type         => 'integer',
        is_foreign_key    => 1,
        is_nullable       => 0,
  },
  post_date =>
  {     data_type         => 'integer',
        is_nullable       => 0,
  }
);

__PACKAGE__->set_primary_key('post_id');

__PACKAGE__->belongs_to(
  user_id   => 'CharmBoard::Model::Schema::Source::Users',
  'user_id'
);
__PACKAGE__->belongs_to(
  thread_id => 'CharmBoard::Model::Schema::Source::Threads',
  'thread_id'
);

1;
__END__
