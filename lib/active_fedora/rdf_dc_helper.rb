module ActiveFedora
  module RdfDcHelper

    # Takes an input string in the DCSV format
    # (see http://dublincore.org/documents/dcmi-dcsv/ )
    # and returns a hash.
    #
    # TODO: This does not handle the '.' scope operator at all
    def self.decode_dcsv(input_string)
      result = {}
      unlabeled_count = 0
      value_list = input_string.split(/(?<!\\);/)
      value_list.each do |value|
        value.gsub!(/\\;/,';') # unescape ;
        label, rest = value.split(/(?<!\\)=/,2)
        label.gsub!(/\\=/, '=')
        rest.gsub!(/\\=/, '=') if rest
        if rest
          result[label] = rest
        else
          result[unlabeled_count] = label
          unlabeled_count += 1
        end
      end
      result
    end

    def self.encode_dcsv(input)
      if input.is_a?(Hash)
        result = []
        input.each_pair do |k,v|
          if k.is_a?(Integer)
            result << encode_dcsv(v)
          else
            result << "#{encode_dcsv(k)}=#{encode_dcsv(v)}"
          end
        end
        result.join("; ")
      else
        input.to_s.gsub(/([=;])/) { "\\#{$1}" }
      end
    end
  end
end
