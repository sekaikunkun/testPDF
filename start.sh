#!/bin/bash

APP_NAME="word2pdf-0.0.1-SNAPSHOT.jar"
LOG_FILE="app.log"
PID_FILE="app.pid"

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed. Please install JDK 8."
    exit 1
fi

start() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE"); then
        echo "⚠️  App is already running with PID $(cat "$PID_FILE")"
        return
    fi

    echo "🚀 Starting $APP_NAME..."
    nohup java -jar target/$APP_NAME > $LOG_FILE 2>&1 &
    echo $! > $PID_FILE
    echo "✅ App started! PID: $(cat "$PID_FILE")"
    echo "📜 Logs are being written to $LOG_FILE"
}

stop() {
    if [ ! -f "$PID_FILE" ] || ! kill -0 $(cat "$PID_FILE"); then
        echo "⚠️  App is not running"
        return
    fi

    PID=$(cat "$PID_FILE")
    echo "🛑 Stopping app (PID: $PID)..."
    kill $PID
    rm "$PID_FILE"
    echo "✅ App stopped"
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        sleep 2
        start
        ;;
    status)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE"); then
            echo "✅ App is running (PID: $(cat "$PID_FILE"))"
        else
            echo "🔴 App is NOT running"
        fi
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
esac
