sub CommonCharacterUpdate
{
    my $client = shift;
    my $levels_gained = shift;

    CheckSkillAcquisition($client);
}

sub CheckSkillAcquisition
{
    my $client = shift;
    
    my @exclude_skills = (57,58,59,60,61,63,64,65,66,68,69); 
    my $max_skill_id = 77;

    foreach my $skill (1..$max_skill_id) {        
        next if (grep { $_ == $skill } @exclude_skills);

        if ($client->MaxSkill($skill) > 0 && $client->GetRawSkill($skill) < 1 && $client->CanHaveSkill($skill)) {
            $client->SetSkill($skill, 1);
        }
    }
}