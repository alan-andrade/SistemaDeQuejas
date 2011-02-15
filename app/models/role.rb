require 'authenticator'

class Role < ActiveRecord::Base
  def student?
    UDLA::Blackboard::ROLES[:student].include?(name) ? true : false
  end
  
  def admin?
    UDLA::Blackboard::ROLES[:admin].include?(name) ? true  : false
  end
end
