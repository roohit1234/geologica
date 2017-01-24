class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]



         def self.new_with_session(params, session)
  super.tap do |user|
    if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
      user.email = data["email"] if user.email.blank?
    end
  end
end

def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.name = auth.info.name   # assuming the user model has a name
    user.image = auth.info.image # assuming the user model has an image
  end
end


  # validates :username,
  # :presence => true,
  # :uniqueness => {
  #  :case_sensitive => false
  # } 

  # validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  #   def login=(login)
	 #    @login = login
	 #  end

	 #  def login
	 #    @login || self.username || self.email
	 #  end



  #   def self.find_for_database_authentication(warden_conditions)
  #     conditions = warden_conditions.dup
  #     if login = conditions.delete(:login)
  #       where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  #     else conditions.has_key?(:username) || conditions.has_key?(:email)
  #       where(conditions.to_hash).first
  #     end
  #   end




end
