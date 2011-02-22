module UDLAP
  module ActiveDirectory
    require 'net/ldap'
    
    ROLES = {   :admin    =>  ["Cuentas Especiales", "Administrativos"],
                :student  =>  ["Alumnos"]} 
      
    WANTED_ATTRS  = %w(mail sAMAccountName dn name)
    
    def self.authenticate(user,pass)
      raise "No user Given" if user.empty?
      connection    = @@connection ||= self.setup
      filter        = Net::LDAP::Filter.eq('sAMAccountName', user)
      return connection.bind_as(:filter => filter, :password => pass)
    end
    
    def self.find_users_by_id(id)     ## TODO: rescue the connection timed-out effectively.
      begin
        p "Connecting to UDLAP..."
        connection      =   @@connection  ||= self.setup
        filter          =   Net::LDAP::Filter.eq('sAMAccountName', "#{id}")
        results         =   Array.new
        connection.search(:filter=>filter, :attributes=>WANTED_ATTRS) do |entry|
          results << entry
        end
        
        rescue Net::LDAP::LdapError
          p "No connection."
          return "Error en conexion."
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
