class Player
  attr_accessor(:coords,:inv,:inside,:thirst,:flags,:face)
  def initialize(coords)
    @coords = coords
    @inv = []
    @inside = false
    @thirst = 0
    @flags = [0]*23
    @face = 0
  end
end
