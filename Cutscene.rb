class Cutscene
  attr_accessor(:text,:nextscene)
  def initialize(text,nextscene)
    @text = text
    @nextscene = nextscene
  end
end

def run_scene(scene_num)
  print "\e[2J\e[H\e[40m."+(" "*35)+"\e[97mCutscene\e[30m"+(" "*35)+".\e[m\e[2H"
  output = $cutscenes[scene_num].text.clone
  array = []
  x = 80
  while output.length > 80
    if output[x].chr == " "
      array.push output[0..x-1]
      output[0..x] = ""
      output.gsub!(/$\s/,"")
      x = 80
    else
      x-=1
    end
  end
  output.gsub!(/$\s/,"")
  array.push output if output.length > 0
  array.push ""
  print array.join("\n")
  if $cutscenes[scene_num].nextscene == -1
    puts "#{1}) Exit\n"
  else
    puts "#{1}) Continue\n"
  end
  print "\e[24H> "
  gets
  if $cutscenes[scene_num].nextscene == -1
    exit
  else
    run_scene($cutscenes[scene_num].nextscene)
  end
end

$cutscenes = [
Cutscene.new("It appears you have died. You could have been an integral part of the politics being played out on the island, but instead you made a few poor decisions. Without your intervention, many different groups try to take possession of the island from each other by force. In the end, they come to an uneasy agreement to all leave the place forever, but it is a pact paid for with many decades of fighting and bloodshed. If only you had been alive to find a better solution..."+("\n"+" "*36+"\e[1m"+"The End"+"\e[0m"),-1),
Cutscene.new("You look down at the remains of your final victim. A feeling of intense pride and elation overcomes you. You did it. When put on an island of freaks, you found a way to beat the system they tried to hold over you. But this feeling fades, replaced by one of utter despair. Everyone on this island is dead, and any chance you might have had of ever escaping dies with them.",4),
Cutscene.new("You killed the shaman Draco. At the time, you did not feel anything special about it, but eventually you realize the mistake you made. Though you search for days and days, you cannot find a way either around or through the desert to get to the northern half of the island. You would ask Orion for a magical solution, but that is no longer an option.",5),
Cutscene.new("You killed the shaman Draco. At the time, you did not feel anything special about it, but eventually you realize the mistake you made. Though you search for days and days, you cannot find a way either around or through the desert to get to the northern half of the island. You go to Orion to ask for a magical solution, but he refuses to give you anything. He blames you for squandering the precious natural resources given to you.",5),
Cutscene.new("You establish a home for yourself in one of the cities, and spend most of your time scavenging the surrounding areas for food. What little time you have left over is spent building a raft to someday leave the island. It is a misserable existance. You almost get your raft completed, when it catches on fire during the night. If the island was not deserted, you would suspect someone had purposefully set it on fire. Then, the impossible happens.",6),
Cutscene.new("You establish a home for yourself in one of the cities, and spend most of your time scavenging the surrounding areas for food. What little time you have left over is spent building a raft to someday leave the island. It is a misserable existance. You almost get your raft completed, when it catches on fire during the night. You would suspect someone had purposefully set it on fire. Then, the impossible happens.",6),
Cutscene.new("One night, working on a new raft, you see a light out on the sea. As luck would have it, a boat comes to the beach where you are working. A dozen burly men disembark from the craft. When they see you, they pull out swords. Not nowing who you are, they assume you to be one of the island natives that have been causing problems for their mission. You try to run, but they are much faster than you, and easily catch you. At least they make your death quick and painless..."+("\n"+" "*36+"\e[1m"+"The End"+"\e[0m"),-1),
Cutscene.new("Orion takes the quartzite piece from you and sets it into place in the arch. Satisfied that the arch is whole, he begins to chant. Even without him telling you what he is doing, you can tell the power in his words; he is casting a spell. The chanting goes on for what must be hours until he finally finishes his spell. You notice two changes: first, Orion now has a crown of gold you have never seen before, and second, the arch is now filled with a fiery red shimmering.",9),
Cutscene.new("Orion double checks that you have repaired the arch properly. Satisfied that the arch is whole, he begins to chant. Even without him telling you what he is doing, you can tell the power in his words; he is casting a spell. The chanting goes on for what must be hours until he finally finishes his spell. You notice two changes: first, Orion now has a crown of gold you have never seen before, and second, the arch is now filled with a fiery red shimmering.",9),
Cutscene.new("Orion turned the arch into a portal. The two of you back up as creatures come through the newly created portal. A host of beings, half human and half animal, come before Orion and bow before him. Orion begins to explain the whole truth. Scorpio and Orion were sent here to raise an army with which to conquer the world, but Scorpio's plan failed to include a way to control the beasts they planned to summon. But in the end, it turns out Orion was right.",10),
Cutscene.new("Orion then turns to you, and offers you a place at his side, second only to him. You think of returning to your home, but then realize that Orion will conquer even that place. So you accept his offer. The road is not an easy one. And during one fateful battle, Orion falls at the hands of an enemy ruler. Without thinking, you put Orion's crown on your head, and proceed to rally the troops to victory. And then another, and another. Even though Orion did not make it, his legacy lives on in you, as you become the first Emperor of the world.",11),
Cutscene.new("You are the Emperor. You have everything you could ever have dreamed or wished. And yet, you are not happy. Your life is an endless string of difficult decisions and fear. All of the security in the world cannot keep you safe, and there are many times when assassins come within an inch of your life. The stress of being Emperor is taking a toll you. But, then again, you are the Emperor. It could be much worse. You made a decision who to trust, and that choice paid off..."+("\n"+" "*36+"\e[1m"+"The End"+"\e[0m"),-1),
Cutscene.new("Draco puts his hand into a pocket of his robe and pulls out a diamond just the size of the piece missing on the arch--he must have been planning this for a while. Once the diamond is put in the arch, Draco stands back and begins to chant. Even without his telling you what he is doing, you can tell the power in his words; he is casting a spell. The chanting goes on for what must be hours until he finally finishes his spell. A darkness forms inside of the arch, and then coalesces at the base.",13),
Cutscene.new("Before long, the shadows have taken on the form of a giant, black bear. Draco begins to explain the whole truth. Scorpio and Orion were on the island to turn it into a base of operations for a war they wanted to start. The arches were a way for them to summon an army for this war. Of course, the natives had to be gotten out of the way. At first, they kept them in the treehouses above Quaro, but eventually the wizards thought it better to just kill them all.",14),
Cutscene.new("Even though you killed the wizards, there are still risks to the island. The shadow bear will protect the island and the last village of natives, at least until there are enough of them to take back the island for themselves. Draco then turns to you, and thanks you for the help you gave him. Without you, his people would never have had security again. They were a tribe about to become extinct, and you saved them from that. And in return for that service, Draco begins another chant, and once he finishes, the portal shows you a familiar scene: home.",15),
Cutscene.new("In the years to come, you begin to search for the island that you were trapped on. One day, you make your way back to the place you were once trapped. The natives took back the island, and made the place almost unrecognizable. When they discover that you have returned to them, they host a celebration for you. No matter what else you go through in life, you always hold that single spark of perpetual happiness: you saved these people. You die with the knowledge that you did the right thing on the island. You made a decision who to trust, and that choice paid off..."+("\n"+" "*36+"\e[1m"+"The End"+"\e[0m"),-1),
Cutscene.new("You pilot the boat away from the docks and out into the sea. You wish Pictor had included some maps on the boat, but instead he just left you with a compass. The best you can hope for is to travel in a straight line and hope to find land. As you look back, you see a large explosion on the western coast, a little ways south of where you set out from. You consider piloting your boat back to check it out, but you think better of it.",17),
Cutscene.new("Using the little knowledge you have, you are able to paint a crude picture of what was going on on the island. Pictor was not a native, so obviously he came to the island with Scorpio and Orion. His job must have been to kill all of the natives. He had a falling out with his masters, which prompted him to send you to assassinate them. But, loyal to the end, he completed his mission to eliminate the natives. The explosion you saw was likely Pictor taking out the last village to people, and simultaneously committing suicide, thus leaving the island completely devoid of human life.",18),
Cutscene.new("Only two days out on your sea voyage, you come to land. You walk for another few hours before you can find a town. It turns out, you are not far from your home. Two days later, you find yourself back at your house, the place you have been dreaming of since arriving on the island mysteriously. Your old life, however, cannot match up to the adventures you had on the island. Eventually, you leave all of your old life behind, take up your dark katana, and head out to make a name for yourself",19),
Cutscene.new("In your travels, you meet all sorts of people, and end up killing many of them. You never look back at your old life. Most people hate you, but long after you are dead, the stories of your exploits continue, first as rumor, then as legend, and finally as myth. The island gave you the skills, the equipment, and the mindset for your new life, and you are perfectly happy with it. You mad a decision who to trust, and that choice paid off..."+("\n"+" "*36+"\e[1m"+"The End"+"\e[0m"),-1),
Cutscene.new("Scorpio turns toward the arch, then pauses and pulls two rings out of a pocket in his robe. One ring he fits on his own finger, and the other he tosses to you to do likewise. He turns back to the arch and begins to chant. Even without him telling you what he is doing, you can tell the power in his words; he is casting a spell. The chanting goes on for what must be hours until he finally finishes his spell. The arch is now filled with a fiery red shimmering.",21),
Cutscene.new("Scorpio turned the arch into a portal. The two of you back up as creatures come through the newly created portal. A host of beings, half human and half animal, come before Scorpio and kneel to kiss his ring. Scorpio begins to explain the whole truth. Scorpio and Orion were sent here to raise an army with which to conquer the world. However, Orion did not believe that the enchantment on the rings would be enough to control the beasts they planned to summon, so he left. But in the end, it turns out Scorpio was right.",22),
Cutscene.new("Scorpio then turns to you, and offers you a place at his side, second only to him. You think of returning to your home, but then realize that Scorpio will conquer even that place. So you accept his offer. The road is not an easy one. There are many battles, and during the war both you and Scorpio come within an inch of death multiple times. You also save each other's lives over and over again. And in the end you both make it. Scorpio becomes as the first Emperor of the world, and you are his Royal Advisor.",23),
Cutscene.new("You are the Royal Advisor to the Emperor. As the second most powerful man to ever have lived, you have everything you could ever have wanted. Everything short of being Emperor, of course. But, then again, when you think about all of the responsibility that falls on the head of the Emperor, all of the stress and anxiety that Scorpio is under, you decide that you do not really need that. After all, you have everything else. You made a decision who to trust, and that choice paid off..."+("\n"+" "*36+"\e[1m"+"The End"+"\e[0m"),-1)
]
