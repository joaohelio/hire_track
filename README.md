# Tracking Job Application System

It implements a Job Application Tracking System using Clean Architecture principles and the Event Sourcing pattern.

## Architecture Overview

The application follows following layers:

1. **Controllers (API)** - API endpoints that handle HTTP requests and responses
2. **Interactors (Use Cases)** - Application-specific business rules and workflows
3. **Entities** - Represent the core business objects in the domain.
4. **Repositories** - Data access layer that abstracts the persistence mechanism
5. **Models** - ActiveRecord models that represent the database tables

## API Endpoints

- `GET /jobs` - Lists all jobs (activated and deactivated) with stats
- `GET /applications` - Lists all applications for activated jobs

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Installation

1. Clone the repository

2. Install dependencies:
   ```
   alias dc-dev="docker compose -f docker-compose.yml"

   dc-dev build app
   ```

3. Set up the database:
   ```
   dc-dev run app bundle exec rails db:create
   dc-dev run app bundle exec rails db:migrate
   dc-dev run app bundle exec rails db:seed
   ```

4. Run the tests:
   ```
   alias dc-test="docker compose -f docker-compose.yml -f docker-compose.test.yml"

   dc-test run app bundle exec rspec
   ```

5. Start the server:
   ```
   dc-dev up
   ```

## Database Schema

The application uses the following database tables:

- `jobs` - Stores job information
- `applications` - Stores applications connecting candidates to jobs
- `events` - Stores events for jobs and applications (uses single table inheritance)

## Design Decisions

### Why Clean Architecture?

Clean Architecture was chosen to:
- Separate business logic from framework dependencies
- Make the codebase more testable
- Allow for easier changes to the infrastructure layer
- Provide a clear structure that aligns with domain-driven design principles
