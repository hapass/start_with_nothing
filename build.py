import os
import shutil
import sys

empty_string = ""
space_string = " "
new_line_string = "\n"

is_debug = True
bin_path = "bin"
js_file_name = "glow.js"

layout_path = "layout"
layout_file_name = "index.html"

source_code_path = os.path.join("src", "main", "haxe")

shader_data_path = os.path.join("src", "main", "glsl", "engine", "graphics", "rendering")
shader_token = "INSERT_SHADERS"
shader_template = "<script type=\"text/glsl\" id=\"<id_string>\">\n<data_string>\n</script>\n"

js_hash_token = "INSERT_VERSION"

def embed_token_into_layout(replace_token, data_to_embed):
  with open(os.path.join(bin_path, layout_file_name), "r") as layout_file_read:
    file_data = layout_file_read.read()
    with open(os.path.join(bin_path, layout_file_name), "w") as layout_file_write:
      layout_file_write.write(file_data.replace(replace_token, data_to_embed))

def embed_files_into_layout(files_to_embed_path, replace_token, template):
  file_data_to_embed = empty_string
  for file_to_embed_name in os.listdir(files_to_embed_path):
    with open(os.path.join(files_to_embed_path, file_to_embed_name), "r") as file_to_embed:
      file_data = file_to_embed.read()
      file_data_to_embed += template.replace("<id_string>", file_to_embed_name).replace("<data_string>", file_data)
  embed_token_into_layout(replace_token, file_data_to_embed)

def embed_version_into_layout():
  md5_hash = os.popen("md5 " + os.path.join(bin_path, js_file_name)).read()
  js_file_hash = "?" + md5_hash.replace("MD5 (" + os.path.join(bin_path, js_file_name) + ") = ", empty_string).replace(new_line_string, empty_string)
  embed_token_into_layout(js_hash_token, js_file_hash)

def add_option(command, option, value):
  result = command + space_string + option
  if value != empty_string:
    result += space_string + value
  return result

def compile():
  command = add_option("haxe", "-cp", source_code_path)
  command = add_option(command, "-main", "game.Main")
  command = add_option(command, "-js", os.path.join(bin_path, js_file_name))

  if is_debug:
    command = add_option(command, "-debug", empty_string)

  command = add_option(command, "-dce", "full")
  os.system(command)

def copy_layout():
  shutil.copyfile(os.path.join(layout_path, layout_file_name), os.path.join(bin_path, layout_file_name))

def build():
  compile()
  copy_layout()
  embed_files_into_layout(shader_data_path, shader_token, shader_template)
  embed_version_into_layout()

if len(sys.argv) == 1 or sys.argv[1] == "debug":
  build()
  sys.exit()

if sys.argv[1] == "release":
  bin_path = empty_string
  is_debug = False
  build()
  sys.exit()