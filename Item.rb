class Item
  attr_accessor(:name,:desc,:adj)
  def initialize(name,desc,adj)
    @name = name
    @desc = desc
    @adj = adj
  end
  def output
    s = @name.clone.capitalize+": "+@desc.clone
    array = []
    x = 72
    while s.length > 80
      if s[x].chr == " "
	array.push s[0..x-1]
	s[0..x] = ""
	s.gsub!(/$\s/,"")
	x = 80
      else
	x-=1
      end
    end
    p @name
    s.gsub!(/$\s/,"")
    array.push s if s.length > 0
    array[0].gsub!(/(^.+)(:)/,"\e[4m"+'\1'+"\e[0m"+'\2')
    p array[0]
    return array.join("\n")
  end
end

$items = [
Item.new("bottle","A bottle designed to hold water for someone to drink when they get thirsty.","water"),
Item.new("crank","A small metal crank that you found on a walkway in the swamp.",""),
Item.new("crystal key","A key made of crystal, found in the labyrinth. If only you knew what it opened...",""),
Item.new("granite piece","A small piece of granite. It looks like it was chisled out of a larger piece.",""),
Item.new("marble piece","A small piece of marble. It looks like it was chisled out of a larger piece.",""),
Item.new("basalt piece","A small piece of basalt. It looks like it was chisled out of a larger piece.",""),
Item.new("quartzite piece","A small piece of quartzite. It looks like it was chisled out of a larger piece.",""),
Item.new("glowing stone","A small crystal given to you by Orion that gives off a blue light in dark places.",""),
Item.new("sapphire","A small blue gemstone given to you by Orion. If you rub it, it should take you back to him.",""),
Item.new("enchanted dagger","A sharp dagger that glows slightly blue. Orion gave it to you to kill Scorpio with.",""),
Item.new("amulet","A gold chain with a pendent on the end. The pendent appears to be solid gold with a ruby set in the center.",""),
Item.new("glass orb","An orb blessed by Draco. When it is brought close to a wizard, it will strip them of their magic and kill them.",""),
Item.new("dark katana","A black katana with an impossibly sharp edge. Pictor gave it to you to kill some people for him.",""),
Item.new("envelope","An envelope made of a thick, yellow paper. A lump of red wax with a seal indicates that it has not been opened.",""),
Item.new("letter","A letter to Scorpio, inquiring as to the progress of his Great Triumph.","")
]
