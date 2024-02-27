module Login_process
    def login_process(user)
      visit root_path
      find('.fa-solid.fa-bars.fa-2x').click
      click_link "Login"
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Login'
    #   Capybara.assert_current_path("/boards", ignore_query: true)
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
