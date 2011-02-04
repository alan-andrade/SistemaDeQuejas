module UDLA
  class Blackboard
    require 'net/ldap'
    
    WANTED_ATTRS  = %w(mail sAMAccountName dn name)
    
    def self.authenticate(user,pass)
      raise "No user Given" if user.empty?
      conn    = @@connection ||= self.setup
      filter  = Net::LDAP::Filter.eq('sAMAccountName', user)
      return conn.bind_as(:filter => filter, :password => pass)
    end
    
    def self.find_users_by_id(id)
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

module Net
  class LDAP
    class Entry
      def role
        dn.scan(/OU=([^,]*)/).flatten.first
      end
    end
  end
end
