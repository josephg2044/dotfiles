import os

path = "/home/joseph/git/colorer-colorschemes/"

for filename in os.listdir(path):
    color_string = '{"special":{"background":"#0c0d0e","foreground":"#b7b8b9","cursor":"#b7b8b9"},"colors":{"color0":"#0c0d0e","color1":"#F84841","color2":"#31a354","color3":"#ff7133","color4":"#1793D1","color5":"#955ae7","color6":"#4bb1a7","color7":"#b7b8b9","color8":"#737475","color9":"#F84841","color10":"#31a354","color11":"#ff7133","color12":"#1793D1","color13":"#955ae7","color14":"#4bb1a7","color15":"#fcfdfe"}}'

    with open(os.path.join(path, filename), 'r') as r:
        lines = r.readlines()

        i = 0
        for line in lines:
            col = line[line.index("#"):line.index("#") + 7]
            i = color_string.index("#", i + 1)

            color_string = color_string[:i] + col + color_string[i + 7:]
            if i == 49:
                i = color_string.index("#", i + 1)
                color_string = color_string[:i] + col + color_string[i + 7:]

        print(color_string)

    w = open(filename + ".json", "w")
    w.write(color_string)

            
w.close()
r.close()
    
