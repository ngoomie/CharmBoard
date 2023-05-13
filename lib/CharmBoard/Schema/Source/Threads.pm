package CharmBoard::Schema::Source::Threads;
use base qw(DBIx::Class::Core);

=pod
=encoding utf8
=head1 NAME 
CharmBoard::Schema::Source::Categories - DBIx::Class
ResultSource module for the database's C<threads> table
=head1 DESCRIPTION
This table contains information about threads.
=head2 COLUMNS
=over
=item thread_id
Contains unique IDs for threads.

Data type is SQLite C<INTEGER>. Cannot be C<NULL>.

=item thread_title
Contains the title for a given thread.

Data type is SQLite C<TEXT>. Cannot be C<NULL>.

=item thread_subf
Contains the ID of the subforum a given thread belongs to.

Is foreign key of C<subforums.subf_id>, and as such, shares
the same datatype (SQLite C<INTEGER>). Cannot be C<NULL>.
=back
=cut

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
    is_foreign_key    => 1,
    is_nullable       => 0, });

__PACKAGE__->set_primary_key('thread_id');
__PACKAGE__->belongs_to(
  thread_subf =>
    'CharmBoard::Schema::Source::Subforums',
    {'foreign.subf_id' => 'self.thread_subf'});

1