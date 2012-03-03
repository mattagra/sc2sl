class NewsletterJob < Struct.new(:newsletter_id)
  def perform
    newsletter = Newsletter.find(newsletter_id)
    User.not_a_player.subscription.find_in_batches(:batch_size => 100) do |users|
      users.each { |u| UserMailer.delay.newsletter(u, newsletter) }
    end
    newsletter.sent = true
    newsletter.save
  end
end