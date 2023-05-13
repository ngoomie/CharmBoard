package CharmBoard::Schema::Source::Posts;
use base qw(DBIx::Class::Core);

=pod
=encoding utf8
=head1 NAME
CharmBoard::Schema::Source::Posts - DBIx::Class
ResultSource module for the database's C<posts> table
=head1 DESCRIPTION
This table contains post content and other important post
information (such as post date).
=head2 Columns
=over
=item post_id
Contains unique IDs for posts.

Data type is SQLite C<INTEGER>; MariaDB C<INT>. Cannot
be C<NULL>.

=item user_id
Contains the user ID of the creator of a given post.

Is foreign key of C<users.user_id>, and as such, shares the
same datatype (SQLite C<INTEGER>; MariaDB C<INT>).
Cannot be C<NULL>.

=item thread_id
Contains the ID of the thread this post was posted in.

Is foreign key of C<threads.thread_id>, and as such, shares
the same datatype (C<INTEGER> in SQLite). Cannot be C<NULL>.

=item post_date
Contains the date the post was made, in the format provided
by Perl's C<time> function.

Data type is SQLite C<INTEGER>. Cannot be C<NULL>.

=item post_body
Contains the actual text content of the post.

Data type is SQLite C<TEXT>. Cannot be C<NULL>.
=back
=cut

__PACKAGE__->table('posts');
__PACKAGE__->add_columns(
  post_id   => {
    data_type         => 'integer',
    is_foreign_key    => 0,
    is_auto_increment => 1,
    is_nullable       => 0, },
  user_id   => {
    data_type         => 'integer',
    is_foreign_key    => 1,
    is_auto_increment => 0,
    is_nullable       => 0, },
  thread_id => {
    data_type         => 'integer',
    is_foreign_key    => 1,
    is_auto_increment => 0,
    is_nullable       => 0, },
  post_date => {
    data_type         => 'integer',
    is_foreign_key    => 0,
    is_auto_increment => 0,
    is_nullable       => 0, },
  post_body => {
    data_type         => 'text',
    is_foreign_key    => 0,
    is_auto_increment => 0,
    is_nullable       => 0, });

__PACKAGE__->set_primary_key('post_id');

__PACKAGE__->belongs_to(
  user_id =>
    'CharmBoard::Schema::Source::Users',
    'user_id' );
__PACKAGE__->belongs_to(
  thread_id =>
    'CharmBoard::Schema::Source::Threads',
    'thread_id' );

1