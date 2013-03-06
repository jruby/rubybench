require 'perfer'
require 'stringio'
require 'base64'

def read_varint(io)
  value = index = 0
  begin
    byte = io.readbyte
    value |= (byte & 0x7f) << (7 * index)
    index += 1
  end while (byte & 0x80).nonzero?
  value
end

def decode_base64_protobuf(string)
  values = []
  io = StringIO.new(Base64.decode64(string))  
  until io.eof?
    bits = read_varint(io)
    values[(bits >> 3) - 1] = 
      case bits & 0x07
      when 0; read_varint(io)
      when 2; io.read(read_varint(io))
      end
  end
  values
end

Perfer.session 'base 64 decoding' do |s|
  s.iterate 'protobuf' do |n|
    line = 'CKeTAxCmmfRHGK6trLv1prbkEiCglsTnBDgBMAA='
    n.times do
      decode_base64_protobuf(line.split[-1]).join("\t")
    end
  end
end
