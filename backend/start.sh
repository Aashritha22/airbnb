#!/bin/bash

# Airbnb Clone Backend Startup Script

echo "🚀 Starting Airbnb Clone Backend..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version 18+ is required. Current version: $(node -v)"
    exit 1
fi

# Check if MongoDB is running
if ! command -v mongod &> /dev/null; then
    echo "⚠️  MongoDB is not installed or not in PATH. Please install MongoDB first."
    echo "   Visit: https://docs.mongodb.com/manual/installation/"
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Creating from example..."
    if [ -f env.example ]; then
        cp env.example .env
        echo "✅ .env file created from example. Please update the values."
        echo "   Edit .env file with your configuration before running again."
        exit 1
    else
        echo "❌ env.example file not found. Please create .env file manually."
        exit 1
    fi
fi

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install dependencies."
        exit 1
    fi
    echo "✅ Dependencies installed successfully."
fi

# Check if we should seed the database
if [ "$1" = "--seed" ] || [ "$1" = "-s" ]; then
    echo "🌱 Seeding database with sample data..."
    npm run seed
    if [ $? -ne 0 ]; then
        echo "❌ Failed to seed database."
        exit 1
    fi
    echo "✅ Database seeded successfully."
fi

# Start the server
echo "🌟 Starting server..."
if [ "$NODE_ENV" = "production" ]; then
    echo "🏭 Running in production mode..."
    npm start
else
    echo "🔧 Running in development mode..."
    npm run dev
fi
