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
    (role.name  ==  "Administrativos" || role.name  == "Cuentas Especiales") ? true  : false
  end

  ## Parameter ID could have an asterisk used as a wildcard
  
  def self.find_by_id(id)
    results = UDLA::Blackboard.find_users_by_id(id)
    users = []
    results.each do |user|
      users << if User.exists?(user.samaccountname[0])
                  User.find(user.samaccountname[0])
               else
                  nUser       = User.new(:uid=>user.samaccountname[0],:mail=>user.mail[0],:name=>user.name[0])
                  nUser.role  = Role.find_or_create_by_name(user.role); nUser.save
                  nUser
               end
    end
    users
  end

  def self.authenticate(params)    # We need to return true or false
  ##
  ## CODE that needs revisions and some rethinking. Exceptions well hanlded and a clever way to code.
  ##
  login,pass = params[:user],params[:password]
  
      begin
      result  = UDLA::Blackboard.authenticate(login,pass)    
        rescue #rescue bad arguments exception or connection.
          false
      end
    
    if result.nil? || !result
      p "No user"
      return false
    else
      User.find_by_id login
    end   
  end    
end


