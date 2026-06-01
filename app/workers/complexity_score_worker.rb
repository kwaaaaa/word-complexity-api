class ComplexityScoreWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3

  def perform(uuid)
    request = ComplexityScoreRequest.find_by!(uuid: uuid)

    WordComplexity::Pipeline.new(request).call

  rescue => e
    request.update!(
      status: :failed,
      error_message: "#{e.class}: #{e.message}"
    )

    Rails.logger.error(
      "[ComplexityScoreWorker] failed request_uuid=#{uuid} error=#{e.class}: #{e.message}"
    )

    raise e
  end
end
