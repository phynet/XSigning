class SetValues
  require 'fileutils'
  include FileUtils
  require_relative 'Utils'

  def move_to_path(path)
    FileUtils.cd(path, :verbose => true)
  end

  def path_provisioning(path)
    puts "enters to path provisioning #{path}"
    abort "Provisioning profile path #{path} does not exist. Search for it in terminal." unless File.exists? path
    move_to_path(path)
  end

  def validate_path_xcode(path_xcode)
    @path_xcode = path_xcode
    abort "Xcodeproj path '#{path_xcode}' does not exist" unless File.exists? path_xcode
    FileUtils.cd(path_xcode, :verbose => true)
  end

  def list_of_all_provisioning
    return Dir.glob("*mobileprovision*")
  end

  def query_security_keychain(array)
   puts 'enters security keychain...'

    uuid = []
    name_certs = []

    array.each do |actual_provisioning|
      command="security cms -D -i #{actual_provisioning}"
      value_provisioning=%x(#{command})

      value_provisioning=~/<key>UUID<\/key>.*?<string>(.*?)<\/string>/im
      uuid.push($1.strip)

      value_provisioning=~/<key>Name<\/key>.*?<string>(.*?)<\/string>/im
      name_certs.push($1.strip)
    end
    return uuid, name_certs
  end

  def write_in_XCProject(uuid_prov, user_cert_name)
    @path_xcode << '/' << Dir.glob("*xcodeproj*")[0] << '/project.pbxproj'

    prov = "PROVISIONING_PROFILE = \"#{uuid_prov}\";"
    cert = "CODE_SIGN_IDENTITY = \"#{user_cert_name}\";" 
    cert_sdk = /\"CODE_SIGN_IDENTITY\[sdk=iphoneos\*\]\"\s=\s"(.*?)";$/
    cert_sdk_sub = "\"CODE_SIGN_IDENTITY[sdk=iphoneos*]\" = \"#{user_cert_name}\";"

    File.open(filename = @path_xcode, "r+") { |file| file << File.read(filename).gsub(/PROVISIONING_PROFILE\s=\s"(.*?)";$/,"#{prov}") }
    File.open(filename = @path_xcode, "r+") { |file| file << File.read(filename).gsub(/CODE_SIGN_IDENTITY\s=\s"(.*?)";$/,"#{cert}") }
    File.open(filename = @path_xcode, "r+") { |file| file << File.read(filename).gsub(cert_sdk,cert_sdk_sub) }
    
    puts 'File changed...'
    puts 'Done with signing...'
  end

  def check_for_match_provisioning(array_uuid,provisioning_name_array, user_provisioning_name)
    provisioning_name_array.each_with_index do |value, index|
      if value.eql? user_provisioning_name
        return value, array_uuid[index]
        #we need the uuid that match the provisioning from the array
      end
    end
    return false, provisioning_name_array unless provisioning_name_array.include? user_provisioning_name
  end

  def check_for_match_certificate(certificate_name_array, user_certificate_name)
    format_array = Utils::formatting_string_certificate(certificate_name_array)
       return false, format_array unless format_array.include? user_certificate_name
    else
      return true
  end

  def validate_codesign_identity(user_certificate)
    list_all_certs =  search_all_certificates
    val_cert, list_format_cert =  check_for_match_certificate(list_all_certs,user_certificate)


    unless val_cert
      puts ("Certificate Profile #{user_certificate} does not exist")
      list_all_codesign_identity(list_format_cert)
      abort('Error in certificate profile. Try again.')
    end
  end

  def validate_provisioning(array_uuid,provisioning_profile_names,user_provisioning_profile_name)

    val_prov, uuid_prov = check_for_match_provisioning(array_uuid,provisioning_profile_names,user_provisioning_profile_name)

    unless val_prov
        puts ("Provisioning Profile #{user_provisioning_profile_name} does not exist")
        list_all_provisioning_profiles(provisioning_profile_names)
        abort('Error in provisioning profile. Try again.')
    end
    return uuid_prov
  end

  def list_all_provisioning_profiles(provisioning_list)
    puts 'These are all provisioning profile found:'
    puts provisioning_list
  end

  def list_all_codesign_identity(certificate_list)
    puts 'These are all code sign identity found'
    puts certificate_list
  end


  def search_all_certificates
    command="/usr/bin/security find-identity -v -p codesigning"
    list_all_certs = %x(#{command})
    return list_all_certs
  end




end
