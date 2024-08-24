package CharmBoard::Controller::NewThread;

use utf8;
use strict;
use warnings;
use experimental qw(try);
no warnings 'experimental::try';
use feature ':5.34';

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub thread_compose {
  my $c = shift;

  my $subf_id  = $c->param('id');
  my $subf_cat =
      $c->schema->resultset('Subforums')->cat_from_id($subf_id);
  my $cat_title =
      $c->schema->resultset('Categories')->title_from_id($subf_cat);

  $c->render(
    template   => 'thread_compose',
    subf_id    => $subf_id,
    cat_title  => $cat_title,
    subf_title =>
        $c->schema->resultset('Subforums')->title_from_id($subf_id),
    error   => $c->flash('error'),
    message => $c->flash('message')
  )
}

sub thread_submit {
  my $c = shift;

  my $thread_title = $c->param('thread-title');
  my $post_content = $c->param('post-content');
  my $subf_id      = $c->param('id');
  my $post_time    = time;

  my $catch_error;
  my $thread_id;

  # make sure post data is valid
  try {
    ($thread_title, $post_content)
        or die "Please fill both the title and post content fields"
  } catch ($catch_error) {
    $c->flash(error => $catch_error);
    $c->redirect_to('/board/:id/new')
  }

  # now send it
  try {
    my $thread = $c->schema->resultset('Threads')->create({
      thread_title => $thread_title,
      thread_subf  => $subf_id
    })
        or die "Server error, thread creation failed";
    $thread->update
        or die "Server error, thread creation failed";
    $thread_id = $thread->id;
    print $thread_id;
    my $post = $c->schema->resultset('Posts')->create({
      user_id   => $c->session('user_id'),
      thread_id => $thread_id,
      post_date => time,
      post_body => $post_content
    })
        or die "Thread was created successfully, but without an OP";
    $post->update
        or die "Thread was created successfully, but without an OP";
  } catch ($catch_error) {
    $c->flash(error => $catch_error);
    $c->redirect_to('/board/:id/new')
  };
  $c->redirect_to('/thread/' . $thread_id)
}

1;
__END__
