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

            # No need to check for all_zero as we are not using @keys fields for modification

            # Iterating twice for Latent and Awakened versions
            for my $multiplier (1, 2) {
                # Adjust ID for each tier
                $row->{id} = $row->{id} + (1000000 * $multiplier);

                # Modify the name based on multiplier
                $row->{name} = $row->{name} . ($multiplier == 1 ? " (Latent)" : " (Awakened)");

                # Other modifications remain the same...
                $row->{bagwr} = max($row->{bagwr}, $multiplier == 1 ? 80 : 100);
                $row->{bagslots} = $row->{bagslots} + 5 * $multiplier;

                # Create an INSERT statement dynamically
                my $columns = join(",", map { $dbh->quote_identifier($_) } keys %$row);
                my $values  = join(",", map { $dbh->quote($row->{$_}) } keys %$row);
                my $sql = "REPLACE INTO items ($columns) VALUES ($values)";

                print "Creating: $row->{id} ($row->{name})\n";
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