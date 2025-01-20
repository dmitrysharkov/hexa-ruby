module Hexa
  module Json
    def self.generate(val, **options)
      io = StringIO.new
      stream = WriteStream.new(io, **options)
      val.class.write_to_stream(val, stream)
      io.string
    end
  end
end
