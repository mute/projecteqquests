
sub EVENT_ENTERZONE {
$key = $client->AccountID() . "-kunark-flag";
$expansion = quest::get_data($key);

$bind = $client->GetBindZoneID;
$bindh = $client->GetBindHeading;
$bindx = $client->GetBindX;
$bindy = $client->GetBindY;
$bindz = $client->GetBindZ;

if ($status < 80 && $expansion < 19){ #POP - set this to 19 on POP unlock
    $client->Message(7, "You are not ready to relive these memories!");
    $client->MovePC($bind, $bindx, $bindy, $bindz, $bindh);
  }

}