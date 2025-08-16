#!/bin/zsh
# Start both backend and frontend servers in one terminal

# Start backend (Rails API)
echo "Starting Rails API..."
cd billit-api && bin/rails server &
BACK_PID=$!
cd ..

# Start frontend (Vite + Vue)
echo "Starting Vite frontend..."
cd billit-frontend && npm run dev &
FRONT_PID=$!
cd ..

# Wait for both processes
wait $BACK_PID $FRONT_PID
