#!/usr/bin/env ruby

require 'json'
require 'nokogiri'
require 'optparse'

require 'mini_exiftool'

options = {}
OptionParser.new do |opts|
  opts.banner = <<EOM
Usage:

    dc2exif.rb -c config.json -d dublin_core.xml -i picture.jpeg

If there is EXIF metadata in `picture.jpeg` that has been configured by
`config.json` to be overwritten, it will be lost.
EOM

  options["config"] = "config.json"

  opts.on("-c", "--config CONFIG",
          "File specifying Dublin Core -> EXIF conversion.") do |c|
    options["config"] = c
  end

  opts.on("-d", "--dublin-core DC",
          "Input Dublin Core XML file.") do |dc|
    options["dublin_core"] = dc
  end

  opts.on("-i", "--image IMAGE", "Image file.") do |image|
    options["image"] = image
  end
end.parse!

def config_and_attr_equal?(config, value, attr)
  value.attr(attr) == config[attr]
end

def find_value_for_config(values, config)
  value = values.find do |v|
    [
      config_and_attr_equal?(config, v, "element"),
      config_and_attr_equal?(config, v, "qualifier"),
    ].all?
  end

  [config["to"], value.text]
end

config = JSON.load(File.open(options["config"]))
dublin_core = Nokogiri::XML(File.open(options["dublin_core"]))
image = MiniExiftool.new(options["image"])

dcvalues = dublin_core.xpath("//dublin_core//dcvalue")

config.each do |c|
  field, text = find_value_for_config(dcvalues, c)
  image[field] = text
end

image.save
