class V1::BaseController < ApplicationController
  ERROR_STATUS_CODES = Hash.new(422).tap do |hash|
    hash['ActiveRecord::RecordNotFound'] = 404
    hash['ActiveRecord::RecordNotSaved'] = 422
    hash['ActiveRecord::ArgumentError'] = 422
    hash['ActiveRecord::ParameterMissing'] = 422
  end

  rescue_from StandardError, with: :handle_error

  private

  def handle_error(error)
    error_class = error.class.name
    error_name = error_class.demodulize
    error_status_code = ERROR_STATUS_CODES[error_class]

    Rails.logger.error("#{error_class} (#{error.message}):")
    Rails.logger.error(error.backtrace.join("\n"))

    render json: {
      errors: [
        {
          status: error_status_code.to_s,
          title: error_name,
          detail: error.message
        }
      ]
    }, status: error_status_code
  end
end
