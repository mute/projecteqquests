function event_enter_zone(e)

  	if(level >= 15 and qglobals.Wayfarer == nil and e.self:GetStartZone() == zoneid and eq.is_lost_dungeons_of_norrath_enabled()) then
    		e.self:Message(MT.Yellow, "A mysterious voice whispers to you, 'Narwkend Falgon has just joined the Wayfarers Brotherhood and has some information about them, and how you can start doing odd jobs for them. You looked like the heroic sort, so I wanted to contact you . . . discreetly.'");
  	end
end
