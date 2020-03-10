import os
import shutil
import sys

empty_string = ""
space_string = " "
new_line_string = "\n"

is_debug = True
bin_path = "bin"
layout_path = "layout"
index_page = "index.html"

shader_data_path = "src/main/glsl/engine/graphics/rendering"
shader_token = "<!-- INSERT_SHADERS -->"
shader_template = "<script type=\"text/glsl\" id=\"<id_string>\">\n<data_string>\n</script>\n"

level_data_path = "data"
level_token = "<!-- INSERT_LEVELS -->"
level_template = "<div id=\"<id_string>\" data-string=\"<data_string>\"/>\n"

def get_bin_path(file):
  if bin_path == "":
    return file
  else:
    return bin_path + "/" + file

def embed_files_into_index_page(files_to_embed_path, replace_token, template, should_flatten_data):
  tags = empty_string
  for file_to_embed_name in os.listdir(files_to_embed_path):
    with open(files_to_embed_path + "/" + file_to_embed_name, "r") as file_to_embed:
      file_data = file_to_embed.read()
      if should_flatten_data:
        file_data = file_data.replace(" ", empty_string).replace(new_line_string, empty_string)
      tags += template.replace("<id_string>", file_to_embed_name.rstrip(".")).replace("<data_string>", file_data)

  with open(get_bin_path(index_page), "r") as file_index_read:
    index_data = file_index_read.read()
    with open(get_bin_path(index_page), "w") as file_index_write:
      file_index_write.write(index_data.replace(replace_token, tags))

def compile():
  command = "haxe -cp src/main/haxe -main game.Main"
  if is_debug:
    command += space_string + "-debug"
  command += space_string + "-js" + space_string + get_bin_path("glow.js")
  os.system(command)

def copy_layout():
  shutil.copyfile(layout_path + "/" + index_page, get_bin_path(index_page))

def build():
  compile()
  copy_layout()
  embed_files_into_index_page(shader_data_path, shader_token, shader_template, False)
  embed_files_into_index_page(level_data_path, level_token, level_template, True)

if len(sys.argv) == 1:
  build()
  sys.exit()

if sys.argv[1] == "debug":
  build()
  sys.exit()

if sys.argv[1] == "release":
  bin_path = empty_string
  is_debug = False
  build()
  sys.exit()