package CharmBoard::Schema::Source::Categories;
use base qw(DBIx::Class::Core);

=pod
=encoding utf8
=head1 NAME
CharmBoard::Schema::Source::Categories - DBIx::Class
ResultSource module for the database's C<categories> table
=head1 DESCRIPTION
This table contains info about categories, which are used
solely to organize subforums on places like the index page.
=head2 Columns
=over
=item cat_id
Contains unique IDs for individual categories.

Data type is SQLite C<INTEGER>; MariaDB C<INT>.
Cannot be C<NULL>.

=item cat_rank
The order in which categories should be displayed.

Data type is SQLite C<INTEGER>; MariaDB C<SMALLINT>.
Cannot be C<NULL>.

=item cat_name
The name of the category to be displayed in the forum list.

Data type is SQLite C<TEXT>; MariaDB C<TINYTEXT>.
Cannot be C<NULL>.
=back
=cut

__PACKAGE__->table('categories');
__PACKAGE__->add_columns(

  cat_id   => {
    data_type         => 'integer',
    is_numeric        => 1,
    is_auto_increment => 1,
    is_nullable       => 0, },
  cat_rank => {
    data_type         => 'integer',
    is_auto_increment => 0,
    is_nullable       => 0, },
  cat_name => {
    data_type         => 'text',
    is_auto_increment => 0,
    is_nullable       => 0, });
    
__PACKAGE__->set_primary_key('cat_id');

1