module UDLAP
  module ActiveDirectory
    require 'net/ldap'
    
    ROLES = { :admin    =>  ["Cuentas Especiales", "Administrativos"],
               :student  =>  ["Alumnos"]} 
      
    WANTED_ATTRS  = %w(mail sAMAccountName dn name)
    
    def self.authenticate(user,pass)
      raise "No user Given" if user.empty?
      conn    = @@connection ||= self.setup
      filter  = Net::LDAP::Filter.eq('sAMAccountName', user)
      return conn.bind_as(:filter => filter, :password => pass)
    end
    
    def self.find_users_by_id(id)
      raise "Only Accepts Argument of type Integer" if id.match(/[^\d]/) # detect characters.
      filter    =   Net::LDAP::Filter.eq( "sAMAccountName", "#{id}" )      
      ldap      =   @@connection  ||= self.setup
      results   =   Array.new
      ldap.search(:filter=>filter, :attributes=>WANTED_ATTRS) do |entry|
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
