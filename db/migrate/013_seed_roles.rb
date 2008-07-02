class SeedRoles < ActiveRecord::Migration
  def self.up
    Role.create(:title => "sysadmin", 
      :description => "System Admininistrator",
      :default_role => false)
    Role.create(:title => "prodmgr", 
      :description => "Product Manager",
      :default_role => false)
    Role.create(:title => "voter", 
      :description => "Voter",
      :default_role => true)
    Role.create(:title => "allocmgr", 
      :description => "Allocations Manager",
      :default_role => false)
    
    assign_user 'admin@openmind.org', "sysadmin"
    assign_user 'prodmgr@openmind.org', "prodmgr"
    assign_user 'voter@openmind.org', "voter"
    assign_user 'allocmgr@openmind.org', "allocmgr"
    assign_user 'all@openmind.org', [ "voter", "sysadmin", "prodmgr", "allocmgr"  ]
  end

  def self.down
    for role in Role.find(:all)
      role.destroy
    end
  end
  
  private
  
  def self.assign_user(user_name, role_names)
    user = User.find_by_email(user_name)
    throw "User not found: '#{user_name}'" if user.nil?
    roles = Role.find :all, :conditions => { :title => role_names }
    user.roles << roles
  end
end