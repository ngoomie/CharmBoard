package CharmBoard::Schema::Result::Threads;
use base qw(DBIx::Class::Core);

__PACKAGE__->table('threads');
__PACKAGE__->add_columns(
  thread_id     => {
    data_type         => 'integer',
    is_auto_increment => 1,
    is_nullable       => 0, },
  thread_title  => {
    data_type         => 'text',
    is_nullable       => 0, },
  thread_subf   => {
    data_type         => 'integer',
    is_nullable       => 1, });
__PACKAGE__->set_primary_key('thread_id');
__PACKAGE__->belongs_to(
  thread_subf =>
    'CharmBoard::Schema::Result::Subforums',
    {'foreign.subf_id' => 'self.thread_subf'});

1