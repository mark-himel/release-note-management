module Errors
  module Handler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ActiveRecord::RecordNotFound do |error|
          report_to_rollbar(error)
          respond(:record_not_found, 404, error.to_s)
        end
        rescue_from StandardError do |error|
          report_to_rollbar(error)
          respond(:record_not_found, 404, error.to_s)
        end
        rescue_from NoMethodError do |error|
          report_to_rollbar(error)
          respond(:method_not_allowed, 405, error.to_s)
        end
        rescue_from NameError do |error|
          report_to_rollbar(error)
          respond(:record_not_found, 404, error.to_s)
        end
        rescue_from SyntaxError do |error|
          report_to_rollbar(error)
          respond(:bad_request, 400, error.to_s)
        end
      end
    end

    private

    def report_to_rollbar(error)
      ErrorReporter.call(error)
    end

    def respond(error, status, message)
      json = Helpers::Render.json(error, status, message)
      render json: json
    end
  end
end
