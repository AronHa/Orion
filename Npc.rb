class Npc
  attr_accessor(:name,:loc,:dialog)
  def initialize(name,loc,dialog)
    @name = name
    @loc = loc
    @dialog = dialog
  end
end

class Dialog
  attr_accessor(:question,:state,:nextstate,:condition,:text,:action,:active)

  def initialize(question,state,nextstate,condition,text,action)
    @question=question
    @state=state
    @nextstate=nextstate
    @condition=condition.split
    @text=text
    @action=action.split
    @active = true
  end
  def check
    con = @condition.clone
    array = []
    while con.length > 0
      if con[0] == "gf"
	if $player.flags[con[1].to_i] == con[2].to_i
	  array.push true
	else
	  array.push false
	end
	3.times {con.shift}
      elsif con[0] == "nf"
	if $player.flags[con[1].to_i] != con[2].to_i
	  array.push true
	else
	  array.push false
	end
	3.times {con.shift}
      elsif con[0] == "has"
	i_name = con[1..con.index("END")-1].join(" ")
	if $player.inv.find{ |a| a.name == i_name}
	  array.push true
	else
	  array.push false
	end
	while con.shift != "END"; end
      elsif con[0] == "nohas"
	i_name = con[1..con.index("END")-1].join(" ")
	if ! $player.inv.find{ |a| a.name == i_name}
	  array.push true
	else
	  array.push false
	end
	while con.shift != "END"; end
      elsif con[0] == "has_adj"
	if $player.inv.find{ |a| a.adj == con[1] }
	  array.push true
	else
	  array.push false
	end
        2.times {con.shift}
      elsif con[0] == "visited"
	if $areas[con[1].to_i].visited
	  array.push true
	else
	  array.push false
	end
	2.times {con.shift}
      elsif con[0] == "avoided"
	if $areas[con[1].to_i].visited
	  array.push false
	else
	  array.push true
	end
	2.times {con.shift}
      end
    end
    if array.include?(false)
      @active = false
    end
  end
  def change
    ac = @action.clone
    while ac.length > 0
      if ac[0] == "sf"
	$player.flags[ac[1].to_i] = ac[2].to_i
	3.times {ac.shift}
      elsif ac[0] == "give"
	i_name = ac[1..ac.index("END")-1].join(" ")
	$player.inv.push $items.find{ |a| a.name == i_name }
	while ac.shift != "END"; end
      elsif ac[0] == "take"
	i_name = ac[1..ac.index("END")-1].join(" ")
	$player.inv.delete $items.find{ |a| a.name == i_name }
	while ac.shift != "END"; end
      elsif ac[0] == "set_adj"
	$player.inv.find{ |a| a.adj == ac[1] }.adj = ac[2]
	3.times {ac.shift}
      elsif ac[0] == "unlock"
	$sectors[ac[1].to_i].walls.delete(ac[2])
	3.times{ac.shift}
      elsif ac[0] == "set_area"
        $sectors[ac[1].to_i].set_area(ac[2].to_i)
        3.times{ac.shift}
      elsif ac[0] == "cutscene"
        run_scene(ac[1].to_i)
      end
    end
  end
end

def talk(npc)
  npc = $people.find{ |a| a.name == npc }
  $talk = true
  say = nil
  $dialogs.each do |i|
    i.check
  end
  $dialogs.each do |i|
    if i.active && i.state == npc.dialog
      say = i
    end
  end
  while $talk
    $dialogs.each do |i|
      i.check
    end
    x = 67-npc.name.length
    print "\e[2J\e[H\e[40m."+(" "*(x/2))+"\e[97mTalking to #{npc.name}\e[30m"+(" "*(x/2.0).round)+".\e[m"
    output = say.text.clone
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
    num = 0
    opt = []
    $dialogs.each do |i|
      if i.state == say.nextstate && i.active
	puts "#{num+=1}) #{i.question}\n"
	opt.push i
      end
    end
    if say.nextstate == -1
      puts "#{1}) OK\n"
    end
    print "\e[24H> "
    act = gets.chomp.to_i
    if say.nextstate == -1 && act == 1
      $talk = false
      say.change
      $dialogs.each { |i| i.active = true }
    elsif act > 0 && act <= num && say.nextstate != -1
      say.change
      say = opt[act-1]
      opt = []
      if say.state != say.nextstate
	$dialogs.each { |i| i.active = true }
      end
      say.active = false
    end
  end
  $w_per = -1
end

$people = [
#       "Name",["Place_name",x,y],starting_state
Npc.new("Orion",["Village",0,1],1),
Npc.new("Draco",["Shrine",0,2],11),
Npc.new("Sagitta",["Walkway",0,3],21),
Npc.new("Pictor",["Tower Floor 3",0,0],31),
Npc.new("Scorpio",["Scorpio's Tower, Floor 2",0,0],41)
]

$dialogs = [
Dialog.new("Ok",0,-1,"","",""),
#Orion
Dialog.new("",1,2,"gf 0 0 gf 18 0","A visitor to my village? This really is a surprise. Well, welcome. I know you have many questions for me, so ask away. Once you are done asking me questions, I have a request for you.","sf 0 1"),
Dialog.new("",1,2,"gf 0 1 gf 18 0","Hello again. What is it now?",""),
Dialog.new("Who are you?",2,2,"","My name is Orion. I was once a wizard of great power, but master has cast me out and stripped me of the majority of my abilities. I won't bore you with all of backstory right now, though. At some point it may become necessary for you to know more about me, but for now all you need to know is that I am a friend.",""),
Dialog.new("What is that pig?",2,2,"","His name is Morath. He is my familiar, one of the few things that I was able to keep when I was lost my abilities. He is completely obedient to me, and can do a wide variety of tasks. He can fetch things for me, hunt food for me, and many other things. But there are some things he can't do, and that is why I would like your help.",""),
Dialog.new("You said you had a request for me?",2,3,"gf 1 0","Yes I do. You see, I am rather limited here - I can't leave this village without some unpleasant consequences. So I would like for you to be my eyes on this island. Will you do this for me?",""),
Dialog.new("I have been to Quaro for you. (Describe the city)",2,4,"visited 21 gf 1 1","I'm glad that you got to Quaro and back safely. That tells me a lot about the current state of the island. Tell me, is there anything in particular you would like to ask me about Quaro.","sf 1 2"),
Dialog.new("What else would you like me to do?",2,2,"gf 1 2","Your visit to Quaro was very informative. You brought back so much useful information with you. And yet, I need more information. Visit the city of Seta, particularly the arch, and then report back to me. Here, you're going to need this stone to get through the cave between Quaro and Seta.","sf 1 3 give glowing stone END"),
Dialog.new("Now that I am going farther out for you, could make travel quicker?",2,2,"gf 1 3 gf 2 0","Yes, certainly. Here, take this sapphire. If the rub that gemstone it will teleport you back to this very spot. Also, if you stand beneath an arch and say the name of a city you have been to before, you will teleport to that city.","sf 2 1 give sapphire END"),
Dialog.new("I have been to Seta for you. (Describe the city)",2,2,"visited 83 gf 1 3","This is most opportune. My old master must be afraid to act in case I interfere. Now that I know this, I have the advantage over him. From now on, I will not force you to do anything else for me, but I think we can mutually help each other. If you help me with the plan I have, I can help you escape this island. Isn't that what you're looking for, a way off? Come talk to me if you're interested.","sf 1 4"),
Dialog.new("I am interested in helping you. What are you planning?",2,2,"gf 1 4 gf 3 0","I thought we could help each other. My old master is hiding in his tower because he thinks I might interfere with his plans. But unfortunately, I'm stuck here because he might interfere with my plans. We are at an impasse. Eventually, I will need you to break that impasse for me, but in order to do that, I first need you to reach Arepo and confirm that it is empty like the other two cities. Go to Arepo and report back to me.","sf 1 5 sf 3 1"),
Dialog.new("I met a strange man in Seta. His name was Draco. Do you know him?",2,2,"visited 92 nf 3 0","Oh yes, I know Draco. He is a very dangerous man. I would advise you to stay away from him, but I get the feeling that he could be helpful to you. Just keep an eye on him in your dealings.",""),
Dialog.new("Since I'm helping you, I would like to know more about you.",2,2,"nf 3 0","My story? Well, I came here because I was apprenticed to Scorpio, another wizard who on this island. We were working together on a project. The two of us made this island what it is; we built the cities, we constructed the arches. But when I noticed a flaw in his plan, he disagreed. He prefered to think the plan would work anyway, and he cut me off from him because of my impertinence. My goal is simple: take over the plan from him, as he will never succeed anyway. But I can make it all work perfectly, and you could be at my side for my victory! So I need you to continue your task for me, now!",""),
Dialog.new("I have been to Arepo. (Describe the city)",2,2,"gf 1 5 visited 117","Excellent. It seems I was correct - my old master fears what I may do. Then you should have enough time to get to him. Here, take this dagger. Scorpio will probably be hiding in Muu Shasa, the furthest city from here. Your next mission is simple. Kill Scorpio. I have the materials gathered to scry on you, I shall join you as soon as you have done the deed.","sf 1 6 give enchanted dagger END"),
Dialog.new("I met a man named Sagitta in Arepo. He's very close to being dead.",2,2,"visited 131 nf 3 0","An assassin. Sent by my old master, Scorpio. It is a good thing that he is dying. I must have gotten lucky that our mutual enemies got to him before he got to me. Put him out of your mind; he is unimportant.",""),
Dialog.new("It is done. Scorpio is dead.",2,2,"gf 22 1 nf 12 4","Then that's it. My master's plan for this island was a good one, but incomplete. Now, I can succeed where he surely would have failed. But not here. Meet me by the arch in Muu Shasa, and bring that quartzite piece that Scorpio had on him.","sf 1 7 sf 18 1 set_area 46 222 set_area 181 231"),
Dialog.new("Draco wants revenge. He shall have it. (Reveal the glass orb)",2,-1,"has glass orb END","Orion immediately starts to cast a spell, but the moment you bring the orb out of your pack, the words die in his throat. He is uncapable of casting any more spells. The pig, Morath, rushes you, in an attempt to defend his master, but it disintegrates into a pile of green dust at your feet. Meanwhile, Orion's body also crumbles into dust. One of the two wizard scourges is dead.","sf 18 1 set_area 46 220"),
Dialog.new("Pictor has deemed you to be a threat. Your life is forfeit. (Stab Orion with Katana)",2,-1,"gf 9 2 has dark katana END","Orion immediately starts to cast a spell, but you are too fast for him. It's almost as if the katana has a life of its own, dragging your hand toward the victim. The pig, Morath, tries to defend his  master, but another flick of the katana finishes him off as well. The wizard Orion is dead.","sf 18 1 set_area 46 221"),
Dialog.new("I'm tired of working for you. (Stab Orion with Dagger)",2,-1,"has enchanted dagger END","As you stab at Orion, he does not make a move to avoid the blow. And when you make contact with the dagger you realize why: Orion must have magically protected himself from this dagger, because it was utterly ineffective. Of course, you have little time to reflect on this as Orion slays you with his magic a couple seconds little.","cutscene 0"),
Dialog.new("Thanks for your time.",2,-1,"","You're welcome.",""),
Dialog.new("I would be glad to help you.",3,2,"","Excellent. Your first task is to reach the city of Quaro. To help you to that end, I previously set up some lights in the cave off the beach, and I have turned them on for you. Once you have reached the center of Quaro, come back and report to me.","sf 1 1"),
Dialog.new("I'm sorry, but I'm rather busy right now.",3,2,"","I'm very disappointed to here that. But I think you should know that you won't get very far on this island without my help.",""),
Dialog.new("I was curious why the entire city was made of granite.",4,4,"","Ah, of course. The architect who designed the city felt that granite was an appropriate stone for the city. As you go further on the island, you will find all the cities have been constructed out of one type of stone. It's just the way it is.",""),
Dialog.new("Why was the city empty? Doesn't anyone live there?",4,4,"","The city is empty because no one knows of its existance yet. My old master and I had plans to bring some people in, but since our split neither of us has the ability to anymore.",""),
Dialog.new("What was the giant arch in the middle of the city?",4,4,"","The arch is very important to the events on this island. At this time, I can't tell you what it's true purpose is. I can tell you there is one arch in every city, and all of them are missing a small piece near the base. Be on the lookout for these pieces as you travel.",""),
Dialog.new("Why were there treehouses? They looked pretty run down compared to the city.",4,4,"visited 33","They are horrible compared to the city. They were meant to be that way. The treehouses are supposed to be dwellings for the slaves of Quaro. Not a bad place to hide, though - I spent a while there after I was banished by my master.",""),
Dialog.new("I think that's everything.",4,2,"","Very well, then. I do have another request of you, if you can find the time.",""),
#Orion, Muu Shasa
Dialog.new("",1,0,"gf 18 1 gf 1 7 nohas quartzite piece END","It's nice to see you, but without that quartzite piece, I'm afraid there is little I can do here.",""),
Dialog.new("",1,0,"gf 18 1 gf 1 7 has quartzite piece END","It's nice to see you. And you have the quartzite piece, right? Good, then it's finally time to begin...","cutscene 7"),
Dialog.new("",1,0,"gf 18 1 gf 1 7 gf 16 1","It's nice to see you. And since you seem to have already replaced the quartzite piece, it's finally time to begin...","cutscene 8"),
#Draco
Dialog.new("",11,12,"gf 4 0 gf 19 0","Greetings. New people do not just show up here. There must be something special about you. Please, chat with me for a while.","sf 4 1"),
Dialog.new("",11,12,"gf 4 1 gf 19 0","Greetings. Please, chat with me for a while.",""),
Dialog.new("Who are you?",12,13,"","I am a native of this island. Once, there were many of my people, living in villages spread across the whole island. Then, two sorcerers invaded, and they slaughtered all of my people. I am the last of my kind. All I want is for everybody to leave my island alone.",""),
Dialog.new("I'm stranded on this island. Can you help me escape?",12,12,"gf 5 0","I have no means of leaving this island, but perhaps there is a boat of some kind in the next city. There is a great desert between this city and the next, but I could cast a blessing on water that would make it quench ten times the thirst.","sf 5 1"),
Dialog.new("Bless my water.",12,12,"gf 5 1 has_adj water","Naro! Kemi! Hredar! You water will now completely sate even the most thirsty person.","set_adj water potion"),
Dialog.new("I found your missing amulet.",12,12,"gf 6 1 has amulet END","You got it! This will definitely help me escape detection by those wizards. No rest for the weary, though. I heard that another assassin has been sent after me. I need you to make sure he never harms me, and do it quickly, I implore you!","sf 6 2 take amulet END"),
Dialog.new("I located that assassin. He will not harm you.",12,12,"gf 6 2 visited 131","Thank you. I will not even ask what you had to do to keep me safe. I am just glad that it is taken care of. Now the real work can begin. Take this orb. I have placed multiple blessings upon it. If you bring it close enough to either of the wizards, the power of it will destroy them. Seek out both those wizards, and slay them for my revenge!","sf 6 3 give glass orb END"),
Dialog.new("I slew the wizards. I have avenged your people.",12,12,"gf 6 3 gf 18 1 nf 1 7 gf 22 1 nf 12 4","They are dead?! Truly?! Then this is a day that will always be celebrated! I suppose I should tell you now. I lied to you. There are more of my people than just me. They are in a hidden village behind the door locked behind me. I will unlock the door so you can look around if you wish. However, these people are the reason for the last mission I require of you. Meet me by the quartzite arch in Muu Shasa. Only there can the final goal be achieved, and then I can send you back where you came from. I promise, this is the end.","sf 6 4 sf 19 1 unlock 92 east set_area 92 224 set_area 181 232"),
Dialog.new("I have come to kill you. (Stab Draco with Dagger).",12,-1,"has enchanted dagger END","You stab at Draco. You expected him to defend himself in some way, but your attack took him completely by surprise. You extract your dagger from his chest and clean the blood off it. Shaman Draco is dead.","sf 19 1 set_area 92 223"),
Dialog.new("Pictor needs your death (Stab Draco with Katana).",12,-1,"gf 9 6 has dark katana END","This time the katana does not even wait for you to be ready. It pulls out of your hand and flies straight at Draco. The blade buries itself in in his chest. You consider leaving the katana there, but it returns to you hand just as fast as it left. Shaman Draco is dead.","sf 19 1 set_area 92 223"),
Dialog.new("Farewell, Draco.",12,-1,"","Good bye. I hope that we meet again someday.",""),
Dialog.new("I'm sure that the wizards must have had a good reason.",13,-1,"","Really? A good reason?! For genocide?! Leave me. Leave me now. I must meditate before rage overtakes me.",""),
Dialog.new("It sounds like you have been horribly mistreated.",13,12,"","Horribly mistreated is an understatement. It was a massacre, a bloodbath. But I shall make sure that it never happens again....",""),
Dialog.new("You deserve justice for this abomination! How can I help you?",13,12,"gf 6 0","Do you mean it? You wish to aid me in my revenge? I suppose you can start by retrieving my amulet. I lost it in a fight with an assassin sent by those two butchers to kill me. As I recall, when I killed him, he fell down a cliff, somewhere west of here.","sf 6 1"),
#Draco, Muu Shasa
Dialog.new("",11,0,"gf 19 1 gf 6 4","Very good, you made it. You should see the next step that I am going to take. I need to do just this one last thing before I will let you leave this island...","cutscene 12"),
#Sagitta
Dialog.new("",21,-1,"visited 57","Away! Get away! I'm dying, but you stay away from me. You have a curse on you, and I don't want anything unnatural happening to me after I depart. Away!",""),
Dialog.new("",21,22,"gf 7 0 avoided 57","I'm dying, and still someone wants to speak with me. Even becoming an assassin couldn't stop people from trying to talk. It must be my curse to bear. Well, what is it? Hurry up, I'm not long for this world.","sf 7 1"),
Dialog.new("",21,22,"gf 7 1 avoided 57","I'm dying. Hurry up and tell me what's so important while I can still listen.",""),
Dialog.new("Why are you dying? Can I help?",22,22,"","It's nice of you to offer me aid, but nothing can help me now. I accidently stepped on a rune, a trap set by a certain shaman. Wait, you can help me: my master lives at the top of the tower just to the north. Go see him, he might want to see you.","unlock 126 up"),
Dialog.new("Is there no way to heal you?",22,22,"","No. There's too much damage. That shaman may not be as civilized as the wizards on this island, but his magic is just as potent. The only reason I'm still alive is the rune was designed to kill wizards, so it's taking longer on me as a non-magician.",""),
Dialog.new("Who were you sent to kill?",22,22,"","Don't you know? I was hired because I have some experience dealing with magic casters. I just wasn't expecting this trap, and now it doesn't matter who my target was.",""),
Dialog.new("That's all for now.",22,-1,"","For you that's all for now. For me, that's probably all forever.",""),
#Pictor
Dialog.new("",31,32,"gf 8 0","A visitor on the island? This is exciting news indeed. Welcome to my humble dwelling. Please, have a seat and talk to me. I am very interested to discuss how we could help each other.","sf 8 1 sf 20 1 set_area 131 226"),
Dialog.new("",31,32,"gf 8 1","Welcome to my humble dwelling. Please, have a seat and talk to me.",""),
Dialog.new("Who are you?",32,32,"","Name's Pictor. I was head of an assassin's guild. Now I'm all alone, painting. Anything else you want to know?",""),
Dialog.new("Why are you painting these portraits?",32,32,"","It's personal. Keep your nose out of my business. That kind of behavior irritates me, and people who irritate me end up dead. That clear?",""),
Dialog.new("I met Sagitta down on the walkway.",32,32,"","Sagitta. The Last Assassin. Bit of an egotist, but not bad overall. I was saddened when I saw he failed his mission. Now I need someone else to do it.",""),
Dialog.new("Why did Sagitta think you wanted to see me.",32,33,"gf 9 0","Because he was dying. He knew I needed a replacement for him. That replacement is you, if you will accept. So will you do it, be my next assassin?",""),
Dialog.new("Who is my first target as an assassin?",32,32,"gf 9 1","I would like you to kill the wizard Orion first. He is currently the biggest threat to me. My sources tell me he's on the southern end of the island.","sf 9 2"),
Dialog.new("Orion is dead, and his little pig too.",32,32,"gf 18 1 nf 1 7 gf 9 2","With Orion gone, I am now much safer. But I still have enemies. I have another target for you, if you're interested.","sf 9 3"),
Dialog.new("Who else do you want me to kill?",32,32,"gf 9 3","I need you to kill another wizard, Scorpio. Scorpio is now a bigger threat, since he doesn't have to worry about Orion anymore. According to my sources, Scorpio is hiding in his tower to the west.","sf 9 4"),
Dialog.new("Scorpio is no longer a threat.",32,32,"gf 22 1 nf 12 4 gf 9 4","Both wizards are now dead? I thought this day would never come. I have just one last target for you.","sf 9 5"),
Dialog.new("Who is my last target?",32,32,"gf 9 5","There is a shaman, one of the natives of the island. With the wizards gone he may try to retake this island, which could be dangerous to me. I need you to find his shrine and kill him.","sf 9 6"),
Dialog.new("I killed Draco for you.",32,32,"gf 9 6 gf 19 1 nf 6 4","Then that is all you can do for me. There is still a small town of natives on the island, but I can take care of them. I don't plan to let anyone stay alive on this island. But, as I promised you, I will give you a way off the island. I will leave a boat at the docks in Arepo. I had better get started taking out those natives. I hope to never see you again.","sf 9 7 sf 21 1 set_area 122 230"),
Dialog.new("I don't think Orion wants you around. (Stab Pictor with Dagger)",32,-1,"has enchanted dagger END","Pictor grabs a black katana from seemingly nowhere. You grab his hand before he can swing at you, and you thrust the dagger into his stomach. All of the life drains out of Pictor, and he crumples into a heap on the floor. Pictor is dead.","sf 21 1 set_area 127 225"),
Dialog.new("I'm tired of working for you. (Stab Pictor with Katana)",32,-1,"has dark katana END","When you pull out the katana to stab Pictor, you can tell something is not right. The sword refuses to point itself at him. With horror, you realize that the end is slowly but steadily moving to point toward yourself. And try as you might, you cannot stop it from stabbing through your heart, killing you.","cutscene 0"),
Dialog.new("I don't need anything else.",32,-1,"","I look forward to our next meeting.",""),
Dialog.new("Yes. I will honor Sagitta's death.",33,32,"","You are brave to agree to help me. As an honorary assassin you will need an assassin's katana. It's my last one, so try not to lose it.","sf 9 1 give dark katana END"),
Dialog.new("I don't think I could take his place.",33,32,"","Well, I guess it's only natural to feel overwhelmed by the idea of taking a life. Even if it's for the greater good.",""),
#Scorpio
Dialog.new("",41,42,"gf 10 0 gf 22 0","Welcome to my tower. It's pretty grand if I must say so myself. You should take a look around this place if you haven't yet. Ah, but I'm being a bad host. What can I help you with?","sf 10 1"),
Dialog.new("",41,42,"gf 10 1 gf 22 0","It's good to see you again. How may I help you now?",""),
Dialog.new("Can you help me get off this island?",42,42,"gf 12 -1","I could have. But you have shown yourself to be completely untrustworthy. No, I will not help you. Not now, not ever.",""),
Dialog.new("Can you help me get off this island?",42,42,"gf 12 0","I could. But I won't. At least, not yet. If you want to get something, you have to give something. Tit for tat, as they say.",""),
Dialog.new("Can you help me get off this island?",42,42,"gf 12 1","I could. But I won't. At least, not yet. If you want to get something, you have to give something. Tit for tat, as they say.",""),
Dialog.new("Can you help me get off this island?",42,42,"gf 12 2","Yes I can. And I will help you just as soon as you are done helping me. But unitl then, I won't do anything for you.",""),
Dialog.new("Can you help me get off this island?",42,42,"gf 12 3","Yes I can. And I will help you just as soon as you are done helping me. But unitl then, I won't do anything for you.",""),
Dialog.new("What is your connection to Orion?",42,42,"gf 11 0","Orion is... was my apprentice. You see, I'm a powerful wizard, and I agreed to teach him. But he eventually showed his true ambitions. He wanted my power for himself. We shall talk of him no furthur.","sf 11 1"),
Dialog.new("I'm sure I could get close enough to Orion to kill him, if you like.",42,42,"gf 11 1","Kill him? If I had my way, he would be alive to see my Great Triumph. He would live to be completely humiliated at his defeat by my hand. But I recognize that he is a danger to me. I leave his fate in your hands. Do with him as you will.","sf 11 2"),
Dialog.new("Is there anything I could do to help you?",42,43,"gf 12 0","Well, yes and no. There is something you could do for me. But I don't trust you enough. If you were to prove your loyalty to me, I might consider letting you help me.",""),
Dialog.new("How may I help you?",42,42,"gf 12 2","I have this plan. A plan to take over my world. This plan hinges on those arches you undoubtedly saw on your journey. Unfortunately, those arches are missing a small piece near the base. I can't replace them, because Orion has put a curse on me so I can never leave this tower. But I trust you to do it for me. Here's one of the pieces you will need.","sf 12 3 give quartzite piece END"),
Dialog.new("I've done it. I fixed all the arches.",42,42,"gf 12 3 gf 13 1 gf 14 1 gf 15 1 gf 16 1","Well done. Truly excellent. I appreciate all of your immense help. Meet me in front of the arch in Muu Shasa to witness my Great Triumph, and then I shall allow you to leave this island. In addition, I shall reward you greatly for this. Again, thank you for your help.","sf 12 4 sf 22 1 set_area 204 229 sef_area 181 233"), #Flags 13-16 are arch flags
Dialog.new("I retrieved your letter (give envelope).",42,42,"gf 12 1 has envelope END","","sf 12 2 take envelope END"),
Dialog.new("I retrieved your letter (give letter).",42,-1,"gf 12 1 has letter END","Would you care to tell me why you opened it? I clearly cannot trust you. Please, leave me.","sf 12 -1 take letter END"),
Dialog.new("I don't think I need anything else.",42,-1,"","Well, then I hope to see you again soon. Your visits are the highlight of my day here.",""),
Dialog.new("Orion has sent me to kill you (Stab Scorpio with Dagger).",42,-1,"has enchanted dagger END","Scorpio leaps out of your reach as soon as he sees the dagger. He starts to cast a spell, and out of desperation you throw the knife at him. Scorpio tries to avoid the dagger, but it manages to slice his side. As if by magic, all of the life goes out of Scorpio, and he collapses to the floor. You retrieve the dagger. The wizard Scorpio is dead. You find a quartzite piece on his body.","sf 22 1 give quartzite piece END set_area 204 227"),
Dialog.new("Pictor feels threatened by you (Stab Scorpio with Katana).",42,-1,"gf 9 4 has dark katana END","Scorpio's attempt at a spell is not quick enough to stop the blade. This time you definitely feel the katana pulling your hand along as it moves to embed itself in Scorpio's chest. He slumps to the ground. The wizard Scorpio is dead. You find a quartzite piece on his body.","sf 22 1 give quartzite piece END set_area 204 227"),
Dialog.new("Draco wants revenge. He shall have it. (Reveal the glass orb)",42,-1,"has glass orb END","Scorpio tries to cast a spell, but as soon as you bring the orb out of your pack, the words die in his throat. He is uncapable of casting any more spells. In desperation, the mute wizard throws himself at you, but Scorpio's body crumbles into dust before it reaches you. One of the two wizard scourges is dead. You find a quartzite piece on his body.","sf 22 1 give quartzite piece END set_area 204 228"),
Dialog.new("How can I prove myself to you?",43,42,"","An excellent question. One of my friends sent me a letter recently, but I never received it. Should you find and return it for me, without reading it, that would be a sign that I could trust you.","sf 12 1"),
Dialog.new("That's too bad.",43,42,"","Yes. Too bad, indeed. Well, I guess I have no choice but to wait for someone trustworthy to come along. Someone who won't hesitate to prove their loyalty. I wish a person like that would appear on my island.",""),
#Scorpio, Muu Shasa
Dialog.new("",41,0,"gf 22 1","Welcome to the beginnig of my Great Triumph. I want you to know, none of this would have been possible without you. Now then, let the summoning begin...","cutscene 20")
]
