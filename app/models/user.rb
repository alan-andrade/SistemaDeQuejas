require 'authenticator'

class User < ActiveRecord::Base
  set_primary_key :uid
  
  belongs_to  :role


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
      User.exists?(user.uid) ? User.find(user.uid) : self.first_logon(user,entry)      
    end      
    
  end
  
  private
  
  def self.first_logon(user,entry)
    newuser       = User.new(user.marshal_dump)
    newuser.role  = Role.find_or_create_by_name(entry.dn.scan(/OU=(.*),OU=/).flatten.first)
    newuser.save
  end  
  
  def self.normalize_result(result)
    user_attributes = OpenStruct.new
    (User.new.attributes.keys - ["created_at", "updated_at"] + ["uid"]).each do |attr|
      user_attributes.send "#{attr}=", result[attr][0]
    end
    return user_attributes
  end
end


