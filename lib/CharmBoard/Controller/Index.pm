package CharmBoard::Controller::Index;

use utf8;
use strict;
use warnings;
use experimental qw(try smartmatch);

use Mojo::Base 'Mojolicious::Controller', -signatures;
use Tree::Simple;

sub index {
  my $self = shift;

  # fetch a list of all categories
  my @all_cat = $self->schema->resultset('Categories')->fetch_all;

  # create a Tree::Simple object that will contain the list
  # of categories and the subforums that belong to them
  my $tree = Tree::Simple->new("subf_list", Tree::Simple->ROOT);

  my (@fetch_subf, $cat_branch);
  foreach my $iter_cat (@all_cat) {

    # create branch of subf_list for the current category
    $cat_branch = Tree::Simple->new($iter_cat, $tree);

    # fetch all subforums that belong to this category
    @fetch_subf =
        $self->schema->resultset('Subforums')
        ->fetch_by_cat($iter_cat);

    # add each fetched subforum as children of the branch
    # for the current category
    foreach my $iter_subf (@fetch_subf) {
      Tree::Simple->new($iter_subf, $cat_branch)
    }
  }

  $self->render(
    template      => 'index',
    category_tree => $tree
  )
}

1;
__END__
