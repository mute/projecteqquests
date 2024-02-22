# set_discord_account
# Updates or inserts a discord user's account with their subscription level.
# Usage: set_discord_account($client, $discord_id, $subs_level)
# Parameters:
#    $client: Client object containing account-related methods.
#    $discord_id: Discord user's ID.
#    $subs_level: Subscription level to be set for the user.
# Returns: 1 on success, 0 on failure.
sub set_discord_account {
    my ($client, $discord_id, $subs_level) = @_;
    my $account_id = $client->AccountID();

    # Set default subscription level if not provided
    $subs_level //= 0;

    # Load the MySQL database handle
    my $dbh = plugin::LoadMysql();

    # Check and create the discord_users table if it doesn't exist
    unless ($dbh->selectrow_array("SHOW TABLES LIKE 'discord_users'")) {
        my $sql = qq{
            CREATE TABLE discord_users (
                account_id INT NOT NULL,
                discord_id INT NOT NULL,
                subs_level INT,
                PRIMARY KEY (account_id),
                UNIQUE (discord_id)
            )
        };
        $dbh->do($sql);
    }

    # Insert or update the user record
    my $sql = "REPLACE INTO discord_users (account_id, discord_id, subs_level) VALUES (?, ?, ?)";
    
    eval {
        $dbh->do($sql, undef, $account_id, $discord_id, $subs_level);
    };

    # Disconnect from the database
    $dbh->disconnect();

    # Return the status
    return !$@;
}

# set_subscriber_level
# Updates the subscription level of a user's account.
# Usage: set_subscriber_level($client, $sub_level)
# Parameters:
#    $client: Client object containing account-related methods.
#    $sub_level: New subscription level to be set for the user.
# Returns: 1 on success, 0 on failure.
sub set_subscriber_level {
    my ($client, $sub_level) = @_;
    my $account_id = $client->AccountID();

    # Set default subscription level if not provided
    $sub_level //= 0;

    # Load the MySQL database handle
    my $dbh = plugin::LoadMysql();

    # Update the subscription level in the database
    my $sql = "UPDATE discord_users SET subs_level = ? WHERE account_id = ?";
    
    eval {
        $dbh->do($sql, undef, $sub_level, $account_id);
    };

    # Disconnect from the database
    $dbh->disconnect();

    # Return the status
    return !$@;
}

# get_subscriber_level
# Retrieves the subscription level of a user's account.
# Usage: get_subscriber_level($client)
# Parameters:
#    $client: Client object containing account-related methods.
# Returns: Subscription level of the user on success, 0 on failure.
sub get_subscriber_level {
    my ($client) = @_;
    my $account_id = $client->AccountID();

    # Load the MySQL database handle
    my $dbh = plugin::LoadMysql();

    # Retrieve the subscription level from the database
    my $sql = "SELECT subs_level FROM discord_users WHERE account_id = ?";
    my $subs_level;

    eval {
        ($subs_level) = $dbh->selectrow_array($sql, undef, $account_id);
    };

    # Disconnect from the database
    $dbh->disconnect();

    # Check for errors and return the result
    if ($@) {
        return 0;
    } else {
        return $subs_level;
    }
}

# get_subscriber_accounts
# Retrieves a list of subscriber accounts with a subscription level greater than 0.
# Optionally filters by account ID if provided.
# Usage: get_subscriber_accounts([$filter])
# Parameters:
#    $filter: Optional subscription level to filter the results.
# Returns: Hash reference with account_id as keys and subs_level as values.
sub get_subscriber_accounts {
    my ($filter) = @_;

    # Load the MySQL database handle
    my $dbh = plugin::LoadMysql();

    # Prepare the SQL query to select subscriber accounts
    my $sql = "SELECT account_id, subs_level FROM discord_users WHERE subs_level > ?";

    # Prepare and execute the SQL query
    my $sth = $dbh->prepare($sql);
    $sth->execute($filter ? $filter : 0);

    # Fetch the results into a hash
    my %accounts;
    while (my $row = $sth->fetchrow_hashref) {
        $accounts{$row->{account_id}} = $row->{subs_level};
    }

    # Disconnect from the database
    $dbh->disconnect();

    # Return the accounts hash
    return \%accounts;
}