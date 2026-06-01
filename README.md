# Word Complexity API

REST API service that calculates a complexity score for English words using data from Dictionary API.

## Overview

The application accepts a list of words, processes them asynchronously, and returns a complexity score for each word.

Complexity score is calculated using dictionary metadata:

score = (synonyms_count + antonyms_count) / definitions_count

Example:

```json
{
  "happy": 2.9,
  "sad": 1.8
}
```

## Architecture

### Components

* Ruby on Rails API
* PostgreSQL
* Redis
* Sidekiq
* Docker Compose

### Processing Flow

1. Client submits a list of words.
2. Request is stored in PostgreSQL.
3. Sidekiq job is enqueued.
4. Worker fetches dictionary data.
5. Complexity score is calculated.
6. Results are stored in database.
7. Client polls request status.

## API

### Create Complexity Score Request

POST /complexity-score

Request:

```json
[
  "happy",
  "sad"
]
```

Response:

```json
{
  "job_id": "e136d522-5430-44a7-a5c6-8f4273d59587"
}
```

### Example (cURL)

```bash
curl -X POST http://localhost:3000/complexity-score \
  -H "Content-Type: application/json" \
  -d '["happy", "joyful", "sad", "angry"]'
 ```

### Get Request Status

GET /complexity-score/:job_id

Response while processing:

```json
{
  "status": "in_progress"
}
```

Response when completed:

```json
{
  "status": "completed",
  "result": {
    "happy": 2.9,
    "sad": 1.8
  }
}
```

Response on failure:

```json
{
  "status": "failed",
  "error_message": "Connection failed"
}
```

### Example (cURL)

```bash
curl http://localhost:3000/complexity-score/<job_id>
```



## Complexity Formula

The service uses data from:

https://api.dictionaryapi.dev

For each word:

* definitions count = total number of definitions across all meanings
* synonyms count = number of synonyms on meaning level
* antonyms count = number of antonyms on meaning level

Formula:

```text
complexity_score = (synonyms_count + antonyms_count) / definitions_count
```

### Note

The Dictionary API response structure contains synonyms and antonyms in multiple places.

The assignment does not explicitly define which fields should be used.

For simplicity, only meaning-level synonyms and antonyms are included in the calculation.

In a production system this requirement should be clarified with stakeholders.

## Caching

Dictionary API calls are cached in the `cached_words` table.

When a word has already been processed recently, the cached score is reused instead of making another external API request.

Cache TTL:

```ruby
30.days
```

Benefits:

* fewer external API calls
* lower latency
* reduced load on Dictionary API

## Running Locally

Build containers:

```bash
docker compose build
```

Start services:

```bash
docker compose up
```

Run database setup:

```bash
docker compose exec api rails db:create
docker compose exec api rails db:migrate
```

## Running Tests

```bash
docker compose exec api bundle exec rspec
```

## Project Structure

```text
app/
├── controllers
├── workers
├── models
└── services
    ├── dictionary_api
    └── word_complexity
```

### Services

DictionaryApi::Client

Responsible for external Dictionary API communication.

WordComplexity::ExtractFeatures

Extracts dictionary statistics.

WordComplexity::CalculateScore

Calculates final complexity score.

WordComplexity::Pipeline

Coordinates the entire processing workflow.

ComplexityScoreWorker

Runs processing asynchronously using Sidekiq.

## Error Handling

External API failures are handled through Sidekiq job retries.

Request status is updated to failed when processing cannot be completed.

Examples:

* Faraday::ConnectionFailed
* Faraday::TimeoutError
* JSON parsing errors

## Future Improvements

* Redis-based cache
* Batch dictionary requests
* API authentication
* OpenAPI / Swagger documentation
* Metrics and monitoring
* Rate limiting
* Cache invalidation strategy
* Health check endpoint
* Structured logging
* CI/CD pipeline
