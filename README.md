# dc2exif

`dc2exif` is a script to convert a subset of Dublin Core metadata (as specified in a `config.json` file) to and from an image's EXIF metadata.

## Usage

The command to convert metadata present in `dc.xml` to EXIF in `picture.jpeg`
according to the rules in `config.json` is:

    dc2exif -c config.json --dublin-core dc.xml -i picture.jpeg

We expect to provide an `exif2dc` someday.

## config.json

Te config file is a list of JSON objects with parameters `element`, `qualifier`
and `to`. The first three are used to identify which Dublin Core values to save
into the `to` Exif tag of the image.

    [
      {
        "element": "contributor",
        "qualifier": "author",
        "language": "pt_BR",
        "to": "Author"
      },
      ...
    ]


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Knoma-lab/dc2exif.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
