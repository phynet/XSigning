class SetValuesCalabash
  require 'fileutils'
  include FileUtils
  require_relative 'Utils'

  def move_to_path(path)
    FileUtils.cd(path, :verbose => true)
  end

  def validate_path_xcode(path_xcode)
    @path_xcode = path_xcode
    abort "Xcodeproj path '#{path_xcode}' does not exist" unless File.exists? path_xcode
  end

  def list_all_provisioning path
    puts 'enters to provisioning path'
    abort "Provisioning profile path '#{path}' does not exist. Tell this to the developer." unless File.exists? path
    return Dir.glob("#{path}/*mobileprovision*")
  end

  ## a loop through all mobileprovisioning and save it in a file .xml
  def query_security_keychain(array)
   puts 'enters security keychain...'

    uuid = []
    name_certs = []

    array.each do |actual_provisioning|
      command="security cms -D -i \"#{actual_provisioning}\""
      value_provisioning=%x(#{command})

      value_provisioning=~/<key>UUID<\/key>.*?<string>(.*?)<\/string>/im
      uuid.push($1.strip)

      value_provisioning=~/<key>Name<\/key>.*?<string>(.*?)<\/string>/im
      name_certs.push($1.strip)
    end
    return uuid, name_certs
  end


  def write_in_XCProject(uuid_prov, user_cert_name)
    @path_xcode = Dir.glob("#{@path_xcode}/*xcodeproj*")[0] << '/project.pbxproj'
    puts @path_xcode

    #prov = "PROVISIONING_PROFILE = \"#{uuid_prov}\";"
    #cert = "CODE_SIGN_IDENTITY = \"#{user_cert_name}\";"
     
     prov =/<key>PROVISIONING_PROFILE<\/key>\s.*?<string>(.*?)<\/string>/mi
     cert =/<key>CODE_SIGN_IDENTITY<\/key>\s.*?<string>(.*?)<\/string>/mi

     prov1="<key>PROVISIONING_PROFILE</key>" + "\n"
     prov2= "                <string>#{uuid_prov}</string>"
     prov3 = prov1+prov2

     cert1="<key>CODE_SIGN_IDENTITY</key>"+"\n"
     cert2= "                <string>#{user_cert_name}</string>"
     cert3 = cert1+cert2

     File.open(filename = @path_xcode , "r+") { |file| file << File.read(filename).gsub(prov,"#{prov3}") }
     File.open(filename = @path_xcode , "r+") { |file| file << File.read(filename).gsub(cert,"#{cert3}") }

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
     unless format_array.include? user_certificate_name
      return false, format_array
    else
      return true
    end
  end

  def validate_codesign_identity(user_certificate)
    command="/usr/bin/security find-identity -v -p codesigning"
    list_all_certs = %x(#{command})

    val_cert, list_format_cert = check_for_match_certificate(list_all_certs,user_certificate)

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

end