class RetwetsController < ApplicationController
  before_filter :authenticate_user!

  # POST /retwets
  #
  # This action attempts to create a new retwet instance for the Twet whose id matches
  # params[:retwet][:twet_id]. If the retwet is created successfully, a success notice
  # is set. Otherwise, an error notice is set. #smart_return is used to redirect appropriately.
  #
  def create
    rt = current_user.retwets.create(retwet_params)
    if rt.valid? and rt.persisted?
      flash[:success] = "You retweted: #{rt.twet.content}"
    else
      flash[:error] = "We're sorry. You are unable to retwet that post."
    end
    smart_return
  end

  # DELETE /retwets/:id
  #
  # Responsible for un-retweting. Works by deleting the Retwet instance. The use of the
  # resource method (defined below) ensures that only retwets which belong to the authenticated
  # user can be matched and deleted. If the Retwet instance is not found or deleted successfully,
  # an error notice is set. #smart_return is used to redirect appropriately.
  #
  def destroy
    if resource.exists?
      resource.destroy_all
    else
      flash[:error] = "We're sorry. We could not find that retwet."
    end
    smart_return
  end

  private

  # Finds a retwet instance that matches the id passed and assigns it to @resource
  # unless @resource is already assigned.
  #
  def resource
    @resource ||= current_user.retwets.where(:id => params[:id])
  end

  # http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # This method uses Strong Parameters to ensure that the data passed by the user
  # is appropriate. If params[:retwet] does not exist or contains any key / value
  # pairs other then :twet_id, an error will be raised and the page will return
  # a 400 'Bad Request' HTML response code.
  #
  def retwet_params
    params.require(:retwet).permit(:twet_id)
  end

  # Leverages the params[:return_to] value to direct the user back to a requested
  # page. If no value is present, the user is directed back to the root path.
  #
  def smart_return
    if params[:return_to].present?
      redirect_to params[:return_to]
    else
      redirect_to root_path
    end
  end
end