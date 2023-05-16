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
  my @allCat =
    $self->schema->resultset('Categories')->fetch_all;

  # create a Tree::Simple object that will contain the list
  # of categories and the subforums that belong to them
  my $tree =
    Tree::Simple->new("ROOT", Tree::Simple->ROOT);

  my (@fetchSubf, $catBranch);
  foreach my $iterCat (@allCat) {
    # create branch of ROOT for the current category

    $catBranch =
      Tree::Simple->new($iterCat, $tree);

    # fetch all subforums that belong to this category
    @fetchSubf =
      $self->schema->resultset('Subforums')
        ->fetch_by_cat($iterCat);

    # add each fetched subforum as children of the branch
    # for the current category
    foreach my $iterSubf (@fetchSubf) {
      Tree::Simple->new($iterSubf, $catBranch)}}

  $self->render(
    template => 'index',
    categoryTree => $tree)}

1;
__END__