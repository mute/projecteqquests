function event_slay(e)
	eq.spawn2(179136,0,0,e.self:GetX() - 10,e.self:GetY(),e.self:GetZ(),e.self:GetHeading()); -- NPC: A_mind_worm
	eq.spawn2(179136,0,0,e.self:GetX() + 10,e.self:GetY(),e.self:GetZ(),e.self:GetHeading()); -- NPC: A_mind_worm
	eq.spawn2(179136,0,0,e.self:GetX(),e.self:GetY() - 10,e.self:GetZ(),e.self:GetHeading()); -- NPC: A_mind_worm
	eq.spawn2(179136,0,0,e.self:GetX(),e.self:GetY() + 10,e.self:GetZ(),e.self:GetHeading()); -- NPC: A_mind_worm
	eq.spawn2(179136,0,0,e.self:GetX(),e.self:GetY() + 15,e.self:GetZ(),e.self:GetHeading()); -- NPC: A_mind_worm
end

function event_death_complete(e)
	eq.spawn2(202368,0, 0, e.self:GetX()+3,e.self:GetY()+3,e.self:GetZ(),0); --NPC: A_Planar_Projection
end
-------------------------------------------------------------------------------------------------
-- Converted to .lua using MATLAB converter written by Stryd
-- Find/replace data for .pl --> .lua conversions provided by Speedz, Stryd, Sorvani and Robregen
-------------------------------------------------------------------------------------------------
