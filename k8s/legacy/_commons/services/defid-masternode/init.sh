#!/usr/bin/env bash
# Function to shut down gracefully on various signals
shutdown_program() {
    echo "Shutting down $pid..."
    # Send SIGTERM to defid
    kill -TERM $pid
    sleep 2
    # Wait for defid to shut down
    wait $pid
    echo "Program shut down"
    exit
}

# Function to handle shutdown signals
handle_shutdown_signal() {
    echo "Received shutdown signal"
    shutdown_program
}

# Trap SIGTERM, SIGINT, and SIGHUP signals and execute the handle_shutdown_signal function
trap handle_shutdown_signal SIGTERM SIGINT SIGHUP

# Function to handle masternode_operator logic
handle_masternode_operator() {
    echo "entering keys loop..."
    sum=1
    while IFS="" read -r p || [ -n "$p" ]; do
        x=${p:0:4}
        echo "Importing private key number: $sum, key starts with: $x..."
        
        # Wait every 500 private keys to prevent timeout
        if [ $(( sum % 500 )) -eq 0 ]; then
            echo "Reaching threshold.. waiting 10 seconds.."
            sleep 10
        fi

        defi-cli importprivkey $p '' false
        sum=$((sum + 1))
    done <"/tmp/keys.private"
    sleep 5
    echo "gen=1" >>/data/defi.conf
    echo "Done importing private keys"
}

# Function to start the program and monitor its output
start_program() {
    /app/bin/defid "$@" |
        while IFS= read -r line; do
            echo "$line"

            if [[ $line == *"opencon thread start"* ]]; then
                found_opencon=true
            fi
            if [[ $line == *"addcon thread start"* ]]; then
                found_addcon=true
            fi
            if [[ $line == *"msghand thread start"* ]]; then
                found_msghand=true
            fi
            if [[ $line == *"progress=1.000000"* ]]; then
                found_done_synching=true
            fi
            if [[ $found_opencon && $found_addcon && $found_msghand && $found_done_synching ]]; then
                echo "All conditions met. Handling masternode operator..."
                sleep 10
                handle_masternode_operator
                echo "Going to stop now"
                defi-cli stop
                sleep 20
                return
            fi
            if [[ $line == *"ThreadStaker"* ]]; then
                found_thread_staker=true
            fi
            if [[ $line == *"Potential stale tip detected, will try using extra outbound peer"* ]]; then
                found_potential_stale=true
            fi
            if [[ $line == *"waiting init"* ]]; then
                found_waiting_init=true
            fi

            if [[ $found_thread_staker && $found_potential_stale && $found_waiting_init ]]; then
                echo "Going to stop now due to Potential stale tip detected"
                defi-cli stop
                sleep 30
                echo "starting again..."
                start_program
            fi
            if [[ $line == *"ERROR:: Data corruption detected."* ]] ||
                [[ $line == *": Error opening block database."* ]] ||
                [[ $line == *": Error initializing block database."* ]]; then
                echo "Storage Error detected. We will recreate this master from snapshot..."
                defi-cli stop
                sleep 5
                rm -rf /data/*
                echo "removed data folder, stoped defid, going to start it again to rebuild from snap"

                exit 1
            fi
        done
}

run_program() {
    echo "Run program now for PROD; you will see rainbows and uniconrs now"
    /app/bin/defid "$@" |
        while IFS= read -r line; do
            echo "$line"
            # do some other stuff
        done
}

# Start the program with default arguments
echo "Starting defid program for init checks"
start_program
# Run defid for PROD.
run_program &

pid=$!

# Wait for the defid process to finish
wait $pid

# Once defid is finished, shut down the script
shutdown_program
