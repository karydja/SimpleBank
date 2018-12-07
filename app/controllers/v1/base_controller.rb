class V1::BaseController < ApplicationController
  before_action :set_response_content_type
  before_action :check_request_content_type
  before_action :check_request_accept

  ERROR_STATUS_CODES = Hash.new(422).tap do |hash|
    hash['ActiveRecord::RecordNotFound'] = 404
    hash['ActiveRecord::RecordNotSaved'] = 422
    hash['ActiveRecord::ArgumentError'] = 422
    hash['ActiveRecord::ParameterMissing'] = 422
    hash['InvalidRequestContentTypeError'] = 415
    hash['InvalidRequestAcceptError'] = 406
  end

  rescue_from StandardError, with: :handle_error

  private

  def set_response_content_type
    response.set_header('Content-Type', 'application/vnd.api+json')
  end

  def check_request_content_type
    # The JSON:API spec states that the Content-Type is mandatory only when
    # JSON:API data is being sent, so with an empty request body there's no
    # need to check the Content-Type
    # See also https://github.com/emberjs/data/issues/4226#issuecomment-194531920
    return if request.body.size.zero?

    if request.headers['Content-Type'] != 'application/vnd.api+json'
      raise ::InvalidRequestContentTypeError, 'Clients MUST send all JSON:API ' \
        'data in request documents with the header Content-Type: ' \
        'application/vnd.api+json without any media type parameters.'
    end
  end

  def check_request_accept
    return unless request.headers['Accept'].include?('application/vnd.api+json')

    request_accepts = request.headers['Accept'].split(',')

    # Checking if there is a JSON:API mime type without media type parameters,
    # as mandated by the spec
    unless request_accepts.any? { |type| type.strip == 'application/vnd.api+json' }
      raise ::InvalidRequestAcceptError, 'Clients that include the JSON:API ' \
        'media type in their Accept header MUST specify the media type there ' \
        'at least once without any media type parameters.'
    end
  end

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
