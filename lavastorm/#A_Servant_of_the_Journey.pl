# This script should be copy-pasted and reconfigured for each instance master

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
# Opportunity costs some quantity of plat and potentially a token amount of reward currency from challenge to open

my $flavor_text = "Within the caverns ahead is the lair of the legendary Red Dragon of Antonica - Lord Nagafen."; #TODO

my $zone_name       = 'soldungb';
my $prog_stage      = 'RoK';
my $prog_substage   = 'Lord Nagafen';
my $reward          = 5;
my @task_id         = (3,4);

sub EVENT_SAY {
    plugin::HandleSay($client, $npc, $zone_name, $reward, $prog_stage, $prog_substage, $flavor_text, @task_id);
}