class UserMailer < ApplicationMailer
  def report_email(attachment, email)

    attachments['report.pdf'] = attachment
    mail(to: email, subject: 'Users report ')
  end

end
