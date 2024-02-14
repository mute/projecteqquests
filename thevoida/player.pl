sub EVENT_CLICKDOOR {
    quest::debug("doorid " . $doorid);
    quest::debug("version " . $version);
    quest::debug("door " . $door);
    my %portal_destinations = %{ plugin::get_portal_destinations() };
    my $destination         = quest::get_data("magic_map_target");
    if ($doorid == 146) {
        if ($destination && exists $portal_destinations{$destination}) {
            my ($destination_name, $popup_id) = @{ $portal_destinations{$destination} };
            quest::popup('Teleport', "Teleport to $destination_name?", $popup_id, 1, 0);
        }
    }
}

sub EVENT_POPUPRESPONSE {
    my %portal_destinations = %{ plugin::get_portal_destinations() };
    
    foreach my $info (values %portal_destinations) {
        my ($destination_name, $popup_id, $zone_id, $x, $y, $z, $heading) = @$info;
        if ($popupid == $popup_id) {
            quest::movepc($zone_id, $x, $y, $z, $heading);
            return;
        }
    }
}

sub EVENT_CLICK_OBJECT {
    quest::debug("objectid " . $objectid);
    quest::debug("clicker_id " . $clicker_id);
    quest::debug("object " . $object);
}