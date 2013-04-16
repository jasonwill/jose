class User
  include Mongoid::Document
  include Mongoid::Timestamps

  extend Rolify
  rolify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :ldap_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email, :type => String, :default => ""
  field :username, :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  field :firstname, :type => String, :default => ""
  field :lastname, :type => String, :default => ""
  field :groups, :type => Array, :default => ""
  
  #validates_presence_of :email
  #validates_presence_of :username
  #validates_presence_of :encrypted_password

  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :groups, :created_at, :updated_at
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ email: 1 }, { unique: true, background: true })
  index({ username: 1 }, { unique: true, background: true })
  
  before_save :ldap_before_save 
  
  def ldap_before_save
    get_ldap_attr
  end
  
  def get_ldap_attr
    self.lastname    = Devise::LdapAdapter.get_ldap_param(self.username,"sn")
    self.firstname   = Devise::LdapAdapter.get_ldap_param(self.username,"givenname")
    
    self.email = Devise::LdapAdapter.get_ldap_param(self.username,"mail")

    #~ Retrieve group memberships (this is specific to Apple's OD schema - typically Devise::LdapAdapter.get_groups(self.username) would be used here)
    admin_ldap = Devise::LdapAdapter::LdapConnect.admin
    group_type_filter = Net::LDAP::Filter.eq( "objectClass", "posixGroup" )
  	member_filter = Net::LDAP::Filter.eq( "memberUid", self.username )
  	
  	groups = admin_ldap.search( :base => "dc=xxx,dc=com", :filter => group_type_filter & member_filter, :attributes => ["dn", "cn", "mail", "displayname", "listowner", "members"], :return_result => true ).collect(&:cn).flatten
  	self.groups = groups
    
  end
  
  def admin?
    self.groups.include?('admin')
  end

end
