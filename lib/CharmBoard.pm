package CharmBoard;
use experimental 'smartmatch';
use Mojo::Base 'Mojolicious', -signatures;
use CharmBoard::Schema;

# This method will run once at server start
sub startup ($app) {

  $app = shift;

  $app->plugin('TagHelpers');
  $app->plugin('Renderer::WithoutCache'); # for dev env only
  
  $app->renderer->cache->max_keys(0); # for dev env only

  $app->defaults(layout => 'default');
  
  # Load configuration from config file
  my $config = $app->plugin('Config' => {
    file => 'charmboard.conf'
  });

  # Configure the application
  ## Import Mojolicious secrets (cookie encryption)
  $app->secrets($config->{secrets});
  ## Import password pepper value
  my $pepper = $config->{passCrypt}->{pepper};
  $app->helper( pepper => sub { $pepper } );
  ## Database setup
  my ($dsn, $dbUnicode);

  if ($app->config->{database}->{type} ~~ 'sqlite') {
    $dsn = "dbi:SQLite:" . $config->{database}->{name};
    $dbUnicode = "sqlite_unicode";
  } elsif ($app->config->{database}->{type} ~~ 'mysql') {
    $dsn = "dbi:mysql:" . $config->{database}->{name};
    $dbUnicode = "mysql_enable_utf";
  } elsif ($app->config->{database}->{type} ~~ 'pgsql') {
    $dsn = "dbi:Pg:" . $config->{database}->{name};
    $dbUnicode = "pg_enable_utf8";
  } else { die "\nUnknown, unsupported, or empty database type in charmboard.conf.
    If you're sure you've set it to something supported, maybe double check your spelling?\n
    Valid options: 'sqlite', 'mysql'"
  };

  my $schema = CharmBoard::Schema->connect(
    $dsn,
    $config->{database}->{user},
    $config->{database}->{pass},
    {
      $dbUnicode => 1
    }
  );

  $app->helper( schema => sub { $schema } );

  # Router
  my $r = $app->routes;

  # Controller routes
  ## Index page
  $r->get('/')->to(
    controller => 'Controller::Main',
    action => 'index'
  );
  ## Registration page
  $r->get('/register')->to(
    controller => 'Controller::Auth',
    action => 'register'
  );
  $r->post('/register')->to(
    controller => 'Controller::Auth',
    action => 'registration_do'
  );
  ## Login page
  $r->get('/login')->to(
    controller => 'Controller::Auth',
    action => 'login'
  );
  $r->post('/login')->to(
    controller => 'Controller::Auth',
    action => 'login_do'
  )
}

1;
