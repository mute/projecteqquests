sub EVENT_TICK {
    if ($npc->IsPet() && $npc->GetOwner()->IsClient()) { 
        UPDATE_PET_BAG($npc);
        CHECK_CHARM_STATUS();   
    }
}

sub EVENT_SPAWN {
    if ($npc->IsPet() && $npc->GetOwner()->IsClient()) { 
        UPDATE_PET_BAG($npc);
        CHECK_CHARM_STATUS(); 
        plugin::CheckWorldWideBuffs($npc);       
    }
}

sub EVENT_ITEM
{
    if ($npc->IsPet() and $npc->GetOwner()->IsClient() and not $npc->Charmed()) {
        plugin::YellowText("You must use a Summoner's Syncrosatchel to equip your pet.");
        plugin::return_items_silent(\%itemcount);
    }
}

sub EVENT_DEATH {
    CHECK_CHARM_STATUS(); 
}

sub UPDATE_PET_BAG {    
    #quest::debug("--Syncronizing Pet Inventory--");
    my $owner = $npc->GetOwner()->CastToClient();
    my $bag_size = 200; # actual bag size limit in source
    my $bag_id = 199999; # Custom Item
    my $bag_slot = 0;

    if ($owner) {       
        my %new_pet_inventory;
        my %new_bag_inventory;
        my $updated = 0;

        my $inventory = $owner->GetInventory();
        #Determine if first instance of pet bag is in inventory or bank
        for (my $iter = quest::getinventoryslotid("general.begin"); $iter <= quest::getinventoryslotid("bank.end"); $iter++) {
            if ((($iter >= quest::getinventoryslotid("general.begin") && $iter <= quest::getinventoryslotid("general.end")) ||
                ($iter >= quest::getinventoryslotid("bank.begin") && $iter <= quest::getinventoryslotid("bank.end")))) {
                
                if ($owner->GetItemIDAt($iter) == $bag_id) {
                        $bag_slot = $iter;
                }
            }
        }
        if ($bag_slot) {
            # Determine contents
            if ($bag_slot >= quest::getinventoryslotid("general.begin") && $bag_slot <= quest::getinventoryslotid("general.end")) {
                %new_bag_inventory = GET_BAG_CONTENTS(\%new_bag_inventory, $owner, $bag_slot, quest::getinventoryslotid("general.begin"), quest::getinventoryslotid("generalbags.begin"), $bag_size);
            } elsif ($bag_slot >= quest::getinventoryslotid("bank.begin") && $bag_slot <= quest::getinventoryslotid("bank.end")) {
                %new_bag_inventory = GET_BAG_CONTENTS(\%new_bag_inventory, $owner, $bag_slot, quest::getinventoryslotid("bank.begin"), quest::getinventoryslotid("bankbags.begin"), $bag_size);
            } else {
                return;
            }

            # Fetching pet's inventory
            my @lootlist = $npc->GetLootList();

            # Sort the lootlist based on criteria
            @lootlist = sort {
                my $a_proceffect = $npc->GetItemStat($a, "proceffect") || 0;
                my $a_damage = $npc->GetItemStat($a, "damage") || 0;
                my $a_delay = $npc->GetItemStat($a, "delay") || 0;
                my $a_ratio = ($a_delay > 0 ? $a_damage / $a_delay : 0);
                my $a_ac = $npc->GetItemStat($a, "ac") || 0;
                my $a_hp = $npc->GetItemStat($a, "hp") || 0;

                my $b_proceffect = $npc->GetItemStat($b, "proceffect") || 0;
                my $b_damage = $npc->GetItemStat($b, "damage") || 0;
                my $b_delay = $npc->GetItemStat($b, "delay") || 0;
                my $b_ratio = ($b_delay > 0 ? $b_damage / $b_delay : 0);
                my $b_ac = $npc->GetItemStat($b, "ac") || 0;
                my $b_hp = $npc->GetItemStat($b, "hp") || 0;

                ($b_proceffect > 0 ? 1 : 0) <=> ($a_proceffect > 0 ? 1 : 0)
                || $b_ratio <=> $a_ratio
                || $b_ac <=> $a_ac
                || $b_hp <=> $a_hp
                || $b <=> $a  # using item IDs for final tiebreaker
            } @lootlist;

            foreach my $item_id (@lootlist) {
                my $quantity = $npc->CountItem($item_id);
                if ($quantity > 1) {
                    $updated = 1;
                    last;
                }
                $new_pet_inventory{$item_id} += $quantity;
            }
            
            foreach my $item_id (keys %new_pet_inventory) {
                # if the key doesn't exist in new_bag_inventory or the values don't match
                if (!exists $new_bag_inventory{$item_id}) {
                    $updated = 1; # set updated to true
                    #quest::debug("Inconsistency detected: $item_id not in bag or quantities differ.");
                    last; # exit the loop as we have found a difference
                }
            }

            # if $updated is still false, it could be because new_bag_inventory has more items, check for that
            if (!$updated) {
                foreach my $item_id (keys %new_bag_inventory) {
                    # if the key doesn't exist in new_pet_inventory
                    if (!exists $new_pet_inventory{$item_id}) {                    
                        $updated = 1; # set updated to true
                        last; # exit the loop as we have found a difference
                    }
                }
            }

            if ($updated) {
                #quest::debug("--Pet Inventory Reset Triggered--");
                my @lootlist = $npc->GetLootList();
                while (@lootlist) { # While lootlist has elements
                    foreach my $item_id (@lootlist) {
                        $npc->RemoveItem($item_id);
                    }
                    @lootlist = $npc->GetLootList(); # Update the lootlist after removing items
                }            

                while (grep { $_->{quantity} > 0 } values %new_bag_inventory) {
                    # Preprocess and sort item_ids by GetItemStat in ascending order
                    my @sorted_item_ids = sort {
                        my $count_a = () = unpack('B*', $owner->GetItemStat($a, "slots")) =~ /1/g;
                        my $count_b = () = unpack('B*', $owner->GetItemStat($b, "slots")) =~ /1/g;
                        $count_a <=> $count_b
                    } keys %new_bag_inventory;
                    
                    foreach my $item_id (@sorted_item_ids) {
                        #quest::debug("Processing item to add: $item_id");
                        if ($new_bag_inventory{$item_id}->{quantity} > 0) {
                            $npc->AddItem($item_id, 1, 1, @{$new_bag_inventory{$item_id}->{augments}});
                            $new_bag_inventory{$item_id}->{quantity}--;
                        }
                    }
                }

            }
        }
    } else {
        quest::debug("The owner is not defined");
        return;
    }
}

sub GET_BAG_CONTENTS {
    my %blacklist = map { $_ => 1 } (5532, 10099, 20488, 14383, 20490, 10651, 20544, 28034, 10650, 8495);
    my ($new_bag_inventory_ref, $owner, $bag_slot, $ref_general, $ref_bags, $bag_size) = @_;
    my %new_bag_inventory;

    my %occupied_slots; # To keep track of slots already taken
    my @items;

    my $rel_bag_slot = $bag_slot - $ref_general;
    my $bag_start = $ref_bags + ($rel_bag_slot * $bag_size);
    my $bag_end = $bag_start + $bag_size;

    for (my $iter = $bag_start; $iter < $bag_end; $iter++) {                
        my $item_id = $owner->GetItemIDAt($iter);
        if ($item_id > 0 && !exists($blacklist{$item_id})) {
            my @augments;
            for (my $aug_iter = 0; $aug_iter < 6; $aug_iter++) {
                if ($owner->GetAugmentAt($iter, $aug_iter)) {
                    push @augments, $owner->GetAugmentIDAt($iter, $aug_iter);
                } else {
                    push @augments, 0;
                }
            }
            if ($owner->GetItemStat($item_id, "itemtype") != 54) {
                push @items, {
                    slot => $iter,
                    id => $item_id,
                    proceffect => $owner->GetItemStat($item_id, "proceffect") || 0,
                    ratio => ($owner->GetItemStat($item_id, "delay") > 0 ? ($owner->GetItemStat($item_id, "damage") / $owner->GetItemStat($item_id, "delay")) : 0),
                    ac => $owner->GetItemStat($item_id, "ac") || 0,
                    hp => $owner->GetItemStat($item_id, "hp") || 0,
                    slots => $owner->GetItemStat($item_id, "slots"),
                    augments => \@augments
                };
            }
        }
    }

    # Sort items by proceffect in descending order
    @items = sort { ($b->{proceffect} > 0 ? 1 : 0) <=> ($a->{proceffect} > 0 ? 1 : 0) ||
                     $b->{ratio} <=> $a->{ratio} ||
                     $b->{ac} <=> $a->{ac} || $b->{hp} <=> $a->{hp} || 
                     $b->{id} <=> $a->{id} } @items;

    foreach my $item (@items) {
        for my $slot_bit (reverse 0..20) {
            if ($item->{slots} & (1 << $slot_bit) && !$occupied_slots{$slot_bit}) {
                $occupied_slots{$slot_bit} = 1;
                $new_bag_inventory{$item->{id}} = { quantity => 1, slot => $item->{slot}, augments => $item->{augments} };
                last;
            }
        }
    }

    return %new_bag_inventory;
}

sub CHECK_CHARM_STATUS
{
    if ($npc->Charmed() and not plugin::REV($npc, "is_charmed")) {     
        my @lootlist = $npc->GetLootList();
        my @inventory;
        foreach my $item_id (@lootlist) {
            my $quantity = $npc->CountItem($item_id);
            push @inventory, "$item_id:$quantity";
        }

        my $data = @inventory ? join(",", @inventory) : "EMPTY";
        plugin::SEV($npc, "is_charmed", $data);

    } elsif (not $npc->Charmed() and plugin::REV($npc, "is_charmed")) {
        
        my $data = plugin::REV($npc, "is_charmed");
        my @inventory = split(",", $data);

        my @lootlist = $npc->GetLootList();
        while (@lootlist) { # While lootlist has elements
            foreach my $item_id (@lootlist) {
                $npc->RemoveItem($item_id);
            }
            @lootlist = $npc->GetLootList(); # Update the lootlist after removing items
        }

        foreach my $item (@inventory) {
            my ($item_id, $quantity) = split(":", $item);
            #quest::debug("Adding: $item_id x $quantity");
            $npc->AddItem($item_id, $quantity);
        }

        plugin::SEV($npc, "is_charmed", "");
    }
}