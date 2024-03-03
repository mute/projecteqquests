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

sub duplicate_and_modify_items {
    my $dbh = LoadMysql();
    die "Failed to connect to database." unless $dbh;

    my $sth = $dbh->prepare("SELECT * FROM items WHERE bagslots >= 8 AND bagwr >= 50");
    $sth->execute() or die $DBI::errstr;

    while (my $row = $sth->fetchrow_hashref()) {
        if ($row->{slots} > 0 and $row->{classes} > 0) {

            # Preserve the original name before modification
            my $original_name = $row->{name};

            # Iterating twice for Latent and Awakened versions
            for my $multiplier (1, 2) {
                # Adjust ID for each tier
                my $new_id = $row->{id} + (1000000 * $multiplier);  # Create a new variable for modified id

                # Modify the name based on multiplier, using the original name
                my $new_name = $original_name . ($multiplier == 1 ? " (Latent)" : " (Awakened)");

                # Other modifications
                my $new_bagwr = max($row->{bagwr}, $multiplier == 1 ? 80 : 100);
                my $new_bagslots = $row->{bagslots} + 5 * $multiplier;

                # Create an INSERT statement dynamically
                my $columns = join(",", map { $dbh->quote_identifier($_) } keys %$row);
                # Ensure to use new variables for ID and Name while keeping others from $row
                my $values = join(",", map { $_ eq 'id' ? $dbh->quote($new_id) : ($_ eq 'name' ? $dbh->quote($new_name) : $dbh->quote($row->{$_})) } keys %$row);
                my $sql = "REPLACE INTO items ($columns) VALUES ($values)";

                print "Creating: $new_id ($new_name)\n";
                # Insert the new row into the table
                my $isth = $dbh->prepare($sql) or die "Failed to prepare insert: " . $dbh->errstr;
                $isth->execute() or die "Failed to execute insert: " . $DBI::errstr;
            }
        }
    }

    $sth->finish();
    $dbh->disconnect();
}


# Call the function to start the process
duplicate_and_modify_items();