class User < ActiveRecord::Base
  #set_primary_key :uid
  #attr_accessible :id, :name,  :role_id, :mail # Need to mention all of the mass-assignment possible attrs.
  
  belongs_to  :role
  has_many    :tickets, :foreign_key  =>  'student_id'
  # Validation to ensure uniqueness of responsibles. Can refactor and make it more pretty.
  validates :ticket_taker, :uniqueness => true, :if => Proc.new {|user|
      if user.ticket_taker_changed? 
        old = User.where(:ticket_taker=>true).first
        return true if old.nil?
        old.ticket_taker = false
        old.save(:validate=>false)
      else
        false
      end
    }
  
  scope :managers,  joins(:role).where(:roles=>{:name=> UDLAP::ActiveDirectory::ROLES[:admin] }).readonly(false)
  scope :students,  joins(:role).where(:roles=>{:name=> UDLAP::ActiveDirectory::ROLES[:student] }).readonly(false)
  scope :ticket_taker,  where(:ticket_taker =>  true)
  
  with_options :to=>:role do |r|
    r.delegate :student?
    r.delegate :admin?
  end

   
  ## FIXED: Won't accept asterisk or any other character. A bit more secure ;)
  def self.find_by_uid(id) ## TODO: Can do some refactoring. Looks ugly this finding method. Shouldnt be here.
    raise "Wont accept asterisk" if id.to_s.match(/\*/)
    return  nil if id.nil?
    return User.where(:uid => id).first if User.exists?(:uid => id)
    results = UDLAP::ActiveDirectory.find_users_by_id(id)
    users = []
    results.each do |user|
      users << if User.exists?(:uid => user.uid)
                  User.where(:uid => user.uid).first
               else
                  nUser       = User.new(:uid=>user.uid, :mail=>user.mail[0],:name=>user.name[0])
                  nUser.role  = Role.find_or_create_by_name(user.role); nUser.save
                  nUser
               end
    end
    return nil      if users.empty?
    return users[0] if users.size == 1
    users
  end

  def self.authenticate(login, pass)    # We need to return true or false
  ##
  ## CODE that needs revisions and some rethinking. Exceptions well hanlded and a clever way to code.
  ##  
      begin
      result  = UDLAP::ActiveDirectory.authenticate(login,pass)    
        rescue #rescue bad arguments exception or connection.
          false
      end
    
    if result.nil? || !result
      p "No user"
      return false
    else
      User.find_by_uid login
    end   
  end    
  
  
  private
  
    def ticket_taker_uniqueness   ## Keep always 1 person in charge. This could change depending on what final Users want
      if self.ticket_taker_changed?
        oldUser = User.where(:ticket_taker => true).first
        unless oldUser.nil?
          p "OLD USER ticket taker"
          oldUser.ticket_taker=false
          oldUser.save!
        end
      end        
    end
end


