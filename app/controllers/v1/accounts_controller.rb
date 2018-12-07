class V1::AccountsController < V1::BaseController
  before_action :set_account, only: :show

  def show
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end
end
