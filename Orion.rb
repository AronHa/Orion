#!/usr/bin/ruby
require 'Player.rb'
require 'Item.rb'
require 'Map.rb'
require 'Npc.rb'
require 'Cutscene.rb'

def act(cmnd = gets.chomp, self_call=5)
  array = []
  dirs = ["north","west","south","east"]
  cmnd.delete! ".,/?:;'"
  c = cmnd.downcase.split(" ")
  if $player.coords[0] == "Desert"
    $player.thirst+=20
  else
    $player.thirst+=1
  end
  if c.include?("take") || c.include?("grab") || (c.include?("pick") && c.include?("up"))
    if c.include?("all")
      while $loc.items.length > 0
	array.push $loc.items[0].name
	$player.inv.push $loc.items[0]
	$loc.items.delete_at(0)
      end
    else
      $loc.items.each do |i|
	if cmnd.include?(i.name)
	  array.push i.name
	  $player.inv.push(i)
	end
      end
      array.each do |i|
	$loc.items.delete($loc.items.find{ |a| a.name == i })
      end
    end
    if array.length == 0
      return "You did not take anything"
    elsif array.length == 1
      return "You take the #{array[0]}"
    elsif array.length == 2
      return "You take the #{array[0]} and the #{array[1]}"
    else
      return "You take the #{array[0..-2].join(", ")}, and #{array[-1]}"
    end
  elsif c.include?("drop") || (c.include?("put") && c.include?("down"))
    array2 = []
    $player.inv.each do |i|
      if cmnd.include?(i.name)
        array2.push i.name
      end
    end
    array2.each do |i|
      found = $player.inv.find{ |a| a.name == i }
      if found != nil
	array.push found.name
	$player.inv.delete(found)
	$loc.items.push(found)
      end
    end
    if array.length == 0
      return "You did not drop anything"
    elsif array.length == 1
      return "You drop the #{array[0]}"
    elsif array.length == 2
      return "You drop the #{array[0]} and the #{array[1]}"
    else
      return "You drop the #{array[0..-2].join(", ")}, and #{array[-1]}"
    end
  elsif c.include?("n") || c.include?("north")
    if $player.coords[0] == "Quaro" && ($player.coords[1] >= 1 && $player.coords[1] <= 3) && ($player.coords[2] >= 3 && $player.coords[2] <= 5)
      $player.coords[1]+=1 if $place.sectors.find{ |a| a.coords[0] == $player.coords[1]+1 && a.coords[1] == $player.coords[2] }
      return "You go to the north."
    elsif $player.coords[0] == "Beach" && $player.coords[1] == 0 && $player.coords[2] == 1 && $player.flags[1] == 0
      return "You want to enter the cave, but it's too dark, and you don't want to risk being\neaten by a grue."
    elsif $player.coords[0] == "Village" && $player.coords[1] == 1 && $player.coords[2] == 1 && ! $player.inv.find{ |a| a.name == "glowing stone" }
      return "You want to enter the cave, but it's too dark, and you don't want to risk being\neaten by a grue."
    elsif $player.coords[0] == "Labyrinth" && self_call == 5
      return "You do not know which way north is!"
    elsif $loc.walls.include?("north")
      return "You cannot go that direction."
    elsif $place.exits.find{ |a| a[0] == $player.coords[1..2] && a[1] == "north" }
      $player.coords = $place.exits.find{ |a| a[0] == $player.coords[1..2] && a[1] == "north" }[2].dup
      if $player.coords[0] == "Labyrinth"
	$player.face = 0
	return "You go #{c[1]}."
      else
	return "You go to the north."
      end
    elsif $place.sectors.find{ |a| a.coords[0] == $player.coords[1]+1 && a.coords[1] == $player.coords[2] }
      $player.coords[1]+=1
      if $player.coords[0] == "Labyrinth"
	$player.face = 0
	return "You go #{c[1]}."
      else
	return "You go to the north."
      end
    else
      return "You cannot go that direction."
    end
  elsif c.include?("s") || c.include?("south")
    if $player.coords[0] == "Quaro" && ($player.coords[1] >= 1 && $player.coords[1] <= 3) && ($player.coords[2] >= 3 && $player.coords[2] <= 5)
      $player.coords[1]-=1 if $place.sectors.find{ |a| a.coords[0] == $player.coords[1]-1 && a.coords[1] == $player.coords[2] }
      return "You go to the south."
    elsif $player.coords[0] == "Labyrinth" && self_call == 5
      return "You do not know which way south is!"
    elsif $loc.walls.include?("south")
      return "You cannot go that direction."
    elsif $place.exits.find{ |a| a[0] == $player.coords[1..2] && a[1] == "south" }
      $player.coords = $place.exits.find{ |a| a[0] == $player.coords[1..2] && a[1] == "south" }[2].dup
      if $player.coords[0] == "Labyrinth"
	$player.face = 2
	return "You go #{c[1]}."
      else
	return "You go to the south."
      end
    elsif $place.sectors.find{ |a| a.coords[0] == $player.coords[1]-1 && a.coords[1] == $player.coords[2] }
      $player.coords[1]-=1
      if $player.coords[0] == "Labyrinth"
	$player.face = 2
	return "You go #{c[1]}."
      else
	return "You go to the south."
      end
    else
      return "You cannot go that direction."
    end
  elsif c.include?("e") || c.include?("east")
    p $loc.walls
    if $player.coords[0] == "Quaro" && ($player.coords[1] >= 1 && $player.coords[1] <= 3) && ($player.coords[2] >= 3 && $player.coords[2] <= 5)
      $player.coords[2]+=1 if $place.sectors.find{ |a| a.coords[0] == $player.coords[1] && a.coords[1] == $player.coords[2]+1 }
      return "You go to the east."
    elsif $player.coords[0] == "Desert" && $player.coords[2] == 2
      return "You go to the east."
    elsif $player.coords[0] == "Canyon" && $player.coords[1] == 1 && $player.coords[2] == 2 && ! $player.inv.find{ |a| a.name == "glowing stone" }
      return "You want to enter the cave, but it's too dark, and you don't want to risk being\neaten by a grue."
    elsif $player.coords[0] == "Labyrinth" && self_call == 5
      return "You do not know which way east is!"
    elsif $loc.walls.include?("east")
      return "You cannot go that direction."
    elsif $place.exits.find{ |a| a[0] == $player.coords[1..2] && a[1] == "east" }
      $player.coords = $place.exits.find{ |a| a[0] == $player.coords[1..2] && a[1] == "east" }[2].dup
      if $player.coords[0] == "Labyrinth"
	$player.face = 3
	return "You go #{c[1]}."
      else
	return "You go to the east."
      end
    elsif $place.sectors.find{ |a| a.coords[0] == $player.coords[1] && a.coords[1] == $player.coords[2]+1 }
      $player.coords[2]+=1
      if $player.coords[0] == "Labyrinth"
	$player.face = 3
	return "You go #{c[1]}."
      else
	return "You go to the east."
      end
    else
      return "You cannot go that direction."
    end
  elsif c.include?("w") || c.include?("west")
    if $player.coords[0] == "Quaro" && ($player.coords[1] >= 1 && $player.coords[1] <= 3) && ($player.coords[2] >= 3 && $player.coords[2] <= 5)
      $player.coords[2]-=1 if $place.sectors.find{ |a| a.coords[0] == $player.coords[1] && a.coords[1] == $player.coords[2]-1 }
      return "You go to the west."
    elsif $player.coords[0] == "Desert" && $player.coords[2] == 0
      return "You go to the west."
    elsif $player.coords[0] == "Labyrinth" && self_call == 5
      return "You do not know which way west is!"
    elsif $loc.walls.include?("west")
      return "You cannot go that direction."
    elsif $place.exits.find{ |a| a[0] == $player.coords[1..2] && a[1] == "west" }
      $player.coords = $place.exits.find{ |a| a[0] == $player.coords[1..2] && a[1] == "west" }[2].dup
      if $player.coords[0] == "Labyrinth"
	$player.face = 1
	return "You go #{c[1]}."
      else
	return "You go to the west."
      end
    elsif $place.sectors.find{ |a| a.coords[0] == $player.coords[1] && a.coords[1] == $player.coords[2]-1 }
      $player.coords[2]-=1
      if $player.coords[0] == "Labyrinth"
	$player.face = 1
	return "You go #{c[1]}."
      else
	return "You go to the west."
      end
    else
      return "You cannot go that direction."
    end
  elsif c.include?("u") || c.include?("up")
    if $loc.walls.include?("up")
      return "You cannot go that direction."
    elsif $place.exits.find{ |a| a[0] == $player.coords[1..2] && a[1] == "up" }
      $player.coords = $place.exits.find{ |a| a[0] == $player.coords[1..2] && a[1] == "up" }[2].dup
      return "You go up."
    else
      return "You cannot go that direction."
    end
  elsif c.include?("d") || c.include?("down")
    if $player.coords == ["Labyrinth Entrance",3,0]
      $player.face = 3
    elsif $player.coords == ["Labyrinth Entrance",5,8]
      $player.face = 1
    end
    if $loc.walls.include?("down")
      return "You cannot go that direction."
    elsif $place.exits.find{ |a| a[0] == $player.coords[1..2] && a[1] == "down" }
      $player.coords = $place.exits.find{ |a| a[0] == $player.coords[1..2] && a[1] == "down" }[2].dup
      return "You go down."
    else
      return "You cannot go that direction."
    end
  elsif c.include?("forward")
    act(dirs[$player.face]+" forward",0)
  elsif c.include?("left")
    act(dirs[$player.face-3]+" left",1)
  elsif c.include?("backward")
    act(dirs[$player.face-2]+" backward",2)
  elsif c.include?("right")
    act(dirs[$player.face-1]+" right",3)
  elsif c.include?("quaro")
    if ($player.coords == ["Seta",2,2] || $player.coords == ["Arepo",2,2] || $player.coords == ["Muu Shasa",2,2]) && $areas[21].visited
      $player.coords = ["Quaro",2,4]
      return "You say the name of the city, and you suddenly find yourself standing there"
    else
      return "I cannot process that action"
    end
  elsif c.include?("seta")
    if ($player.coords == ["Quaro",2,4] || $player.coords == ["Arepo",2,2] || $player.coords == ["Muu Shasa",2,2]) && $areas[83].visited
      $player.coords = ["Seta",2,2]
      return "You say the name of the city, and you suddenly find yourself standing there"
    else
      return "I cannot process that action"
    end
  elsif c.include?("arepo")
    if ($player.coords == ["Quaro",2,4] || $player.coords == ["Seta",2,2] || $player.coords == ["Muu Shasa",2,2]) && $areas[117].visited
      $player.coords = ["Arepo",2,2]
      return "You say the name of the city, and you suddenly find yourself standing there"
    else
      return "I cannot process that action"
    end
  elsif c.include?("muu") && c.include?("shasa")
    if ($player.coords == ["Quaro",2,4] || $player.coords == ["Seta",2,2] || $player.coords == ["Arepo",2,2]) && $areas[181].visited
      $player.coords = ["Muu Shasa",2,2]
      return "You say the name of the city, and you suddenly find yourself standing there"
    else
      return "I cannot process that action"
    end
  elsif c.include?("i") || c.include?("inv") || c.include?("inventory")
    $player.inv.each do |i|
      if i.adj != ""
	array.push "  "+i.name.capitalize+" (#{i.adj.capitalize})"
      else
	array.push "  "+i.name.capitalize
      end
    end
    return "Inventory:\n"+array.join("\n")
  elsif c.include?("l") || c.include?("look")
    $place.display(true)
    $action = act
  elsif c.include?("x") || c.include?("examine")
    if (c.include?("spire") || c.include?("pillar") || c.include?("glyphs")) && ($player.coords[0] == "Village" && $player.coords[1] == 1 && $player.coords[2] == 2)
      return "You look closely at the glyphs written on the stone spire. They mean nothing to you, and you quickly grow bored of trying to make sense of them."
    else
      $player.inv.each do |i|
	array.push(i.output) if cmnd.include?(i.name)
      end
      if array.length > 0
        array.collect!{ |a| "\t"+a }
        return array.join("\n")
      else
        return "I cannot process that action"
      end
    end
  elsif c.include?("drink") || c.include?("quaff")
    if $player.coords[0] == "Waterworks" && $player.coords[1] == 2 && $player.coords[2] == 1
      $player.thirst-=30
      $player.thirst = 0 if $player.thirst < 0
      return "You drink the water from the spigot."
    elsif $player.coords[0] == "Village" && $player.coords[1] == 1 && $player.coords[2] == 1
      $player.thirst-=30
      $player.thirst = 0 if $player.thirst < 0
      return "You drink the water from the pump."
    elsif $player.coords[0] == "Labyrinth Entrance" && $player.coords[1] == 5 && $player.coords[2] == 8
      $player.thirst-=30
      $player.thirst = 0 if $player.thirst < 0
      return "You drink the water from the pump."
    elsif $player.coords[0] == "Secret Village" && $player.coords[1] == 1 && $player.coords[2] == 1
      $player.thirst-=30
      $player.thirst = 0 if $player.thirst < 0
      return "You drink the water from the well."
    elsif $player.inv.find{ |a| a.name == "bottle" }
      if $player.inv.find{ |a| a.name == "bottle" }.adj == "water"
	$player.thirst-=30
	$player.thirst = 0 if $player.thirst < 0
	$player.inv.find{ |a| a.name == "bottle" }.adj = "empty"
      elsif $player.inv.find{ |a| a.name == "bottle" }.adj == "potion"
	$player.thirst = 0
	$player.inv.find{ |a| a.name == "bottle" }.adj = "empty"
      end
      return "You drink the water. The bottle is now empty."
    else
      return "I cannot process that action"
    end
  elsif c.include?("fill") && c.include?("bottle")
    if $player.inv.find{ |a| a.name == "bottle"} && $player.inv.find{ |a| a.name == "bottle"}.adj != "empty"
      return "You already have water in your bottle."
    elsif $player.coords[0] == "Waterworks" && $player.coords[1] == 2 && $player.coords[2] == 1
      if $player.inv.find{ |a| a.name == "bottle"}
	$player.inv.find{ |a| a.name == "bottle"}.adj = "water"
	return "You fill your bottle with water."
      else
	return "You have no bottle to put the water in."
      end
    elsif $player.coords[0] == "Village" && $player.coords[1] == 1 && $player.coords[2] == 1
      if $player.inv.find{ |a| a.name == "bottle"}
	$player.inv.find{ |a| a.name == "bottle"}.adj = "water"
	return "You fill your bottle with water."
      else
	return "You have no bottle to put the water in."
      end
    elsif $player.coords[0] == "Labyrinth Entrance" && $player.coords[1] == 5 && $player.coords[2] == 8
      if $player.inv.find{ |a| a.name == "bottle"}
	$player.inv.find{ |a| a.name == "bottle"}.adj = "water"
	return "You fill your bottle with water."
      else
	return "You have no bottle to put the water in."
      end
    elsif $player.coords[0] == "Secret Village" && $player.coords[1] == 1 && $player.coords[2] == 1
      if $player.inv.find{ |a| a.name == "bottle"}
	$player.inv.find{ |a| a.name == "bottle"}.adj = "water"
	return "You fill your bottle with water."
      else
	return "You have no bottle to put the water in."
      end
    else
      if $player.inv.find{ |a| a.name == "bottle"}
	return "There is no water here that you would consider drinkable."
      else
	return "I cannot process that action"
      end
    end
  elsif (c.include?("fix") || c.include?("repair")) && (c.include?("arch") || c.include?("archway"))
    if $player.coords[0] == "Quaro" && $player.coords[1] == 2 && $player.coords[2] == 4 && $player.inv.find{ |a| a.name == "granite piece"}
      $player.flags[13] = 1
      $sectors[21].set_area(216)
      $player.inv.delete($player.inv.find{ |a| a.name == "granite piece"})
      return "You put the missing piece of granite back into the arch. Now that you see the\ncolossal granite arch complete, it can only be rightfully described as flawless."
    elsif $player.coords[0] == "Seta" && $player.coords[1] == 2 && $player.coords[2] == 2 && $player.inv.find{ |a| a.name == "marble piece"}
      $player.flags[14] = 1
      $sectors[83].set_area(217)
      $player.inv.delete($player.inv.find{ |a| a.name == "marble piece"})
      return "You put the missing piece of marble back into the arch. Now that you see the\nolossal marble arch complete, it can only be rightfully described as flawless."
    elsif $player.coords[0] == "Arepo" && $player.coords[1] == 2 && $player.coords[2] == 2 && $player.inv.find{ |a| a.name == "basalt piece"}
      $player.flags[15] = 1
      $sectors[117].set_area(218)
      $player.inv.delete($player.inv.find{ |a| a.name == "basalt piece"})
      return "You put the missing piece of basalt back into the arch. Now that you see the\nolossal basalt arch complete, it can only be rightfully described as flawless."
    elsif $player.coords[0] == "Muu Shasa" && $player.coords[1] == 2 && $player.coords[2] == 2 && $player.inv.find{ |a| a.name == "quartzite piece"}
      $player.flags[16] = 1
      $sectors[181].set_area(219) if $player.flags[1] != 7
      $player.inv.delete($player.inv.find{ |a| a.name == "quartzite piece"})
      return "You put the missing piece of quartzite back into the arch. Now that you see the colossal quartzite arch complete, it can only be rightfully described as\nflawless."
    else
      return "I cannot process that action"
    end
  elsif c.include?("replace") || c.include?("place") || c.include?("put")
    if (c.include?("granite") || c.include?("piece")) && $player.coords[0] == "Quaro" && $player.coords[1] == 2 && $player.coords[2] == 4 && $player.inv.find{ |a| a.name == "granite piece"}
      $player.flags[13] = 1
      $sectors[21].set_area(216)
      $player.inv.delete($player.inv.find{ |a| a.name == "granite piece"})
      return "You put the missing piece of granite back into the arch. Now that you see the\ncolossal granite arch complete, it can only be rightfully described as flawless."
    elsif (c.include?("marble") || c.include?("piece")) && $player.coords[0] == "Seta" && $player.coords[1] == 2 && $player.coords[2] == 2 && $player.inv.find{ |a| a.name == "marble piece"}
      $player.flags[14] = 1
      $sectors[83].set_area(217)
      $player.inv.delete($player.inv.find{ |a| a.name == "marble piece"})
      return "You put the missing piece of marble back into the arch. Now that you see the\ncolossal marble arch complete, it can only be rightfully described as flawless."
    elsif (c.include?("basalt") || c.include?("piece")) && $player.coords[0] == "Arepo" && $player.coords[1] == 2 && $player.coords[2] == 2 && $player.inv.find{ |a| a.name == "basalt piece"}
      $player.flags[15] = 1
      $sectors[117].set_area(218)
      $player.inv.delete($player.inv.find{ |a| a.name == "basalt piece"})
      return "You put the missing piece of basalt back into the arch. Now that you see the\ncolossal basalt arch complete, it can only be rightfully described as flawless."
    elsif (c.include?("quartzite") || c.include?("piece")) && $player.coords[0] == "Muu Shasa" && $player.coords[1] == 2 && $player.coords[2] == 2 && $player.inv.find{ |a| a.name == "quartzite piece"}
      $player.flags[16] = 1
      $sectors[181].set_area(219)
      $player.inv.delete($player.inv.find{ |a| a.name == "quartzite piece"})
      return "You put the missing piece of quartzite back into the arch. Now that you see the colossal quartzite arch complete, it can only be rightfully described as\nflawless."
    else
      return "I cannot process that action"
    end
  elsif c.include?("open") && c.include?("envelope")
    #Open the letter
    if $player.inv.find{ |a| a.name == "envelope" }
      $player.inv.delete($player.inv.find{ |a| a.name == "envelope"})
      $player.inv.push($items.find{ |a| a.name == "letter"} )
      return "You open the envelope and read the letter. It reads:\n\nScorpio,\n\nYou have failed to return our coorespondence for several months now. We need\nconfirmation that you and your apprentice are capable of carrying out the\nmission. We need to know the progress you have made toward completing the Great\nTriumph. If you do not respond within 30 days in the usual way, we will assume\nyou have either died or defected, and will take immediate steps to secure the\nisland.\n\nArk"
    else
      return "I cannot process that action"
    end
  elsif c.include?("read") && c.include?("letter")
    if $player.inv.find{ |a| a.name == "letter" }
      return "The letter reads:\n\nScorpio,\n\nYou have failed to return our coorespondence for several months now. We need\nconfirmation that you and your apprentice are capable of carrying out the\nmission. We need to know the progress you have made toward completing the Great\nTriumph. If you do not respond within 30 days in the usual way, we will assume\nyou have either died or defected, and will take immediate steps to secure the\nisland.\n\nArk"
    else
      return "I cannot process that action"
    end
  elsif c.include?("talk")
    if $player.coords == ["Village",0,1] && $player.flags[18] == 0
      talk("Orion")
      return "You are done talking to Orion"
    elsif $player.coords == ["Shrine",0,2] && $player.flags[19] == 0
      talk("Draco")
      return "You are done talking to Draco"
    elsif $player.coords == ["Walkway",0,3] && $player.flags[20] == 0
      talk("Sagitta")
      return "You are done talking to Sagitta"
    elsif $player.coords == ["Tower Floor 3",0,0] && $player.flags[21] == 0
      talk("Pictor")
      return "You are done talking to Pictor"
    elsif $player.coords == ["Scorpio's Tower, Floor 2",0,0] && $player.flags[22] == 0
      talk("Scorpio")
      return "You are done talking to Scorpio"
    elsif $player.coords == ["Muu Shasa",2,2] && $player.flags[1] == 7
      talk("Orion")
      return "You are done talking to Orion"
    elsif $player.coords == ["Muu Shasa",2,2] && $player.flags[6] == 4
      talk("Draco")
      return "You are done talking to Draco"
    elsif $player.coords == ["Muu Shasa",2,2] && $player.flags[12] == 4
      talk("Scorpio")
      return "You are done talking to Scorpio"
    else
      return "I cannot process that action"
    end
  elsif (c.include?("unlock") || c.include?("lock") || c.include?("key")) && ($player.coords[0] == "Shrine" && $player.coords[1] == 0 && $player.coords[2] == 2)
    if $player.inv.find{ |a| a.name == "crystal key"}
      return "Your key does not fit into this lock"
    else
      return "I cannot process that action"
    end
  elsif c.include?("rub") && c.include?("sapphire") && $player.inv.find{ |a| a.name == "sapphire" }
    $player.coords = ["Village",0,1]
    return "You suddenly find yourself in Orion's village."
  elsif c.include?("crank") && $player.coords == ["Swamp",2,1] && $player.inv.find{ |a| a.name == "crank" }
    $sectors[94].walls.delete("north")
    $sectors[97].walls.delete("south")
    $sectors[94].set_area(234)
    $sectors[97].set_area(235)
    return "You put the crank in the box and turn it. A walkway of damp, rotting wood rises\nout of the swamp to the south."
  elsif c.include?("boat") && $player.flags[9] == 7 && $player.coords[0] == "Arepo" && $player.coords[1] == 3 && $player.coords[2] == 5
    run_scene(16)
  elsif c.include?("quit") || c.include?("exit")
    exit
  elsif c.include?("tp")
    $player.coords = ["Muu Shasa",2,2]
    $player.inv.push($items.find{ |a| a.name == "quartzite piece" })
    $player.flags[18] = 1
    $player.flags[1] = 7
  else
    return "I cannot process that action"
  end
end

$player = Player.new(["Beach",0,0])
game = true
$action = ""

while game
  $place = $maps.find{ |a| a.name == $player.coords[0] }
  $loc = $place.sectors.find{ |a| a.coords == $player.coords[1..2] }
  $place.display
  $action = act
  if $player.thirst >= 100
    $action = "You pass out from extreme thirst. Eventually you come back to..."
    $player.thirst = 0
    if $areas[181].visited
      $player.coords = ["Muu Shasa",2,2]
    elsif $areas[117].visited
      $player.coords = ["Arepo",2,2]
    elsif $areas[83].visited
      $player.coords = ["Seta",2,2]
    elsif $areas[21].visited
      $player.coords = ["Quaro",2,4]
    else
      $player.coords = ["Beach",0,0]
    end
  end
  if ($player.flags[18] == 1 && $player.flags[19] == 1 && $player.flags[21] == 1 && $player.flags[22] == 1) && (! $player.flags[1] == 7 && ! $player.flags[6] == 4 && ! $player.flags[12] == 4) #All NPCs are dead and not in Muu Shasa
    run_scene(1) #Game over, you can't win
  elsif $player.flags[19] == 1 && (! $areas[117].visited && ! $areas[181].visited) #Killed Draco without visiting Arepo or Muu Shasa (Can't pass desert)
    if $player.flags[18] == 1
      run_scene(2)
    else
      run_scene(3)
    end
  end
end
#TODO: Desert too easy
