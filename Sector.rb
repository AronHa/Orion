require 'Area.rb'
$sectors = nil

class Sector
  attr_accessor(:coords,:area,:items,:walls)
  def initialize(coords,items,walls)
    @coords = coords
    @items = items.collect{ |a| $items.find{ |i| i.name == a } }
    @area = 0
    @walls = walls
    #the direction that you don't want the player to go: e.g. "north" or "east"
  end
  def set_area(new_area=nil)
    if new_area == nil
      @area = $areas[$sectors.index(self)]
    else
      @area = $areas[new_area]
    end
  end
  def view_sector(looked)
    if looked || ! self.area.visited
      puts self.area.output(area.l_desc)
      area.visited = true
    else
      puts self.area.output(area.s_desc)
    end

    array = []
    items.each { |i| array.push "\e[4m"+i.name+"\e[0m" }
    if array.length == 0
      puts "You see nothing of interest here."
    elsif array.length == 1
      puts "You see a #{array[0]}."
    elsif array.length == 2
      puts "You see a #{array[0]} and a #{array[1]}."
    else
      puts "You see a #{array[0..-2].join(", a ")}, and a #{array[-1]}."
    end
  end
end

$sectors = [
#Beach
Sector.new([0,0],["bottle"],[]),
Sector.new([0,1],[],[]),
Sector.new([0,2],[],[]),
#Cave
Sector.new([0,0],[],[]),
Sector.new([0,1],[],[]),
Sector.new([0,2],[],[]),
Sector.new([1,0],[],[]),
Sector.new([1,1],[],[]),
Sector.new([2,1],[],[]),
Sector.new([2,2],[],[]),
#Mine
Sector.new([0,1],[],[]),
Sector.new([0,0],["granite piece"],[]),
#Quaro
Sector.new([0,3],[],[]),
Sector.new([0,4],[],[]),
Sector.new([1,3],[],[]),
Sector.new([1,4],[],[]),
Sector.new([1,5],[],[]),
Sector.new([2,0],[],[]),
Sector.new([2,1],[],[]),
Sector.new([2,2],[],[]),
Sector.new([2,3],[],[]),
Sector.new([2,4],[],[]),
Sector.new([2,5],[],[]),
Sector.new([2,6],[],[]),
Sector.new([3,3],[],[]),
Sector.new([3,4],[],[]),
Sector.new([3,5],[],[]),
Sector.new([3,6],[],[]),
Sector.new([4,4],[],[]),
#Treehouses
Sector.new([0,0],[],["north"]),
Sector.new([0,1],[],[]),
Sector.new([0,2],[],["north"]),
Sector.new([1,0],[],["north","south"]),
Sector.new([1,1],[],["north"]),
Sector.new([1,2],[],["south"]),
Sector.new([2,0],[],["south"]),
Sector.new([2,1],["envelope"],["south"]),
Sector.new([2,2],[],[]),
#Waterworks
Sector.new([0,0],[],[]),
Sector.new([0,1],[],[]),
Sector.new([0,2],[],[]),
Sector.new([1,0],[],[]),
Sector.new([1,1],[],[]),
Sector.new([1,2],[],[]),
Sector.new([2,1],[],[]),
#Village
Sector.new([0,0],[],[]),
Sector.new([0,1],[],[]),
Sector.new([0,2],[],[]),
Sector.new([1,0],[],[]),
Sector.new([1,1],[],["east"]),
Sector.new([1,2],[],["west"]),
#Canyon
Sector.new([0,0],[],["north"]),
Sector.new([0,1],[],["north"]),
Sector.new([0,2],[],[]),
Sector.new([1,0],[],["north","south"]),
Sector.new([1,1],[],["north","south"]),
Sector.new([1,2],[],["north","south"]),
Sector.new([2,0],["amulet"],["south"]),
Sector.new([2,1],[],["south"]),
Sector.new([2,2],[],[]),
#Damp Cave
Sector.new([0,0],[],[]),
Sector.new([0,1],[],[]),
Sector.new([0,2],[],["north"]),
Sector.new([1,0],[],["east"]),
Sector.new([1,1],[],["north","west"]),
Sector.new([1,2],[],["south"]),
Sector.new([2,0],[],[]),
Sector.new([2,1],[],["south","east"]),
Sector.new([2,2],[],["west"]),
Sector.new([3,1],[],[]),
Sector.new([3,2],[],[]),
#Dark Cave
Sector.new([0,0],[],[]),
Sector.new([0,1],[],[]),
Sector.new([0,2],[],["east"]),
Sector.new([0,3],["marble piece"],["west"]),
Sector.new([0,4],[],[]),
Sector.new([0,5],[],[]),
#Seta
Sector.new([0,2],[],[]),
Sector.new([1,1],[],[]),
Sector.new([1,2],[],[]),
Sector.new([1,3],[],[]),
Sector.new([2,0],[],[]),
Sector.new([2,1],[],[]),
Sector.new([2,2],[],[]),
Sector.new([2,3],[],[]),
Sector.new([2,4],[],[]),
Sector.new([3,1],[],[]),
Sector.new([3,2],[],[]),
Sector.new([3,3],[],[]),
Sector.new([4,2],[],[]),
#Shrine
Sector.new([0,0],[],[]),
Sector.new([0,1],[],[]),
Sector.new([0,2],[],["east"]),
#Swamp
Sector.new([0,0],[],[]),
Sector.new([0,1],[],["north"]),
Sector.new([0,2],["crank"],[]),
Sector.new([1,1],[],[]),
Sector.new([2,1],[],["south"]),
#Desert
Sector.new([0,0],[],[]),
Sector.new([0,1],[],[]),
Sector.new([0,2],[],[]),
Sector.new([1,0],[],[]),
Sector.new([1,1],[],[]),
Sector.new([1,2],[],[]),
Sector.new([2,0],[],[]),
Sector.new([2,1],[],[]),
Sector.new([2,2],[],[]),
Sector.new([3,0],[],[]),
Sector.new([3,1],[],[]),
Sector.new([3,2],[],[]),
Sector.new([4,0],[],[]),
Sector.new([4,1],[],[]),
Sector.new([4,2],[],[]),
#Arepo
Sector.new([0,3],[],[]),
Sector.new([1,3],[],[]),
Sector.new([2,0],[],[]),
Sector.new([2,1],[],[]),
Sector.new([2,2],[],[]),
Sector.new([2,3],[],[]),
Sector.new([3,2],[],[]),
Sector.new([3,3],[],[]),
Sector.new([3,4],[],[]),
Sector.new([3,5],[],[]),
Sector.new([4,2],[],[]),
Sector.new([5,2],[],[]),
#Basalt Tower
Sector.new([0,0],[],[]),
Sector.new([0,0],[],["up"]),
Sector.new([0,0],[],[]),
#Walkway
Sector.new([0,0],[],[]),
Sector.new([0,1],[],[]),
Sector.new([0,2],[],[]),
Sector.new([0,3],[],[]),
Sector.new([1,0],[],[]),
Sector.new([1,3],[],[]),
Sector.new([2,0],[],[]),
Sector.new([2,3],[],[]),
Sector.new([3,0],[],[]),
Sector.new([3,1],[],[]),
Sector.new([3,2],[],[]),
Sector.new([3,3],[],[]),
#Labyrinth Entrance
Sector.new([5,8],[],[]),
Sector.new([3,0],[],[]),
#Labyrinth
Sector.new([0,5],["basalt piece"],[]),
Sector.new([1,4],[],[]),
Sector.new([1,5],[],[]),
Sector.new([1,6],[],[]),
Sector.new([2,1],[],[]),
Sector.new([2,2],[],[]),
Sector.new([2,3],[],[]),
Sector.new([2,4],[],[]),
Sector.new([2,6],[],[]),
Sector.new([3,0],[],[]),
Sector.new([3,1],[],[]),
Sector.new([3,3],[],[]),
Sector.new([3,5],[],[]),
Sector.new([3,6],[],[]),
Sector.new([4,1],[],[]),
Sector.new([4,2],[],[]),
Sector.new([4,4],[],[]),
Sector.new([4,6],[],[]),
Sector.new([4,7],[],[]),
Sector.new([5,2],[],[]),
Sector.new([5,3],[],[]),
Sector.new([5,5],[],[]),
Sector.new([5,7],[],[]),
Sector.new([5,8],[],[]),
Sector.new([6,2],[],[]),
Sector.new([6,4],[],[]),
Sector.new([6,5],[],[]),
Sector.new([6,6],[],[]),
Sector.new([6,7],[],[]),
Sector.new([7,2],[],[]),
Sector.new([7,3],[],[]),
Sector.new([7,4],[],[]),
Sector.new([8,3],["crystal key"],[]),
#Muu Shasa
Sector.new([0,2],[],[]),
Sector.new([0,3],[],[]),
Sector.new([1,2],[],[]),
Sector.new([1,4],[],[]),
Sector.new([2,0],[],[]),
Sector.new([2,1],[],[]),
Sector.new([2,2],[],[]),
Sector.new([2,3],[],[]),
Sector.new([2,4],[],[]),
Sector.new([3,0],[],[]),
Sector.new([3,2],[],[]),
Sector.new([4,1],[],[]),
Sector.new([4,2],[],[]),
#Genco, Floor 1
Sector.new([0,0],[],["east"]),
Sector.new([0,1],[],["west"]),
Sector.new([0,2],[],[]),
Sector.new([0,3],[],["north"]),
Sector.new([1,0],[],[]),
Sector.new([1,1],[],[]),
Sector.new([1,2],[],["south","west"]),
Sector.new([1,3],[],["south"]),
Sector.new([2,0],[],["north","east"]),
Sector.new([2,1],[],["north","west"]),
Sector.new([2,2],[],["north","east"]),
Sector.new([2,3],[],[]),
Sector.new([3,0],[],["south"]),
Sector.new([3,1],[],[]),
Sector.new([3,2],[],["south","east"]),
Sector.new([3,3],[],["west"]),
#Genco, Floor 2
Sector.new([0,0],[],[]),
Sector.new([0,1],[],["east"]),
Sector.new([1,0],[],[]),
Sector.new([1,1],[],["west"]),
#Genco, Floor 3
Sector.new([0,0],[],[]),
#Draco's Village
Sector.new([0,0],[],[]),
Sector.new([0,1],[],[]),
Sector.new([1,0],[],[]),
Sector.new([1,1],[],[]),
Sector.new([1,2],[],[]),
Sector.new([2,1],[],[]),
Sector.new([2,2],[],[])
#I'M DONE!
]
$sectors.each { |i| i.set_area() }
