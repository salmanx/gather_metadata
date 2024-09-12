# Rails API with Sidekiq, Redis, Puppeteer, and Docker

This project is a Rails 7.0.8.4 API-only application using Ruby 3.2.2. It features background job processing with Sidekiq, and Puppeteer for webpage screenshots. The project is fully Dockerized and configured with Redis and Rubocop for code quality checks.

## Table of Contents

- [Setup](#setup)
  - [Prerequisites](#prerequisites)
  - [Docker Setup](#docker-setup)
  - [Manual Setup](#manual-setup)
- [Running the Application](#running-the-application)
- [Running Tests](#running-tests)

---

## Setup

### Prerequisites

Ensure you have the following installed:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Redis](https://redis.io/) (for sidekiq, if running manually)

### Docker Setup

1. Clone this repository:

   ```bash
   git clone https://github.com/salmanx/gather_metadata.git
   cd gather_metadata
   ```

2. Build and start the Docker containers:

   ```bash
   docker-compose up --build
   ```

3. The Rails API will be available at [http://localhost:3000](http://localhost:3000).

4. To stop the containers:
   ```bash
   docker-compose down
   ```

### Manual Setup

If you prefer to run the app without Docker:

1. Install dependencies:

   ```bash
   bundle install
   ```

2. Set up the database:

   ```bash
   rails db:create
   rails db:migrate
   ```

3. Start Redis (required for Sidekiq):

   ```bash
   redis-server
   ```

4. Start Sidekiq (required for Sidekiq):

   ```bash
   bundle exec sidekiq
   ```

5. Run the Rails server:
   ```bash
   rails server
   ```

## Running the Application

Once Docker containers are up, the API will be running at `http://localhost:3000`. Endpoints:

- `/api/v1/assertions` - Create assertions and fetch all assertions

```bash
POST: curl -H 'Content-Type: application/json'  -X POST http://127.0.0.1:3000/api/v1/assertions -d '{ "url":"zenes.ai", "text": "Revamp the QA process"}'
```

```bash
GET: curl http://localhost:3000/api/v1/assertions

```

- `/api/v1/snapshots/:id` - Render the snapshot in web prowser. Please make the request from browser.

## Running Tests

To run tests using RSpec:

```bash
docker exec -it container_id bundle exec rspec
```
