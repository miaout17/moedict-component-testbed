require 'json'

comp_char = Hash.new {""}
char_comp = {}

File.read('single.fnt').lines.each do |line|
  line.strip!
  case line
  when /^(#.*)?$/
    # Comment or empty line. Do nothing.
  when /^!?[0-9A-F]{8}\|(.)(\d)=(.*)$/
    key, idx, value = $1, $2, $3
    case value
    when /^(([^0-9A-F])([0-9A-F]{9}))+$/
      comps = value.scan(/[^0-9A-F][0-9A-F]{9}/).map do |pat|
        chr = pat[0]
        x, y, w, h = 4.times.map { |i| pat[i*2+2..i*2+3].to_i(16) }
        datum = {'c' => chr, 'x' => x, 'y' => y, 'w' => w, 'h' => h}
      end
      # p [key, value, comps]
      char_comp[key] = comps unless char_comp.include?(key)
    when /^[0-9A-F]*$/
      # Do nothing
    else
      puts "Invalid value: #{value}"
    end
    components = value.gsub(/[0-9A-F]+/, '')
    next if components.empty?
    comp_char[components] += key
  else
    STDERR.puts "Unhandled line: #{line}"
  end
end

comp_char.to_a.each { |key, value| comp_char[key] = value.chars.to_a.uniq.join }

File.open('comp_char.json', 'wb') { |f| f.write(comp_char.to_json) }
File.open('char_comp.json', 'wb') { |f| f.write(char_comp.to_json) }
