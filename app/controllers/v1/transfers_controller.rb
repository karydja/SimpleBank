class V1::TransfersController < V1::BaseController
  def create
    @transfer = TransferOperation.new(
      transfer_params[:source_account_id],
      transfer_params[:destination_account_id],
      transfer_params[:amount].to_s
    ).operate

    render status: :created
  end

  private

  def transfer_params
    params.require(:transfer).permit(
      :amount,
      :destination_account_id,
      :source_account_id
    )
  end
end
