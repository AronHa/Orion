require 'Sector.rb'

class Map
  attr_accessor(:name,:sectors,:exits)
  def initialize(name,sectors,exits)
    @name = name
    @sectors = $sectors[sectors[0]..sectors[1]]
    @exits = exits
  end
  def display(looked=false)
    x = 78-self.name.length
    print "\e[2J\e[H\e[40m."+(" "*(x/2))+"\e[97m#{self.name}\e[30m"+(" "*(x/2.0).round)+".\e[m"
    $loc.view_sector(looked)
    puts $action if ! looked
    print "\e[22HThirst: "
    if $player.thirst < 20
      puts "\e[1mFine\e[0m"
    elsif $player.thirst < 40
      puts "\e[1mDry\e[0m"
    elsif $player.thirst < 60
      puts "\e[1mThirsty\e[0m"
    elsif $player.thirst < 80
      puts "\e[1mReally Thirsty\e[0m"
    else
      puts "\e[1mParched\e[0m"
    end
    if $player.coords[0] == "Labyrinth"
      print "\e[23H[#{rand(9)},#{rand(9)}]\t"
    else
      print "\e[23H[#{$player.coords[1]},#{$player.coords[2]}]\t"
    end
    print "\n> "
  end
end

$maps = [
#			[coords,direct,[new_coords]],[coords,direct...]
Map.new("Beach",[0,2],[[[0,1],"north",["Cave",0,1]],[[0,2],"east",["Village",0,0]]]),
Map.new("Cave",[3,9],[[[0,1],"south",["Beach",0,1]],[[1,0],"west",["Mine",0,1]],[[2,2],"north",["Quaro",0,4]]]),
Map.new("Mine",[10,11],[[[0,1],"east",["Cave",1,0]]]),
Map.new("Quaro",[12,28],[[[0,4],"south",["Cave",2,2]],[[2,1],"up",["Treehouses",1,1]],[[3,6],"east",["Canyon",2,0]],[[2,6],"east",["Canyon",1,0]],[[4,4],"north",["Waterworks",0,1]]]),
Map.new("Treehouses",[29,37],[[[1,1],"down",["Quaro",2,1]]]),
Map.new("Waterworks",[38,44],[[[0,1],"south",["Quaro",4,4]]]),
Map.new("Village",[45,50],[[[0,0],"west",["Beach",0,2]],[[0,2],"east",["Swamp",0,0]],[[1,1],"north",["Damp Cave",0,0]]]),
Map.new("Canyon",[51,59],[[[0,0],"south",["Dark Cave",0,0]],[[0,2],"north",["Canyon",2,2]],[[1,2],"east",["Damp Cave",3,1]],[[1,0],"west",["Quaro",2,6]],[[2,2],"east",["Seta",2,0]],[[2,2],"south",["Canyon",0,2]]]),
Map.new("Damp Cave",[60,70],[[[3,1],"west",["Canyon",1,2]],[[0,0],"south",["Village",1,1]],[[0,2],"up",["Dark Cave",0,5]],[[1,0],"up",["Dark Cave",0,2]]]),
Map.new("Dark Cave",[71,76],[[[0,2],"down",["Damp Cave",1,0]],[[0,5],"down",["Damp Cave",0,2]],[[0,0],"north",["Canyon",0,0]]]),
Map.new("Seta",[77,89],[[[0,2],"south",["Swamp",2,1]],[[2,0],"west",["Canyon",2,2]],[[2,4],"east",["Shrine",0,0]],[[4,2],"north",["Desert",0,1]]]),
Map.new("Shrine",[90,92],[[[0,0],"west",["Seta",2,4]],[[0,2],"east",["Secret Village",0,0]]]),
Map.new("Swamp",[93,97],[[[0,0],"west",["Village",0,2]],[[2,1],"north",["Seta",0,2]]]),
Map.new("Desert",[98,112],[[[0,1],"south",["Seta",4,2]],[[4,1],"north",["Arepo",0,3]]]),
Map.new("Arepo",[113,124],[[[0,3],"south",["Desert",4,1]],[[2,0],"west",["Labyrinth Entrance",5,8]],[[5,2],"north",["Tower Floor 1",0,0]]]),
Map.new("Tower Floor 1",[125,125],[[[0,0],"south",["Arepo",5,2]],[[0,0],"up",["Tower Floor 2",0,0]]]),
Map.new("Tower Floor 2",[126,126],[[[0,0],"south",["Walkway",3,1]],[[0,0],"up",["Tower Floor 3",0,0]],[[0,0],"down",["Tower Floor 1",0,0]]]),
Map.new("Tower Floor 3",[127,127],[[[0,0],"down",["Tower Floor 2",0,0]]]),
Map.new("Walkway",[128,139],[[[3,1],"north",["Tower Floor 2",0,0]]]),
Map.new("Labyrinth Entrance",[140,141],[[[5,8],"east",["Arepo",2,0]],[[5,8],"down",["Labyrinth",5,8]],[[3,0],"west",["Muu Shasa",0,3]],[[3,0],"north",["Muu Shasa",1,4]],[[3,0],"down",["Labyrinth",3,0]]]),

Map.new("Labyrinth",[142,174],[[[5,8],"up",["Labyrinth Entrance",5,8]],[[3,0],"up",["Labyrinth Entrance",3,0]],[[1,5],"north",["Labyrinth",3,5]],[[3,5],"south",["Labyrinth",1,5]],[[2,4],"north",["Labyrinth",4,4]],[[4,4],"south",["Labyrinth",2,4]],[[3,1],"east",["Labyrinth",3,3]],[[3,3],"west",["Labyrinth",3,1]],[[4,2],"east",["Labyrinth",4,4]],[[4,4],"west",["Labyrinth",4,2]],[[4,6],"west",["Labyrinth",4,4]],[[4,4],"east",["Labyrinth",4,6]],[[4,7],"north",["Labyrinth",6,7]],[[6,7],"south",["Labyrinth",4,7]],[[5,3],"north",["Labyrinth",7,3]],[[7,3],"south",["Labyrinth",5,3]],[[5,5],"east",["Labyrinth",5,7]],[[5,7],"west",["Labyrinth",5,5]],[[6,4],"south",["Labyrinth",4,4]],[[4,4],"north",["Labyrinth",6,4]],[[7,2],"east",["Labyrinth",7,4]],[[7,4],"west",["Labyrinth",7,2]]]),	#STUPID 	LABYRINTH!!!!!! >:( 

Map.new("Muu Shasa",[175,187],[[[0,3],"east",["Labyrinth Entrance",3,0]],[[1,4],"south",["Labyrinth Entrance",3,0]],[[3,0],"north",["Scorpio's Tower, Floor 1",0,2]],[[4,1],"west",["Scorpio's Tower, Floor 1",2,3]]]),
Map.new("Scorpio's Tower, Floor 1",[188,203],[[[0,2],"south",["Muu Shasa",3,0]],[[2,3],"east",["Muu Shasa",4,1]],[[2,2],"up",["Scorpio's Tower, Floor 2",1,1]],[[0,2],"north",["Scorpio's Tower, Floor 1",3,1]],[[1,0],"east",["Scorpio's Tower, Floor 1",2,3]],[[2,3],"west",["Scorpio's Tower, Floor 1",1,0]],[[3,1],"south",["Scorpio's Tower, Floor 1",0,2]]]),
Map.new("Scorpio's Tower, Floor 2",[204,207],[[[1,1],"down",["Scorpio's Tower, Floor 1",2,2]],[[1,0],"up",["Scorpio's Tower, Floor 3",0,0]]]),
Map.new("Scorpio's Tower, Floor 3",[208,208],[[[0,0],"down",["Scorpio's Tower, Floor 2",1,0]]]),
Map.new("Secret Village",[209,215],[[[1,0],"west",["Shrine",0,2]]])
#I'M DONE!
]
