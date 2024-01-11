class CommentsController < ApplicationController
  require 'line/bot'

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.save
    client.push_message(@comment.post.user.line_id, { type: 'text', text: "#{@comment.post.user.name}さんの投稿、#{@comment.post.title}にコメントが追加されました!" })
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id, post_id: params[:post_id])
  end
end
