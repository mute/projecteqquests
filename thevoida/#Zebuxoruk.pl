sub EVENT_SAY {

    my $zeb_progress = quest::get_data(plugin::GetAccountKey() . "zeb-progress") || 0;

    my $base_class = $client->GetClass();
    my $base_class_name = quest::getclassname($base_class);

    if ($text=~/hail/i && !$zeb_progress) {
        quest::say("Hail, yourself. You find yourself here, again. The cycle continues. You present youself before me as a $base_class_name, in this place beyond the concept of both time and 'place' itself. At the end of all.");
    }
}