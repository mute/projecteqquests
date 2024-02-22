

sub EVENT_SAY {
my $p1 = $client->GetMoney(3, 0); #plat
my $p2 = $client->GetMoney(3, 1);
my $p3 = $client->GetMoney(3, 2);
my $p4 = $client->GetMoney(3, 3);
my $g1 = $client->GetMoney(2, 0); #gold
my $g2 = $client->GetMoney(2, 1);
my $g3 = $client->GetMoney(2, 2);
my $g4 = $client->GetMoney(2, 3);
my $s1 = $client->GetMoney(1, 0); #silver
my $s2 = $client->GetMoney(1, 1);
my $s3 = $client->GetMoney(1, 2);
my $s4 = $client->GetMoney(1, 3);
my $c1 = $client->GetMoney(0, 0); #copper
my $c2 = $client->GetMoney(0, 1);
my $c3 = $client->GetMoney(0, 2);
my $c4 = $client->GetMoney(0, 3);
my $plattotal = $p1 + $p2 + $p3 + $p4;
my $goldtotal = $g1 + $g2 + $g3 + $g4;
my $silvertotal = $s1 + $s2 + $s3 + $s4;
my $coppertotal = $c1 + $c2 + $c3 + $c4;
my $total = $plattotal + $goldtotal + $silvertotal + $coppertotal;
my $ssfkey = $client->AccountID() . "ssf";
my $key = $client->AccountID() . "-kunark-flag";
my $expansion = quest::get_data($key);



 
  if ($text=~/hail/i) {
    if (quest::get_data($ssfkey) == "") {
    quest::say("Hail $name! The SSF (Solo Self Found) hard core challenge is a unique challenge that requires you to be level 1 and on an account that has no progression. During this challenge, you will not be able to group with, receive buffs, or heals, from other people who are not partaking in the SSF challenge. Trading is also not permitted. When you begin this challenge, any items you currently possess will be completely destroyed from your inventory and bank. To start this challenge, delete or trade all of your coin in inventory, bank, and shared bank then say [begin]");
    
  }
  elsif (quest::get_data($ssfkey) == 1){
    quest::say("Hail $name! How is your SSF journey going? I can [revert] your flag at any time, just let me know.");
  }
  }

elsif ($text=~/begin/i) {
if ($total > 0) {
  quest::say("Delete all of your money in inventory and bank before starting the challenge!");
}
if ($total == 0) {
if($ulevel > 1){
quest::say("You need to be level 1 to start this challenge!");
}
if($expansion > 0){
quest::say("You need to not have any progression flags to start this challenge!");
}
if($expansion == ""){
if($ulevel == 1) {
if (quest::get_data($ssfkey) == "") {
quest::set_data($ssfkey, 1);
$client->DeleteItemInInventory(0);
$client->DeleteItemInInventory(1);
$client->DeleteItemInInventory(2);
$client->DeleteItemInInventory(3);
$client->DeleteItemInInventory(4);
$client->DeleteItemInInventory(5);
$client->DeleteItemInInventory(6);
$client->DeleteItemInInventory(7);
$client->DeleteItemInInventory(8);
$client->DeleteItemInInventory(9);
$client->DeleteItemInInventory(10);
$client->DeleteItemInInventory(11);
$client->DeleteItemInInventory(12);
$client->DeleteItemInInventory(13);
$client->DeleteItemInInventory(14);
$client->DeleteItemInInventory(15);
$client->DeleteItemInInventory(16);
$client->DeleteItemInInventory(17);
$client->DeleteItemInInventory(18);
$client->DeleteItemInInventory(19);
$client->DeleteItemInInventory(20);
$client->DeleteItemInInventory(21);
$client->DeleteItemInInventory(22);
$client->DeleteItemInInventory(23);
$client->DeleteItemInInventory(24);
$client->DeleteItemInInventory(25);
$client->DeleteItemInInventory(26);
$client->DeleteItemInInventory(27);
$client->DeleteItemInInventory(28);
$client->DeleteItemInInventory(29);
$client->DeleteItemInInventory(30);
$client->DeleteItemInInventory(31);
$client->DeleteItemInInventory(32);
$client->DeleteItemInInventory(33);
$client->DeleteItemInInventory(351);
$client->DeleteItemInInventory(352);
$client->DeleteItemInInventory(353);
$client->DeleteItemInInventory(354);
$client->DeleteItemInInventory(355);
$client->DeleteItemInInventory(356);
$client->DeleteItemInInventory(357);
$client->DeleteItemInInventory(358);
$client->DeleteItemInInventory(359);
$client->DeleteItemInInventory(360);
$client->DeleteItemInInventory(400);
$client->DeleteItemInInventory(401);
$client->DeleteItemInInventory(402);
$client->DeleteItemInInventory(403);
$client->DeleteItemInInventory(404);
$client->DeleteItemInInventory(2000);
$client->DeleteItemInInventory(2001);
$client->DeleteItemInInventory(2002);
$client->DeleteItemInInventory(2003);
$client->DeleteItemInInventory(2004);
$client->DeleteItemInInventory(2005);
$client->DeleteItemInInventory(2006);
$client->DeleteItemInInventory(2007);
$client->DeleteItemInInventory(2008);
$client->DeleteItemInInventory(2009);
$client->DeleteItemInInventory(2010);
$client->DeleteItemInInventory(2011);
$client->DeleteItemInInventory(2012);
$client->DeleteItemInInventory(2013);
$client->DeleteItemInInventory(2014);
$client->DeleteItemInInventory(2015);
$client->DeleteItemInInventory(2016);
$client->DeleteItemInInventory(2017);
$client->DeleteItemInInventory(2018);
$client->DeleteItemInInventory(2019);
$client->DeleteItemInInventory(2020);
$client->DeleteItemInInventory(2021);
$client->DeleteItemInInventory(2022);
$client->DeleteItemInInventory(2023);
$client->DeleteItemInInventory(2500);
$client->DeleteItemInInventory(2501);
$client->SetTitleSuffix("the Soloist", 1);
$client->Message(15, "Welcome to the SSF challenge. If you'd like to turn off this flag, return to me at any time and say [revert]");
}
}
}
}
}

elsif ($text=~/revert/i) {
if (quest::get_data($ssfkey) == 1) {
quest::set_data($ssfkey, "");
}
}
}



