$maze = [
"little maze of twisting passages",
"little maze of twisty passages",
"little twisty maze of passages",
"little twisting maze of passages",
"maze of little twisting passages",
"maze of little twisty passages",
"maze of twisting little passages",
"maze of twisty little passages",
"twisting little maze of passages",
"twisting maze of little passages",
"twisty little maze of passages",
"twisty maze of little passages"
]

def create_maze(desc)
  return desc.gsub(/MAZE/){ |a| $maze[rand($maze.length)]+", all different" }
end
