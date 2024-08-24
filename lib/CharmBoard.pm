package CharmBoard;

use utf8;
use strict;
use warnings;
use experimental qw(try);
use feature ':5.20';

use Mojo::Base 'Mojolicious', -signatures;
use CharmBoard::Model::Schema;
use CharmBoard::Util::Crypt::Seasoning;

# this method will run once at server start
sub startup {
  my $app = shift;

  # load plugins that require no additional conf
  $app->plugin('TagHelpers');
  $app->plugin('Model', {namespaces => ['CharmBoard::Model']});

  # load configuration from config file
  my $config =
      $app->plugin('Config' => { file => 'charmboard.conf' });

  # set this specific forum's name
  $app->helper(board_name => sub { $config->{board_name} });

  # load dev env only stuff, if applicable
  if (lc($config->{environment}) eq 'dev') {
    $app->renderer->cache->max_keys(0)
  }

  # import Mojolicious secrets
  $app->secrets($config->{secrets});

  # import password pepper value
  $app->helper(pepper => sub { $config->{pass_crypt}->{pepper} });

  ## database setup
  # ? this could maybe be a given/when
  {
    my ($_dsn, $_unicode);
    if (lc($app->config->{database}->{type}) eq 'sqlite') {
      $_dsn     = "dbi:SQLite:" . $config->{database}->{name};
      $_unicode = "sqlite_unicode"

    } elsif (lc($app->config->{database}->{type}) eq 'mariadb') {
      $_dsn     = "dbi:mysql:" . $config->{database}->{name};
      $_unicode = "mysql_enable_utf"

    } else {
      die "\nUnknown, unsupported, or empty database type
      in charmboard.conf. If you're sure you've set it to
      something supported, maybe double check your spelling?
      \n\n\t
      Valid options: 'sqlite', 'mariadb'"
    }

    our $schema = CharmBoard::Model::Schema->connect(
      $_dsn,
      $config->{database}->{user},
      $config->{database}->{pass},
      { $_unicode => 1 }
    );

    $app->helper(schema => sub { $schema })
  }

  # session helpers
  ## create session
  $app->helper(session_create => sub {
    my $app = shift;

    my $_session_key = seasoning(16);

    # create session entry in db
    $app->schema->resultset('Session')->create({
      session_key    => $_session_key,
      user_id        => $_[0],
      session_expiry => time + 604800,
      is_ip_bound    => 0,
      bound_ip       => undef
    });

    # now create session cookie
    $app->session(is_auth     => 1            );
    $app->session(user_id     => $_[0]        );
    $app->session(session_key => $_session_key);
    $app->session(expiration  => 604800       );
  });
  ## destroy session
  $app->helper(session_destroy => sub {
    my $app = shift;

    my $_session_key = $app->session('session_key');

    # destroy entry for this session in the database
    $app->schema->resultset('Session')
        ->search({ session_key => $_session_key })
        ->delete;

    # now nuke the actual session cookie
    $app->session(expires => 1);
  });
  ## verify session
  $app->helper(session_verify => sub {
    my $app = shift;

    my $_validity = 1;
    my $_catch_error;

    # get info from user's session cookie and store it in vars
    my $_user_id = $app->session('user_id');
    my $_session_key = $app->session('session_key');
    my $_is_auth = $app->session('is_auth');

    if ($_is_auth) {
      try {
        # check to see if session with this id is present in db
        ($app->schema->resultset('Session')->search
          ({ 'session_key' => $_session_key })
          ->get_column('session_key')->first)
              or die;

        # check to see if the current session key's user id matches
        # that of the user id in the database
        $_user_id == ($app->schema->resultset('Session')->
          session_uid($_session_key))
            or die;
        
        # check if session is still within valid time as recorded in
        # the db
        time < ($app->schema->resultset('Session')->
          session_expiry($_session_key))
              or die;
      } catch ($_catch_error) {
        $_validity = undef;
        $app->session_destroy;
      }
    } else {
      $_validity = 0;
    }

    return $_validity;
  });

  # router
  my $r = $app->routes;

  # controller routes
  ## index page
  $r->get('/')->to(
    controller => 'Controller::Index',
    action     => 'index'
  );

  ## registration page
  $r->get('/register')->to(
    controller => 'Controller::Register',
    action     => 'register'
  );
  $r->post('/register')->to(
    controller => 'Controller::Register',
    action     => 'register_do'
  );

  ## login page
  $r->get('/login')->to(
    controller => 'Controller::Login',
    action     => 'login'
  );
  $r->post('/login')->to(
    controller => 'Controller::Login',
    action     => 'login_do'
  );

  ## logout
  $r->get('/logout')->to(
    controller => 'Controller::Logout',
    action     => 'logout_do'
  );

  # view subforum
  $r->get('/board/:id')->to(
    controller => 'Controller::ViewSubf',
    action     => 'subf_view'
  );

  # create thread
  $r->get('/board/:id/new')->to(
    controller => 'Controller::NewThread',
    action     => 'thread_compose'
  );
  $r->post('/board/:id/new')->to(
    controller => 'Controller::NewThread',
    action     => 'thread_submit'
  );
}

1;
__END__

=pod
=head1 NAME
CharmBoard - revive the fun posting experience!

=head1 NOTES
This documentation is intended for prospective code contributors. If
you're looking to set CharmBoard up, look for the Markdown format
(.md) documentation instead.

CharmBoard uses a max line length of 70 chars and a tab size of two
spaces.

=head1 DESCRIPTION
CharmBoard is forum software written in Perl with Mojolicious,
intended to be a more fun alternative to the bigger forum suites
available today, inspired by older forum software like AcmlmBoard.
=cut
