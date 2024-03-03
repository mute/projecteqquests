#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use POSIX;
use List::Util qw(max);

# Ensure that 'strict' is used to enforce good programming practices.

sub LoadMysql {
    # Standard use declarations are needed only once at the beginning.
    my $content;
    open(my $fh, '<', "../eqemu_config.json") or die "Unable to open config file: $!";
    {
        local $/;
        $content = <$fh>;
    }
    close($fh);

    my $json = JSON->new();
    my $config = $json->decode($content);

    my $db   = $config->{"server"}{"database"}{"db"};
    my $host = $config->{"server"}{"database"}{"host"};
    my $user = $config->{"server"}{"database"}{"username"};
    my $pass = $config->{"server"}{"database"}{"password"};
    my $dsn = "dbi:mysql:$db:$host:3306";

    my $connect = DBI->connect($dsn, $user, $pass, {RaiseError => 1, AutoCommit => 1}) or die "Could not connect to database: $DBI::errstr";
    return $connect;
}

sub ceil_to_nearest_5 {
    my ($value) = @_;
    return ceil($value / 5) * 5;
}

sub duplicate_and_modify_items {
    my $dbh = LoadMysql();
    die "Failed to connect to database." unless $dbh;

    my $sth = $dbh->prepare("SELECT * FROM items WHERE BagSlots >= 8 AND BagWR >= 50");  # Adjusted for case sensitivity
    $sth->execute() or die $DBI::errstr;

    while (my $original_row = $sth->fetchrow_hashref()) {
        foreach my $multiplier (1, 2) {
            my %row = %$original_row;  # Deep copy to ensure the original data is not altered.

            $row{ID} += 1000000 * $multiplier;  # Assuming 'ID' is the correct case
            $row{Name} = $original_row->{Name} . ($multiplier == 1 ? " (Latent)" : " (Awakened)");  # Adjusted for case sensitivity
            $row{BagWR} = max($row{BagWR}, $multiplier == 1 ? 80 : 100);  # Adjusted for case sensitivity
            $row{BagSlots} += 5 * $multiplier;  # Adjusted for case sensitivity

            my $columns = join(",", map { $dbh->quote_identifier($_) } keys %row);
            my $values  = join(",", map { $dbh->quote($row{$_}) } keys %row);
            my $sql = "REPLACE INTO items ($columns) VALUES ($values)";  # Keeping REPLACE as per your requirement

            print "Creating: $row{ID} ($row{Name})\n";  # Adjusted for case sensitivity
            my $isth = $dbh->prepare($sql) or die "Failed to prepare insert: $DBI::errstr";
            $isth->execute() or die "Failed to execute insert: $DBI::errstr";
        }
    }

    $sth->finish();
    $dbh->disconnect();
}


duplicate_and_modify_items();
