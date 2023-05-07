# CharmBoard installation instructions

Please keep in mind that CharmBoard is alpha software, and as such should not be used in a production environment and will likely be unstable or insecure.

## Preparation

### Selecting a database type

CharmBoard supports two different types of databases. Below is a table listing off each type, as well as an explanation of the differences for people who are unsure which to pick.

| Name | config value | DBD package | Information |
|-|-|-|-|
| SQLite | `sqlite` | `DBD:SQLite` | Good for small installs (i.e. a private forum with one friend group, etc.)<br />Easy to set up as the database is contained in a standalone file. |
| MySQL | `mysql` | `DBD:mysql` | Has better performance on larger databases than SQLite does.<br />Harder to set up than SQLite as it requires the separate database server software to be set up alongside CharmBoard. |

### Installing dependencies

(filler filler filler)

**NOTE:** If you use a RHEL-related Linux distro (RHEL, Rocky Linux, Fedora, et al) you might need to install `DBIx::Class` using either `yum` or `dnf` instead of with `cpan`, or it may not be recognized by your Perl install. The package name is `perl-DBIx-Class`.
