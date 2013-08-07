require 'json'

comp_char = Hash.new {""}

File.read('single.fnt').lines.each do |line|
  line.strip!
  case line
  when /^(#.*)?$/
    # Comment or empty line. Do nothing.
  when /^!?[0-9A-F]{8}\|(?<key>.)\d=(?<value>.*)$/
    key = $~[:key]
    value = $~[:value]
    components = value.gsub(/[0-9A-F]+/, '')
    next if components.empty?
    comp_char[components] += key
    # p [components, comp_char[components]] if comp_char[components].length>1
  else
    STDERR.puts "Unhandled line: #{line}"
  end
end

File.open('comp_char.json', 'wb') do |f|
  f.write(comp_char.to_json)
end

