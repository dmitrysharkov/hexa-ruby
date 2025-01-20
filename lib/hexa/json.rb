module Hexa
  module Json
    def self.generate(val, **options)
      io = StringIO.new
      stream = Writer.new(io, **options)
      stream.write(val)
      io.close
      io.string
    end
  end
end
