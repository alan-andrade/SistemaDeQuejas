UDLAP_PATH  = File.dirname(__FILE__) + "/"

[
  "activedirectory/activedirectory.rb",
  "ldap/patch.rb"
].each do |lib|
  require UDLAP_PATH + lib
end
