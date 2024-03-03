#!/usr/bin/perl
use warnings;
use DBI;
use POSIX;
use List::Util qw(max);

sub LoadMysql {
        use DBI;
        use DBD::mysql;
        use JSON;

        my $json = new JSON();

        #::: Load Config
        my $content;
        open(my $fh, '<', "../eqemu_config.json") or die; {
                local $/;
                $content = <$fh>;
        }
        close($fh);

        #::: Decode
        $config = $json->decode($content);

        #::: Set MySQL Connection vars
        $db   = $config->{"server"}{"database"}{"db"};
        $host = $config->{"server"}{"database"}{"host"};
        $user = $config->{"server"}{"database"}{"username"};
        $pass = $config->{"server"}{"database"}{"password"};

        #::: Map DSN
        $dsn = "dbi:mysql:$db:$host:3306";

        #::: Connect and return
        $connect = DBI->connect($dsn, $user, $pass);

        return $connect;
}

sub ceil_to_nearest_5 {
    my ($value) = @_;
    return ceil($value / 5) * 5;
}

# Main subroutine to duplicate and modify items
sub duplicate_and_modify_items {
    my $dbh = LoadMysql();
    die "Failed to connect to database." unless $dbh;

   # Get all column names except 'id'
    my $sth = $dbh->prepare("SHOW COLUMNS FROM items");
    $sth->execute();
    my @columns;
    while (my $ref = $sth->fetchrow_hashref()) {
        # Encapsulate column names in backticks to handle reserved words
        push @columns, "`" . $ref->{'Field'} . "`" unless $ref->{'Field'} eq 'id';
    }
    my $columns_list = join ", ", @columns;  # Create a string of column names

    # Modify the query and insertion process accordingly
    $sth = $dbh->prepare("SELECT id, $columns_list FROM items WHERE bagslots >= 8 AND bagwr >= 50");
    $sth->execute();

# Prepare the insert statement
my $placeholders = join ", ", ("?") x (scalar @columns + 1);  # +1 for 'id'
my $insert_sql = "REPLACE INTO items ($columns_list) VALUES ($placeholders)";
print "SQL Query: $insert_sql\n";  # Debugging: print SQL query
my $insert_sth = $dbh->prepare($insert_sql);

while (my $ref = $sth->fetchrow_hashref()) {
    foreach my $multiplier (1, 2) {  # For 'Latent' and 'Awakened'
        my %new_row = %$ref;
        $new_row{'id'} = $ref->{'id'} + 1000000 * $multiplier;
        $new_row{'name'} = $ref->{'name'} . ($multiplier == 1 ? " (Latent)" : " (Awakened)");
        $new_row{'bagwr'} = max($ref->{'bagwr'}, $multiplier == 1 ? 80 : 100);
        $new_row{'bagslots'} = $ref->{'bagslots'} + 5 * $multiplier;

        # Debugging: Print the values being inserted
        print "Inserting values for multiplier $multiplier: ", join(", ", $new_row{'id'}, map { $new_row{$_} // 'undef' } @columns), "\n";

        # Execute with new values
        $insert_sth->execute($new_row{'id'}, map { $new_row{$_} // 'undef' } @columns) or print "Failed to execute: " . $DBI::errstr . "\n";
    }
}


    $sth->finish();
    $insert_sth->finish();
    $dbh->disconnect();
}

# Call the function to start the process
duplicate_and_modify_items();
