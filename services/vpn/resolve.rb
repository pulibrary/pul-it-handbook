File.readlines("#{__dir__}/ips.txt").each do |ns|
  output = `nslookup #{ns}`.split("\n")
  link = output.last{|x| x.include?("Address")}
  next if link.include?("server") || link.include?("Can't")
  puts link.gsub("Address:", "").gsub(" ","")
end
