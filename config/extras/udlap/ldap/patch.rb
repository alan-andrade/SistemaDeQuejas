module Net
  class LDAP
    class Entry
      require 'base64'
      def role
        dn.scan(/OU=([^,]*)/).flatten.first
      end
      
      def uid
        @myhash[:samaccountname] if @myhash.has_key? :samaccountname
        Base64.encode64 name
      end
    end
  end
end
