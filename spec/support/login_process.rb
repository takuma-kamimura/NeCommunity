module Login_process
    def login_process(user)
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: 'password'
      click_button 'Login'
    end
    # def login_as_admin(user)
    #   visit admin_login_path
    #   fill_in 'メールアドレス', with: user.email
    #   fill_in 'パスワード', with: '12345678'
    #   click_button 'ログイン'
    #   Capybara.assert_current_path("/admin", ignore_query: true)
    # end
  end

  RSpec.configure do |config|
    config.include Login_process
  end
