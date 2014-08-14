module ApplicationHelper
  # Being the ApplicationHelper, all methods herein are available in all views.

  # Responsible for generating the appropriate form to follow or unfollow a user. If the
  # authenticated user is already following the user passed, an unfollow (DELETE) form
  # will be generated. Otherwise, a follow (CREATE) form will be generated.
  #
  def follow_link(user)
    follow = Follow.where(:user => current_user, :following => user)
    if follow.exists?
      button_to("Unfollow", follow_path(follow.first), :method => :delete,
                                                       :class => 'btn btn-danger mar-top-5',
                                                       :form => { :class => 'form-inline pull-right' })
    else
      form_for(:follow, :url => follows_path, :method => 'POST', :html => { :class => 'pull-right' }) do |f|
        f.hidden_field(:following_id, :value => user.id.to_s) +
        f.submit('Follow', :class => "btn btn-primary mar-top-5")
      end
    end
  end

  #gravatar
  def gravatar(user, opts = { :size => 48 })
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.downcase)}?s=#{opts[:size]}"
  end
  # Generates a left navigation link setting the class according to the result of a
  # call to the #active_class method.
  #
  def nav_item(name, path)
    content_tag(:li, link_to(name, path), :class => active_class(name))
  end

  # Generates HTML for notices based on the flash variable. Leverages #notice_class to
  # determine the look of each notice type.
  #
  def notices
    content_tag :div, :class => 'alert-float' do
      html = ''
      [:alert, :error, :notice, :success].each do |type|
        html += content_tag(:div, notice_text(type), :class => notice_class(type)) if notice?(type)
      end
      html.html_safe
    end
  end

  private

  # Returns 'active' or '' based on the name past and the current controller. Used by
  # #nav_item to show which page link is currently active.
  #
  def active_class(name)
    case name
    when "Follow" then
      controller_name == 'follows' ? 'active' : ''
    when "Twet" then
      controller_name == 'twets' ? 'active' : ''
    end
  end

  # Returns true / false based on whether there is a flash notice of a specific type.
  # Used by #notices to only display alert boxes when there is alert content.
  #
  def notice?(type)
    flash[type].present?
  end

  # Returns a css class or set of classes to be used with alerts of a specific type.
  # Used by #notices.
  #
  def notice_class(type)
    case type
    when :error then 'alert text-danger'
    when :success then 'alert text-success'
    else
      'alert text-warning'
    end
  end

  # Returns HTML for the internal content of a notice of a specific type. Used by #notices.
  #
  def notice_text(type)
    html = content_tag :button, "Dismiss Alert", :class => 'close', 'data-dismiss' => 'alert', 'aria-hidden' => true
    html += content_tag :strong, flash[type]
    html.html_safe
  end
end
