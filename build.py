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

js_hash_token = "INSERT_VERSION"

def embed_token_into_layout(replace_token, data_to_embed):
  with open(os.path.join(bin_path, layout_file_name), "r") as layout_file_read:
    file_data = layout_file_read.read()
    with open(os.path.join(bin_path, layout_file_name), "w") as layout_file_write:
      layout_file_write.write(file_data.replace(replace_token, data_to_embed))

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
  command = add_option(command, "-resource", os.path.join(shader_data_path, "FragmentShader.glsl") + "@FragmentShader.glsl")
  command = add_option(command, "-resource", os.path.join(shader_data_path, "VertexShader.glsl") + "@VertexShader.glsl")

  if is_debug:
    command = add_option(command, "-debug", empty_string)

  command = add_option(command, "-dce", "full")
  os.system(command)

def copy_layout():
  shutil.copyfile(os.path.join(layout_path, layout_file_name), os.path.join(bin_path, layout_file_name))

def build():
  compile()
  copy_layout()
  embed_version_into_layout()

if len(sys.argv) == 1 or sys.argv[1] == "debug":
  build()
  sys.exit()

if sys.argv[1] == "release":
  bin_path = empty_string
  is_debug = False
  build()
  sys.exit()