my $zone_duration   = 604800;

# Design:
# This NPC will offer two instances for this zone; <Zone>: Challenge and <Zone>: Opportunity (names tbd)
# Challenge is limited to those who have either A) Not yet completed the specified progression stage or B) Have not exceeeded
# that stage by a full degree (ie, SoV-complete cannot participate in RoK instance)
# Both instances are limited to 6 characters. Both instance last 7 days, but can be left early.
# Challenge is an objective-based, non-respawning instance that allows for completing unlock tasks.
# Challenge rewards a TBD alt-currency which can be used to purchase items from LDON vendor pool
# Challenge $reward pool is evenly (rounded up) distributed among all participants
# Challenge locks tasks so players cannot be added after the first person zones in
# Opportunity is an open zone with respawns, etc, that can be requested by anyone who *has* cleared Challenge at least once
# Opportunity costs some quantity of plat to open

#plugin::HandleSay($client, $npc, $zone_name, $reward, @task_id, $prog_stage, $prog_substage, $flavor_text);
sub HandleSay
{
    my ($client, $npc, $zone_name, $reward, $prog_stage, $prog_substage, $flavor_text, @task_id) = @_;
    my $text   = plugin::val('text');

    my $challenges                  = quest::saylink("challenges", 1);
    my $opportunities               = quest::saylink("opportunities", 1);
    my $wish_to_proceed_challenge   = quest::saylink("wish to proceed_challenge", 1, "wish to proceed");
    my $wish_to_proceed_opportunity = quest::saylink("wish to proceed_opportunity", 1, "wish to proceed");
    my $proceed                     = quest::saylink("proceed", 1);

    if ($text =~ /hail/i) {
        if (plugin::HasDynamicZoneAssigned($client)) {
            my %instance_data       = plugin::DeserializeHash($client->GetBucket("instance-data"));
            my $stored_zone_name    = $instance_data{'zone_name'};

            if ($zone_name eq $stored_zone_name) {
                plugin::NPCTell("The way before you is clear. [$proceed] when you are ready.");                
            } else {
                plugin::NPCTell("You have already embarked upon another dangerous quest. Complete it or abandon it, I care not.");
            }            

            return;
        } else {
            plugin::NPCTell("Hail, Hero. I offer [$challenges] and [$opportunities] alike.");
        }
    }

    if ($text =~ /challenges/i) {
        quest::debug($prog_stage);
        my $next_stage = plugin::get_next_stage($prog_stage);
        if (plugin::is_stage_complete($client, $next_stage)) {
            plugin::NPCTell("Your power has grown too great for the challenges here to offer any achievement for you. Consider the [$opportunities] here, instead.");
        } else {
            plugin::NPCTell("$flavor_text Seek the challenges before you, and be rewarded. Do you [$wish_to_proceed_challenge]?");
            plugin::YellowText("You must complete all instance objectives in order to recieve a progression flag. You may leave and re-enter the instance. Creatures within
                                will not respawn. Once any member of your party enters, you may not add any additional members. Rewards will be calculated based upon the number 
                                of members in the task when it locks.");
        }
    }

    if ($text =~ /opportunities/i) {
        if (!plugin::get_subflag($client, $prog_stage, $prog_substage)) {
            plugin::NPCTell("You have not yet completed the [$challenges] in this dungeon. Complete them, and then we may speak of opportunities.");
        } else {
            plugin::NPCTell("$flavor_text Seek the opportunities before you, and be rewarded. Do you [$wish_to_proceed_opportunity]?");
            plugin::YellowText("The instance will remain open for seven days. You may leave and re-enter the instance. You may add additional players, up to 6 total at a given time, at any time.");
        } 
    }

    if ($text =~ /wish to proceed_challenge/i) {
        $client->TaskSelector(@task_id);
        return;
    }

    if ($text =~ /wish to proceed_opportunity/i) {
        $client->AssignTask($task_id[1]);
        return;
    }

    if ($text =~ /proceed/i) {
        $client->MovePCDynamicZone($zone_name); 
    }
}

sub HandleTaskAccept
{
    my %dz = (
                "instance"      => { "zone" => 'soldungb', "version" => 0 }
    );
    
    $client->CreateTaskDynamicZone(3, \%dz); 
}

sub HasDynamicZoneAssigned {
    my $client  = shift || plugin::val('client');
    my $dbh     = plugin::LoadMysql();

    my $character_id = $client->CharacterID();

    my $query = "SELECT COUNT(*) FROM dynamic_zone_members WHERE character_id = ?";
    my $sth = $dbh->prepare($query);
    $sth->execute($character_id);

    my $count = $sth->fetchrow();
    $sth->finish();
    $dbh->disconnect();

    return $count > 0 ? 1 : 0;
}