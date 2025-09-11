# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a Ruby on Rails 7.1 attendance system application using MySQL as the database. The project is designed to run in a containerized environment using Docker and Docker Compose.

**Tech Stack:**
- Ruby 3.0.6
- Rails 7.1.0
- MySQL 5.7
- Docker & Docker Compose
- Hotwire (Turbo + Stimulus)
- Asset Pipeline with Importmap

## Development Commands

### Docker Development Environment

The application is primarily designed to run in Docker containers. All development should use Docker Compose:

```bash
# Start the application with all services
docker-compose up

# Start in detached mode
docker-compose up -d

# Stop all services
docker-compose down

# Rebuild and start (after Gemfile changes)
docker-compose up --build

# View logs
docker-compose logs -f web
docker-compose logs -f db
```

The application will be available at http://localhost:3107 (Rails server) and MySQL will be accessible on port 3399.

### Rails Commands (via Docker)

Execute Rails commands within the container:

```bash
# Generate new Rails components
docker-compose exec web rails generate controller ControllerName
docker-compose exec web rails generate model ModelName
docker-compose exec web rails generate migration MigrationName

# Database operations
docker-compose exec web rails db:create
docker-compose exec web rails db:migrate
docker-compose exec web rails db:rollback
docker-compose exec web rails db:seed
docker-compose exec web rails db:reset
docker-compose exec web rails db:prepare

# Console access
docker-compose exec web rails console

# Routes inspection
docker-compose exec web rails routes

# Start Rails server manually (if needed)
docker-compose exec web rails server -b 0.0.0.0 -p 3000
```

### Testing Commands

The application uses Rails' built-in testing framework with Capybara and Selenium for system tests:

```bash
# Run all tests
docker-compose exec web rails test

# Run specific test types
docker-compose exec web rails test:models
docker-compose exec web rails test:controllers
docker-compose exec web rails test:system

# Run a single test file
docker-compose exec web rails test test/models/model_name_test.rb

# Run a specific test method
docker-compose exec web rails test test/models/model_name_test.rb::test_method_name
```

### Bundle Management

```bash
# Install new gems (after updating Gemfile)
docker-compose exec web bundle install

# Update gems
docker-compose exec web bundle update

# Check gem versions
docker-compose exec web bundle list
```

## Project Architecture

### Application Structure

This is a fresh Rails 7.1 application with the standard MVC architecture:

- **Models** (`app/models/`): Currently contains only `ApplicationRecord` as the base class
- **Controllers** (`app/controllers/`): Contains `ApplicationController` as the base controller
- **Views** (`app/views/`): Contains layout templates; view templates will be added as features are built
- **Routes** (`config/routes.rb`): Currently minimal with only health check route

### Database Configuration

- **Production Database**: MySQL with connection pooling
- **Development Database**: `app_development` on MySQL container
- **Test Database**: `app_test` on MySQL container
- **Database Host**: `db` (Docker service name)
- **MySQL Port**: 3399 (external), 3306 (internal)
- **Default Credentials**: root/password (development only)

### Docker Configuration

The application uses multi-stage Docker builds:

- **Development**: Full development environment with hot reloading via volume mounts
- **Production**: Optimized image with precompiled assets and minimal dependencies
- **Database**: MySQL 5.7 with persistent volume storage and health checks

### Key Configuration Files

- `docker-compose.yml`: Orchestrates web and database services
- `Dockerfile`: Multi-stage build for production-ready container
- `config/database.yml`: Database configuration for all environments
- `bin/setup`: Automated development environment setup script

## Development Workflow

### First Time Setup

```bash
# Clone and enter the repository
cd "Attendance System/attndance_app"

# Start the development environment
docker-compose up --build

# The application will automatically:
# - Install dependencies
# - Setup the database
# - Start the Rails server
```

### Adding New Features

1. **Models**: Generate with appropriate migrations
   ```bash
   docker-compose exec web rails generate model User name:string email:string
   docker-compose exec web rails db:migrate
   ```

2. **Controllers**: Generate with associated views
   ```bash
   docker-compose exec web rails generate controller Users index show new create edit update destroy
   ```

3. **Routes**: Update `config/routes.rb` to define application endpoints

4. **Tests**: Write corresponding tests in the `test/` directory

### Database Operations

The application uses Rails migrations for database schema management. No migrations exist yet, indicating this is a fresh setup ready for feature development.

### Asset Management

- **JavaScript**: Uses Importmap for modern JavaScript without bundling
- **CSS**: Traditional asset pipeline with Sprockets
- **Stimulus Controllers**: Place in `app/javascript/controllers/`
- **Stylesheets**: Place in `app/assets/stylesheets/`

## Environment Notes

- **Ruby Version**: Fixed at 3.0.6 (see `.ruby-version`)
- **Rails Environment**: Development mode in Docker
- **Asset Compilation**: Automatic in development, precompiled in production builds
- **Log Level**: Standard Rails logging to `log/development.log`
- **Persistent Data**: MySQL data persists in Docker volume `mysql_data`
