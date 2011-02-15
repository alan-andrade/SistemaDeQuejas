class Role < ActiveRecord::Base
  def student?
    UDLAP::ActiveDirectory::ROLES[:student].include?(name) ? true : false
  end
  
  def admin?
    UDLAP::ActiveDirectory::ROLES[:admin].include?(name) ? true  : false
  end
end
