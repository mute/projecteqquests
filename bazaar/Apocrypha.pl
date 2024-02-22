# Basic Design
# EoM (Server-Wide) buffs work by three methods;
# 1) Send a worldwide client signal, global_player catches it and applies the requested buffs
# 2) Set a bucket value with a 4 hour expiration.
# 3) Zone and Login methods in global_player apply the requested buffs with the requested durations

my $duration_override = 1200; #set this value to override 'regular' buffs duration

my $buff_map = {
    1 => [2525, 314, 278, 145, 356, 170], # Free - Harnessing of Spirit, Resolution, Spirit of Wolf, Chloroplast, Shield of Thorns, Alacrity
    20 => [2525, 314, 278, 145, 356, 170], # 10pp - Harnessing of Spirit, Resolution, Spirit of Wolf, Chloroplast, Shield of Thorns, Alacrity
    46 => [2530, 2510, 2524, 2528, 2895, 2570], # 250pp - Khura's Focus, Blessing of Aegolism, Spirit of Bih'li, Regrowth of Dark Khura, Speed of the Brood, Koadics Endless Intellect
    61 => [3397, 3479, 2524, 3441, 3178, 3360], # 500pp - Voice of Quellious, Vallons Quickening, Blessing of Replenishment, Spirit of Bih'li, Hand of Virtue, Focus of the Seventh
    # ... more ...
};

my $price_map = {
    1  => 0,
    20 => 10,
    46 => 250,
    61 => 500,
};

sub get_level_breakpoint {
    my ($client_level) = @_;
    my $closest_level = 0;

    foreach my $level (keys %$buff_map) {
        if ($level <= $client_level && $level > $closest_level) {
            $closest_level = $level;
        }
    }

    return $closest_level;
}

sub apply_buffs {
    my ($client, $closest_level, $duration_override, $duration_scale, $price_scale) = @_;

    $duration_override *= $duration_scale;

    quest::debug("duration_scale: $duration_scale, $price_scale");

    if ($closest_level > 0) {
        if ($client->TakeMoneyFromPP($price_map->{$closest_level} * 1000 * $price_scale, 1)) {
            my $price = $price_map->{$closest_level} * $price_scale;
            $client->Message(15, "You have given $price platinum to Apocrypha.");
            my $buffs = $buff_map->{$closest_level};

            foreach my $buff (@$buffs) {
                my $group = $client->GetGroup();

                if ($group) {
                    for ($count = 0; $count < $group->GroupCount(); $count++) {
                        my $player = $group->GetMember($count);       
                        if ($player) {
                            $player->ApplySpell($buff, $duration_override);
                            if ($player->GetPet()) {
                                $player->GetPet()->ApplySpellBuff($buff, $duration_override);
                            }
                        }
                    }
                } else {
                    $client->ApplySpell($buff, $duration_override);
                    if ($client->GetPet()) {
                        $client->GetPet()->ApplySpellBuff($buff, $duration_override);
                    }
                }
            }

            plugin::Whisper("Enjoy your newfound power.");
        } else {
            plugin::Whisper("You do not have enough coin to afford that.");
        }
    }
}

sub handle_buff_for_level {
    my $client_level = $client->GetLevel();
    my $closest_level = get_level_breakpoint($client_level);
    my ($duration_scale, $price_scale) = @_;
    
    $duration_scale //= 1;  # Set to 1 if not provided
    $price_scale //= 1;     # Set to 1 if not provided
    
    apply_buffs($client, $closest_level, $duration_override, $duration_scale, $price_scale);
}

sub EVENT_SAY {
    my $response = "";
    my $clientName = $client->GetCleanName();

    if ($text=~/hail/i) {   
        $response = "Hail, Adventurer. I seek to empower your ilk for my own profit. For a [modest fee], I will enhance the power of your group for a time. In exchange for more [exotic payment], I will enhance the power of all adventurers in the world.";
    }

    elsif ($text=~/modest fee/i) {
        my $level_break = get_level_breakpoint($client->GetLevel());
        quest::debug("level_break: $level_break");

        my $plat_price = $price_map->{get_level_breakpoint($client->GetLevel())};        
       
        if ($plat_price == 0) {
            $response = "I will enhance you and your party with several [buffs] free of charge.";
        } else {
            $response = "In exchange for a fee of $plat_price platinum, I will enhance you and your party with several [buffs]. I can also apply these buffs for [double] their durations for three times the price.";
        }
    }

    elsif ($text=~/exotic payment/i) {
        $response = "In exchange for five [Echo of Memory], I can enchant the entire world! Each should co-exist with over versions of this type of effect, and will last four hours. If the world is already enchanted in this way, purchasing additional enhancement will extend the duration of the current enchantment. Would you like to enhance the [Experience Gain], [Hit Points and Armor Class], [Combat Statistics], [Movement Speed], [Mana Regeneration], [Attack Speed], or [Health Regeneration]? Alternatively, for twenty-five Echoes, I can cast [all of these enchantments]!";
    }

    elsif ($text=~/experience gain/i) {        
        my $buff_id = 43002;
        if (ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }
    elsif ($text=~/hit points and armor class/i) {
        my $buff_id = 43003;
        if (ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }
    elsif ($text=~/combat statistics/i) {
        my $buff_id = 43004;
        if (ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }
    elsif ($text=~/movement speed/i) {
        my $buff_id = 43005;
        if (ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }
    elsif ($text=~/mana regeneration/i) {
        my $buff_id = 43006;
        if (ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }
    elsif ($text=~/attack speed/i) {
        my $buff_id = 43007;
        if (ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }
    elsif ($text=~/health regeneration/i) {
        my $buff_id = 43008;
        if (ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }
    elsif ($text=~/all of these enchantments/i) {
        my $eom_avail = $client->GetAlternateCurrencyValue(6);
        if ($eom_avail >= 25) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
            $client->SetAlternateCurrencyValue(6, $eom_avail - 25);
            for my $value (43002 .. 43008) {
                ApplyWorldWideBuff($value, 1);                
            }

            quest::worldwidesignalclient(1);
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }

    elsif ($text=~/buffs/i) {        
        handle_buff_for_level();
    }

    elsif ($text=~/double/i) {        
        handle_buff_for_level(2, 3);
    }

    if ($response) {
        plugin::Whisper($response);
    }
}

sub ApplyGroupBuff {
    my $buff_id = shift;

    if ($client->TakeMoneyFromPP($platinum_price * 1000, 1)) {
        $client->ApplySpellGroup($buff_id, 2400);
        return 1;
    } else {
        return 0;
    }    
}

sub ApplyWorldWideBuff {
    my $buff_id = shift;
    my $skip_payment = shift;
    my $eom_avail = $client->GetAlternateCurrencyValue(6);
    my $skip_update = shift || 0;

    if ($eom_avail < 5 && !$skip_payment) {
        return 0;
    } else {
        if (!$skip_payment) { plugin::SpendEOM($client, 5); }

        my %buff_types = (
            43002 => "Experience Gain",
            43003 => "Hit Points and Armor Class",
            43004 => "Basic Statistics",
            43005 => "Movement Speed",
            43006 => "Mana Regeneration",
            43007 => "Attack Speed",
            43008 => "Health Regeneration",
        );
        my $buff_type = $buff_types{$buff_id} // "Unknown Buff";  # Fallback for unknown buff IDs

        if (quest::get_data("eom_$buff_id")) {            
            quest::set_data("eom_$buff_id", 1, quest::get_data_remaining("eom_$buff_id") + (4 * 60 * 60));
            my ($hours, $minutes, $seconds) = convert_seconds(quest::get_data_remaining("eom_$buff_id"));
            quest::worldwidemessage(15, $client->GetCleanName() . " has used their Echo of Memory to extend your enhanced $buff_type. This buff will endure for $hours Hours and $minutes Minutes.");
            quest::discordsend("ooc", $client->GetCleanName() . " has used their Echo of Memory to extend your enhanced $buff_type. This buff will endure for $hours Hours and $minutes Minutes.");
        } else {
            quest::set_data("eom_$buff_id", 1, H4);
            quest::worldwidemessage(15, $client->GetCleanName() . " has used their Echo of Memory to enhance your $buff_type. This buff will endure for 4 Hours.");
            quest::discordsend("ooc", $client->GetCleanName() . " has used their Echo of Memory to enhance your $buff_type. This buff will endure for 4 Hours.");
        }

        
        if (!$skip_payment) { quest::worldwidesignalclient($buff_id); }
        return 1;
    }
}

sub convert_seconds {
    my ($seconds) = @_;

    my $hours = int($seconds / 3600);
    $seconds %= 3600;
    my $minutes = int($seconds / 60);
    $seconds %= 60;

    return ($hours, $minutes, $seconds);
}