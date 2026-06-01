class ComplexityScoresController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from InvalidWordsError, JSON::ParserError, with: :render_bad_request

  before_action :parse_words, only: :create

  def create
    request_record = ComplexityScoreRequest.create!(
      words: @words,
      status: :pending
    )

    ComplexityScoreWorker.perform_async(request_record.uuid)

    render json: { job_id: request_record.uuid }, status: :accepted
  end

  def show
    request_record = ComplexityScoreRequest.find_by!(uuid: params[:job_id])

    if request_record.completed?
      render json: {
        status: "completed",
        result: request_record.result
      }
    else
      render json: {
        status: request_record.status
      }
    end
  end

  private

  def parse_words
    @words = JSON.parse(request.raw_post)

    unless @words.is_a?(Array) && @words.all? { |w| w.is_a?(String) }
      raise InvalidWordsError, "Words must be an array of strings"
    end
  end

  def render_bad_request(exception)
    render json: {
      error: exception.message
    }, status: :bad_request
  end

  def render_not_found
    render json: {
      status: 404,
      error: "Not Found"
    }, status: :not_found
  end
end
