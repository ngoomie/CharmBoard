package CharmBoard::Model::Schema::Source::Threads;

use utf8;
use strict;
use warnings;
use experimental qw(try);
no warnings 'experimental::try';
use feature ':5.34';

use base qw(DBIx::Class::Core);

__PACKAGE__->table('threads');
__PACKAGE__->add_columns(
  thread_id    =>
  {     data_type         => 'integer',
        is_auto_increment => 1,
        is_nullable       => 0,
  },
  thread_title =>
  {     data_type         => 'text',
        is_nullable       => 0,
  },
  thread_op    =>
  {     data_type         => 'integer',
        is_foreign_key    => 1,
        is_nullable       => 0,
  },
  thread_subf  =>
  {     data_type         => 'integer',
        is_foreign_key    => 1,
        is_nullable       => 0,
  }
);

__PACKAGE__->set_primary_key('thread_id');

__PACKAGE__->belongs_to(
  thread_subf => 'CharmBoard::Model::Schema::Source::Subforums',
  { 'foreign.subf_id' => 'self.thread_subf' }
);
__PACKAGE__->belongs_to(
  thread_op   => 'CharmBoard::Model::Schema::Source::Posts',
  { 'foreign.post_id' => 'self.thread_op' }
);

1;
__END__
