package CharmBoard::Model::Forums;

use utf8;
use strict;
use warnings;
use experimental qw(try);
use feature ':5.20';

use Mojo::Base 'MojoX::Model';
use Tree::Simple;

sub list_full {
  my $c = shift;
  # fetch a list of all categories
  my @_all_cat = $c->{app}->schema->resultset('Categories')->fetch_all;

  # create a Tree::Simple object that will contain the list
  # of categories and the subforums that belong to them
  my $_tree = Tree::Simple->new("subf_list", Tree::Simple->ROOT);

  my (@_fetch_subf, $_cat_branch);
  foreach my $_iter_cat (@_all_cat) {

    # create branch of subf_list for the current category
    $_cat_branch = Tree::Simple->new($_iter_cat, $_tree);

    # fetch all subforums that belong to this category
    @_fetch_subf =
        $c->{app}->schema->resultset('Subforums')
        ->fetch_by_cat($_iter_cat);

    # add each fetched subforum as children of the branch
    # for the current category
    foreach my $_iter_subf (@_fetch_subf) {
      Tree::Simple->new($_iter_subf, $_cat_branch)
    }
  }

  return $_tree;
}

1;
__END__