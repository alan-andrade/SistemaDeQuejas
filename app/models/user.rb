require 'authenticator'

class User < ActiveRecord::Base
  set_primary_key :uid
  attr_accessible :uid, :name,  :role_id, :mail # Need to mention all of the mass-assignment possible attrs.
  
  belongs_to  :role
  has_many  :tickets, :foreign_key  =>  'student_id'

  
  def student?
    role.name == "Alumnos" ? true : false
  end
  
  def admin?
    role.name  ==  "Cuentas Especiales" ? true  : false
  end


  def self.authenticate(params)    # We need to return true or false
  ##
  ## CODE that needs revisions and some rethinking. Exceptions well hanlded and a clever way to code.
  ##
      begin
      result  = UDLA::Blackboard.authenticate(params[:user],params[:password])    
        rescue #rescue bad arguments exception
          false
      end
    
    if result.nil? || !result
      p "Empty Result"
      return false
    else
      entry = result.first
      user  = self.normalize_result(entry)      
      p user
      #User.exists?("user.uid = #{user.uid}") ? User.find(user.uid) : self.first_logon(user,entry)      
      potential_user  = User.where("uid = '#{user.uid}'")
      if potential_user.all.empty?
        self.first_logon(user,entry)
      else
        potential_user.first
      end
    end      
    
  end
  
  private
  
  def self.first_logon(user,entry)
    newuser       = User.new(user.marshal_dump)
    newuser.role  = Role.find_or_create_by_name(entry.dn.scan(/OU=(.*),/).flatten.first)## Arreglar para cuando no se tienen 2 OU
    newuser.save; newuser
  end  
  
  def self.normalize_result(result)
    user_attributes = OpenStruct.new
    (User.new.attributes.keys - ["created_at", "updated_at"] + ["uid"]).each do |attr|
      user_attributes.send "#{attr}=", result[attr][0]
    end
    user_attributes.uid = result[:lastlogontimestamp][0] if user_attributes.uid.nil?
    return user_attributes
  end
end


