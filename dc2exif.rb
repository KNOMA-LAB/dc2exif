require 'mini_exiftool'
require 'nokogiri'
require 'json'

# Abre o arquivo de mapeamento DC -> EXIF.
# Abre a imagem.
# Abre o XML com Dublin Core.
#
# Para cada chave:valor na config,
#   Pega a chave no DC e escreve no `valor` do EXIF.

def config_and_attr_equal?(config, value, attr)
  value.attr(attr) == config[attr]
end

def find_value_for_config(values, config)
  value = values.find do |v|
    [
      config_and_attr_equal?(config, v, "element"),
      config_and_attr_equal?(config, v, "qualifier"),
      config_and_attr_equal?(config, v, "language"),
    ].all?
  end

  [config["to"], value.text]
end

CONFIG = JSON.load(File.open('config.json'))
image = MiniExiftool.new("resolver.jpeg")
dublin_core = Nokogiri::XML(File.open("dublin_core.xml"))

dcvalues = dublin_core.xpath("//dublin_core//dcvalue")

CONFIG.each do |c|
  v = find_value_for_config(dcvalues, c)
  image[v[0]] = v[1]
  puts image[v[0]]
end

image.save
