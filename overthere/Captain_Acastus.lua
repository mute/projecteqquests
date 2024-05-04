local colorTalk = 21

function event_say(e)
    local player = e.other -- Get the player object

    if (e.message:findi("Hail")) then
        player:Message(colorTalk, "Welcome to the bustling docks of Port Bloodfire, where the Argonaut rests, ready to tame the wild seas! We're primed and ready to set sail to distant shores. Now, tell me, ye adventurous soul, where does yer heart long to journey? Shall we chart a course for the barren coast of " .. eq.say_link('Dreadshore') .. "? Or shall we chart a course for the bustling ports of " .. eq.say_link('Butcherblock') .. ", where the rum flows as freely as the wind? Speak up, and let the winds carry us to our destiny!");
    elseif (e.message:findi("Butcherblock")) then
        player:MovePC(68, 3212, 1355, 10, 381);
    elseif (e.message:findi("Dreadshore")) then
        player:MovePC(444, -402, 1833, 23, 194);
    end
end