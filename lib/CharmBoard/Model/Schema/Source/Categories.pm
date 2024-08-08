package CharmBoard::Model::Schema::Source::Categories;

use utf8;
use strict;
use warnings;
use experimental qw(try smartmatch);

use base qw(DBIx::Class::Core);

__PACKAGE__->table('categories');
__PACKAGE__->add_columns(
  cat_id   =>
  {     data_type         => 'integer',
        is_auto_increment => 1,
        is_nullable       => 0,
  },
  cat_rank =>
  {     data_type         => 'integer',
        is_nullable       => 0,
  },
  cat_name =>
  {     data_type         => 'text',
        is_nullable       => 0,
  }
);

__PACKAGE__->set_primary_key('cat_id');

1;
__END__
