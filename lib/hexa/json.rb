module Hexa
  module Json
    def self.generate(val, **options)
      io = StringIO.new
      stream = WriteStream.new(io, **options)
      stream.write(val)
      io.string
    end
  end
end
