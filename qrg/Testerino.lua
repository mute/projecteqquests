function event_say(e)
    if (e.message:findi("Hail")) then
            eq.whisper("Thanks for helping to test!  Here are some things:")
            eq.whisper(eq.say_link("Refund AA", true))
    elseif(e.message:find("Refund AA")) then
            eq.whisper("Okay, I refunded all of your AA!")
            e.other:ResetAA();
    end
end