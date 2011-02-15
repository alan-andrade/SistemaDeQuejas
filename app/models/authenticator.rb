module UDLA ## Need to refactor WHERE to put this library. Checkout Docs. and change file name. is to specific and is not anymore!
  class Blackboard
    require 'net/ldap'
    
    ## This MAP is given the ActiveDirectory form the UDLAP.
    ROLES = { :admin    =>  ["Cuentas Especiales", "Administrativos"],
              :student  =>  ["Alumnos"]} 
    
    WANTED_ATTRS  = %w(mail sAMAccountName dn name) #direct relation with the monkeypatching at the bottom
    
    def self.authenticate(user,pass)
      raise "No user Given" if user.empty?
      conn    = @@connection ||= self.setup
      filter  = Net::LDAP::Filter.eq('sAMAccountName', user)
      return conn.bind_as(:filter => filter, :password => pass)
    end
    
    def self.find_users_by_id(id)
      raise "Only Accepts Argument of type Integer" if id.match(/[^\d]/) # detect characters.
      treebase  =   "dc=udla,dc=fundacion,dc=mx"
      filter    =   Net::LDAP::Filter.eq( "sAMAccountName", "#{id}" )      
      ldap      =   @@connection  ||= self.setup
      results   =   Array.new
      ldap.search(:base=>treebase, :filter=>filter, :attributes=>WANTED_ATTRS) do |entry|
        results << entry
      end
      return results
    end
    
    private
    def self.setup
      @@connection =  
      Net::LDAP.new(
            :host => "140.148.9.10",
            :port => 389,
            :base => "DC=udla,DC=fundacion,DC=mx",
            :auth => {
              :method => :simple,
              :username => "CN=Blackboard Connection,OU=Cuentas Especiales,DC=udla,DC=fundacion,DC=mx",
              :password => "bl4ckb.ard"
            })
    end
  end
end

## Mokeypatching of the NET/LDAP library to get role and uid as we want. May be good idea to move to a proper file
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
