require 'mini_exiftool'
require 'nokogiri'
require 'json'

# Abre o arquivo de mapeamento DC -> EXIF.
# Abre a imagem.
# Abre o XML com Dublin Core.
#
# Para cada chave:valor na config,
#   Pega a chave no DC e escreve no `valor` do EXIF.

CONFIG = JSON.load(File.open('config.json'))
image = MiniExiftool.new("resolver.jpeg")
dublin_core = Nokogiri::XML(File.open("dublin_core.xml"))

dcvalues = dublin_core.xpath("//dublin_core//dcvalue")
dcvalues.each do |v|
  puts v.attr("element"), v.text
end

title_node = dcvalues.find { |v| v.attr("element") == "title" }
image.title = title_node.text
image.save
