module ControllerMacros
  def login_admin
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      admin = FactoryGirl.create(:user)
      admin.roles << FactoryGirl.create(:admin_role)
      sign_in admin # Using factory girl as an example
    end
  end

  def login_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      user.roles << FactoryGirl.create(:role)
      sign_in user
    end
  end
end