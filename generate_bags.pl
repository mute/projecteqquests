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

    while (my $original_row = $sth->fetchrow_hashref()) {
        # Create two new versions: Latent and Awakened
        foreach my $multiplier (1, 2) {
            # Make a deep copy of the original row
            my %row = %$original_row;  # This ensures original data is not altered

            # Adjust ID and name for each version
            $row{id} += 1000000 * $multiplier;  # Ensure this matches your actual ID column name case
            $row{name} = $original_row->{name} . ($multiplier == 1 ? " (Latent)" : " (Awakened)");  # Ensure this matches your actual name column case

            # Other modifications
            $row{bagwr} = max($row{bagwr}, $multiplier == 1 ? 80 : 100);  # Ensure this matches your actual bagwr column name case
            $row{bagslots} += 5 * $multiplier;  # Ensure this matches your actual bagslots column name case

            # Create an INSERT statement dynamically
            my $columns = join(",", map { $dbh->quote_identifier($_) } keys %row);
            my $values  = join(",", map { $dbh->quote($row{$_}) } keys %row);
            my $sql = "REPLACE INTO items ($columns) VALUES ($values)";

            print "Creating: $row{id} ($row{name})\n";  # Ensure these match your actual column name cases
            # Insert the new row into the table
            my $isth = $dbh->prepare($sql) or die "Failed to prepare insert: " . $DBI::errstr;
            $isth->execute() or die "Failed to execute insert: " . $DBI::errstr;
        }       
    }


    $sth->finish();
    $dbh->disconnect();
}



# Call the function to start the process
duplicate_and_modify_items();