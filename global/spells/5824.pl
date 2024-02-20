# Bazaar Portal
sub EVENT_SPELL_EFFECT_CLIENT {
	# Spell-EVENT_SPELL_EFFECT_CLIENT
	# Exported event variables
	quest::debug("spell_id " . $spell_id);
	quest::debug("caster_id " . $caster_id);
	quest::debug("tics_remaining " . $tics_remaining);
	quest::debug("caster_level " . $caster_level);
	quest::debug("buff_slot " . $buff_slot);
	quest::debug("spell " . $spell);

    my $client = plugin::val('$client');
    my $x = $client->GetX();
    $client->Message(13,"X: $x");
    quest::debug("X: $x");

}