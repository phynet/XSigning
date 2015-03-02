# © 2014 Sofia Swidarowicz
# main.rb

require "erb"
require_relative 'set_values'

class Main < SetValues

  set_values = SetValues.new


  if ARGV.count > 3
    @certificate_profile_name = ARGV[0].dup
    puts "Using Certificate name: #{@certificate_profile_name}"

    @provisioning_profile_name = ARGV[1].dup
    puts "Using Provisioning Profile name: #{@provisioning_profile_name}" 

    @path_xcode = ARGV[2].dup
    puts "Using path xcodeproj: #{@path_xcode}"

    @provisioning_profile_path = ARGV[3].dup
    puts "Using Provisioning Profile path: #{@provisioning_profile_path}"

    puts 'Searching provisioning and certificates....'

    set_values.path_provisioning(@provisioning_profile_path)

    array_provisioning = set_values.list_of_all_provisioning
    array_uuid, array_name_prov = set_values.query_security_keychain(array_provisioning)

    provisioning_uuid = set_values.validate_provisioning(array_uuid,array_name_prov,@provisioning_profile_name)

    set_values.validate_codesign_identity(@certificate_profile_name)
    set_values.validate_path_xcode(@path_xcode)
    set_values.write_in_XCProject(provisioning_uuid,@certificate_profile_name)

  else
     ARGV.each do |opt|
        if opt.eql? 'cert'
          list_certs = set_values.search_all_certificates
          format_array = Utils::formatting_string_certificate(list_certs)
          puts format_array
        elsif opt.eql? 'prov'
          @provisioning_profile_path = ARGV[2].dup
          puts "Using Provisioning Profile path: #{@provisioning_profile_path}"
          set_values.path_provisioning(@provisioning_profile_path)
          array_provisioning = set_values.list_of_all_provisioning
          array_name_prov = set_values.query_security_keychain(array_provisioning)
          puts set_values.list_all_provisioning_profiles(array_name_prov)
        end
      end
  end
  
 


  

  
end
