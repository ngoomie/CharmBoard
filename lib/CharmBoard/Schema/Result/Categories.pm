package CharmBoard::Schema::Result::Categories;
use base qw(DBIx::Class::Core);

__PACKAGE__->table('categories');
__PACKAGE__->add_columns(
  cat_id   => {
    data_type         => 'integer',
    is_auto_increment => 1,
    is_nullable       => 0, },
  cat_name => {
    data_type         => 'text',
    is_nullable       => 0, });
    
__PACKAGE__->set_primary_key('cat_id');

1