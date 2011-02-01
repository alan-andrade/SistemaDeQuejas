module UDLA
  class Blackboard
    require 'net/ldap'
    
    def self.authenticate(user,pass)
      raise "No user Given" if user.empty?
      conn    = self.setup
      filter  = Net::LDAP::Filter.eq('sAMAccountName', user)
      return conn.bind_as(:filter => filter, :password => pass)
    end
    
    private
    def self.setup
      return Net::LDAP.new(
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
