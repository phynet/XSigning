require "erb"
require_relative 'set_values'

class Main < SetValues

  set_values = SetValues.new

  puts 'Write Provisioning Profile name:'
  @provisioning_profile_name = gets.chomp

  puts 'Write Certificate name:'
  @certificate_profile_name = gets.chomp

  puts 'Write path xcodeproj:'
  @path_xcode = gets.chomp

  puts 'Searching provisioning....'

  set_values.path_provisioning

  array_provisioning = set_values.list_all_provisioning
  array_uuid, array_name_prov = set_values.query_security_keychain(array_provisioning)

  provisioning_uuid = set_values.validate_provisioning(array_uuid,array_name_prov,@provisioning_profile_name)

  set_values.validate_codesign_identity(@certificate_profile_name)
  set_values.validate_path_xcode(@path_xcode)
  set_values.write_in_XCProject(provisioning_uuid,@certificate_profile_name)

end
