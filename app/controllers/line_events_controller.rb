class LineEventsController < ApplicationController
  require 'line/bot'
  skip_before_action :require_login
  protect_from_forgery

  def show
    @user = User.find(current_user.id)
  end

  def update
    return unless set_user.id == current_user.id

    @user = User.find(current_user.id)
    @user.line_id = nil
    @user.save
    flash[:success] = t('messages.line_events.line_registration_deletion')
    redirect_to profile_path
  end
  
  def client
    @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
  end
  
  def receive
    body = request.body.read
    events = client.parse_events_from(body)
    events.each do |event|
      if event['type'] == 'follow'
        user_id = event['source']['userId']
        client.push_message(user_id, { type: 'text', text: '友達登録ありがとうございます！' })
        client.push_message(user_id, { type: 'text', text: '登録メールアドレスをメッセージで送るとLine通知機能がオンになります！' })
      elsif event['type'] == 'message'
        user_email = event['message']['text']
        # user_email.match(/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/) で取得でもいいかも
        user_line_id = event['source']['userId']
          if User.find_by(email: user_email)
            @user = User.find_by(email: user_email)
            @user.line_id = user_line_id
            @user.save
            client.push_message(user_line_id, { type: 'text', text: "#{@user.name}さんのLineが登録されました!" })
          else
            client.push_message(user_line_id, { type: 'text', text: 'メールアドレスが存在しませんでした。' })
          end
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
