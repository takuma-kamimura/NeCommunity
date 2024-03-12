module Login_process
    def login_process(user)
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: 'password'
      click_button 'Login'
    end
    def login_process_admin(user)
      visit admin_login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: 'password'
      click_button 'Login'
    end
  end
  RSpec.configure do |config|
    config.include Login_process
  end
