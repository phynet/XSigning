class Utils
  def self.formatting_string_certificate(certificate_string)
    string = certificate_string[1..-2].split('"').collect! {|n| n.to_s}
    final_array = string.values_at(* string.each_index.select {|i| i.odd?})
    return final_array
  end
end
